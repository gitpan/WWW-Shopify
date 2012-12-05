#!/usr/bin/perl

=head1 NAME

WWW::Shopify - Main object representing acess to a particular Shopify store.

=cut

=head1 DESCRIPTION

WWW::Shopify represents a way to grab and upload data to a particular shopify store.
All that's required is the access token for a particular app, its url, and the API key, or altenratively, if you have a private app, you can substitue the app password for the api key.
If you want to use make a private app, use WWW::Shopify::Private. If you want to make a public app, use WWW::Shopify::Public.

=cut

=head1 EXAMPLES

In order to get a list of all products, we can do the following:

	# Here we instantiate a copy of the public API object, with all the necessary fields.
	my $SA = new WWW::Shopify::Public($ShopURL, $APIKey, $AccessToken);

	# Here we call get_all, OO style, and specify the entity we want to get.
	my @Products = $SA->get_all('WWW::Shopify::Product');

In this way, we can get and modify all the different types of shopify stuffs.

If you don't want to be using a public app, and just want to make a private app, it's just as easy:

	# Here we instantiate a copy of the private API object this time, which means we don't need an access token, we just need a password.
	my $sa = new WWW::Shopify::Private($shop_url, $api_key, $password);
	my @Products = $SA->get_all('WWW::Shopify::Model::Product');

Easy enough.

To insert a Webhook, we'd do the following.

	my $webhook = new WWW::Shopify::Webhook({topic => "orders/create", address => $URL, format => "json"});
	$SA->create($Webhook);

And that's all there is to it. To delete all the webhooks in a store, we'd do:

	my @Webhooks = $SA->get_all('WWW::Shopify::Webhook');
	for (@Webhooks) {
		$SA->delete($_);
	}

Very easy.

=cut

use strict;
use warnings;
use LWP::UserAgent;
use JSON;
use URI::Escape;

package WWW::Shopify;

our $VERSION = '0.01';

use constant {
	RELATION_OWN_ONE => 0,
	RELATION_REF_ONE => 10,
	RELATION_MANY => 20
}; 

use WWW::Shopify::Exception;
use WWW::Shopify::Field;
use Data::Dumper;
use Module::Find;

# Make sure we include all our models so that when people call the model, we actually know what they're talking about.
BEGIN {	eval(join("\n", map { "require $_;" } findallmod WWW::Shopify::Model)); }

package WWW::Shopify::URLHandler;

sub new($) { return bless {_parent => $_[1]}, $_[0]; }
sub parent { $_[0]->{_parent} = $_[1] if defined $_[1]; return $_[0]->{_parent}; }

sub get_url($$@) {
	my ($self, $url, $parameters) = @_;
	my $uri = URI->new($url);
	$uri->query_form($parameters);
	my $request = HTTP::Request->new("GET", $uri);
	$request->header("Accept" => "application/json");
	my $response = $self->parent->ua->request($request);
	die new WWW::Shopify::Exception::CallLimit($response) if $response->code() == 503;
	die new WWW::Shopify::Exception($response) unless ($response->is_success);
	my $decoded = JSON::decode_json($response->content);
	return ($decoded, $response);
}

sub use_url($$$$) {
	my ($self, $method, $url, $hash) = @_;
	my $request = HTTP::Request->new($method, $url);
	$request->header("Accept" => "application/json", "Content-Type" => "application/json");
	$request->content(JSON::encode_json($hash));
	my $response = $self->parent->ua->request($request);
	die new WWW::Shopify::Exception::CallLimit($response) if $response->code() == 503;
	die new WWW::Shopify::Exception($response) unless ($response->is_success);
	my $decoded = (length($response->content) >= 2) ? JSON::decode_json($response->content) : undef;
	return ($decoded, $response);
}
sub put_url($$$) { return shift->use_url("PUT", @_); }
sub post_url($$$) { return shift->use_url("POST", @_); }
sub delete_url($$$) { return shift->use_url("DELETE", @_); }

package WWW::Shopify;

=head1 METHODS

=head2 api_key

Gets/sets the applciation api key to use for this particular app.

=head2 shop_url

Gets/sets the shop url that we're going to be making calls to.

=cut

# Modifiable Attributes
sub api_key { $_[0]->{apiKey} = $_[1] if defined $_[1]; return $_[0]->{api_key}; }
sub shop_url { $_[0]->{shopUrl} = $_[1] if defined $_[1]; return $_[0]->{shop_url}; }

sub translate_model($) {
	return $_[0] if $_[0] =~ m/WWW::Shopify::Model/;
	return "WWW::Shopify::Model::" . $_[0];
}

use constant {
	PULLING_ITEM_LIMIT => 50
};

sub get_url($$@) { return $_[0]->url_handler()->get_url($_[0]->encode_url($_[1]), $_[2]); }
sub post_url($$@) { return $_[0]->url_handler()->post_url($_[0]->encode_url($_[1]), $_[2]); }
sub put_url($$@) { return $_[0]->url_handler()->put_url($_[0]->encode_url($_[1]), $_[2]); }
sub delete_url($$@) { return $_[0]->url_handler()->delete_url($_[0]->encode_url($_[1]), $_[2]); }

sub resolve_trailing_url($$$) {
	my ($self, $package, $parentId) = @_;
	my $container = $package->container();
	return "/admin/" . $package->plural() unless (defined $container);
	die new WWW::Shopify::Exception("Must pass in a 'parent' field, in your specs when calling $package.") unless defined $parentId;
	return "/admin/" . $container->plural() . "/" . $parentId . "/" . $package->plural();
}

sub get_all_limit($$@) {
	my ($self, $package, $specs) = @_;
	my ($decoded, $response) = $self->get_url($self->resolve_trailing_url($package, $specs->{parent}) . ".json", $specs);

	my @return = ();
	foreach my $element (@{$decoded->{$package->plural()}}) {
		my $class = $package->from_json($element);
		$class->{parent_id} = $specs->{parent} if ($package->container());
		push(@return, $class);
	}
	return @return;
}

sub get_all($$@) {
	my ($self, $package, $specs) = @_;
	$self->validate_item($package);

	return $self->get_all_limit($package, $specs) if (exists $specs->{"limit"} && $specs->{"limit"} <= PULLING_ITEM_LIMIT);
	if ($package->countable()) {
		my $itemCount = $self->get_count($package, $specs);
		return $self->get_all_limit($package, $specs) if ($itemCount <= PULLING_ITEM_LIMIT);
		die new WWW::Shopify::Exception("OVER LIMIT GET; NOT IMPLEMENTED.") if $itemCount > PULLING_ITEM_LIMIT;
	}
	else {
		return $self->get_all_limit($package, $specs);
	}
}

sub get_shop($) {
	my $SA = shift;
	my $package = 'WWW::Shopify::Model::Shop';

	my ($decoded, $response) = $SA->get_url("/admin/" . $package->singular() . ".json");
	return $package->from_json($decoded->{$package->singular()});
}

sub get_count($$@) {
	my ($self, $package, $specs) = @_;
	$self->validate_item($package);
	die "Cannot count $package." unless $package->countable();
	my ($decoded, $response) = $self->get_url($self->resolve_trailing_url($package, $specs->{parent}) . "/count.json", $specs);
	return $decoded->{'count'};
}

sub get($$$@) {
	my ($self, $package, $id, $specs) = @_;
	$self->validate_item($package);

	my $plural = $package->plural();
	# We have a special case for asssets, for some arbitrary reason.
	my ($decoded, $response);
	if ($package !~ m/Asset/) {
		($decoded, $response) = $self->get_url($self->resolve_trailing_url($package, $specs->{parent}) . "/$id.json");
	} else {
		die new WWW::Shopify::Exception("MUST have a parent with assets.") unless $specs->{parent};
		($decoded, $response) = $self->get_url("/admin/themes/" . $specs->{parent} . "/assets.json", {'asset[key]' => $id, theme_id => $specs->{parent}});
	}

	my @return = ();
	my $element = $decoded->{$package->singular()};
	my $class = $package->from_json($element);
	$class->{parent_id} = $specs->{parent} if ($package->container());
	return $class;
}

use List::Util qw(first);
sub create($$@) {
	my ($self, $item) = @_;
	$self->validate_item(ref($item));
	my $specs = {};
	die new WWW::Shopify::Exception("Missing minimal creation member $_.") if first { !defined $item->{$_} } (@{$item->minimal()});
	for (keys(%$item)) {
		$specs->{$_} = $item->{$_};
	}
	my ($decoded, $response) = $self->post_url($self->resolve_trailing_url($item, $specs->{parent}) . ".json", {$item->singular() => $specs});
	my $element = $decoded->{$item->singular()};

	return ref($item)->from_json($element);
}

sub update {
	my ($self, $class) = @_;
	$self->validate_item(ref($class));

	my $mods = $class->mods();
	my $plural = $class->plural();
	my $vars = {};
	for (keys(%{$mods})) { $vars->{$_} = $class->$_ if exists $class->{$_}; }
	my $hash = { $class->singular() => $vars };
	my ($decoded, $response);
	if (ref($class) !~ m/Asset/) {
		($decoded, $response) = $self->put_url($self->resolve_trailing_url($class, 0) . "/" . $class->id() . ".json", $hash);
	} else {
		($decoded, $response) = $self->put_url("/admin/themes/" . $class->{container_id} . "/assets.json", $hash);
	}
	my $element = $decoded->{$class->singular()};
	return ref($class)->from_json($element);
}

sub delete {
	my ($self, $class) = @_;
	$self->validate_item(ref($class));
	my $plural = $class->plural();
	die new WWW::Shopify::Exception("Class in deletion must be not null, and must be a blessed reference to a model object: " . ref($class)) unless ref($class) =~ m/Model/;
	my ($decoded, $response) = $self->delete_url($self->resolve_trailing_url($class, 0) . "/" . $class->id() . ".json");

	return 1;
}

# This function is solely for charges.
sub activate {
	my ($self, $object) = @_;
	die new WWW::Shopify::Exception("You must activate charges.") unless defined $object && $object->activatable;
	my $specs = {};
	my $fields = $object->fields();
	for (keys(%$fields)) { $specs->{$_} = $object->$_(); }

	my ($decoded, $response) = $self->post_url("/admin/" . $object->plural() . "/" . $object->id() . "/activate.json", {$object->singular() => $specs});

	return 1;
}

sub is_valid { eval { $_[0]->get_count('WWW::Shopify::Model::Prouduct'); }; return undef if ($@); return 1; }

# Internal methods.
sub validate_item { eval { die unless $_[1]; $_[1]->is_item; }; die new WWW::Shopify::Exception($_[1] . " is not an item!") if ($@); }

=head1 SEE ALSO

L<WWW::Shopify::Public>, L<WWW::Shopify::Private>, L<WWW::Shopify::Test>, L<WWW::Shopify::Item>, L<WWW::Shopify::Common::DBIx>

=head1 AUTHOR

Adam Harrison (adamdharrison@gmail.com)

=head1 LICENSE

See LICENSE in the main directory.

=cut

1;
