#!/usr/bin/perl

=head1 NAME

WWW::Shopify - Main object representing acess to a particular Shopify store.

=cut

=head1 DISCLAIMER

WWW::Shopify is my first official CPAN module, so please bear with me as I try to sort out all the bugs, and deal with the unfamiliar CPAN infrastructure. Don't expect this to work out of the box as of yet, I'm still learning exactly how things are working.

Thanks for your understanding.

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
	my @Products = $SA->get_all('Product');

In this way, we can get and modify all the different types of shopify stuffs.

If you don't want to be using a public app, and just want to make a private app, it's just as easy:

	# Here we instantiate a copy of the private API object this time, which means we don't need an access token, we just need a password.
	my $sa = new WWW::Shopify::Private($shop_url, $api_key, $password);
	my @Products = $SA->get_all('Product');

Easy enough.

To insert a Webhook, we'd do the following.

	my $webhook = new WWW::Shopify::Model::Webhook({topic => "orders/create", address => $URL, format => "json"});
	$SA->create($Webhook);

And that's all there is to it. To delete all the webhooks in a store, we'd do:

	my @Webhooks = $SA->get_all('Webhook');
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

our $VERSION = '0.13';

use WWW::Shopify::Exception;
use WWW::Shopify::Field;
use Data::Dumper;
use Module::Find;
use WWW::Shopify::URLHandler;

# Make sure we include all our models so that when people call the model, we actually know what they're talking about.
BEGIN {	eval(join("\n", map { "require $_;" } findallmod WWW::Shopify::Model)); }

package WWW::Shopify;

=head1 METHODS

=head2 api_key

Gets/sets the applciation api key to use for this particular app.

=head2 shop_url

Gets/sets the shop url that we're going to be making calls to.

=cut

# Modifiable Attributes
sub api_key { $_[0]->{_api_key} = $_[1] if defined $_[1]; return $_[0]->{_api_key}; }
sub shop_url { $_[0]->{_shop_url} = $_[1] if defined $_[1]; return $_[0]->{_shop_url}; }

sub translate_model($) {
	return $_[1] if $_[1] =~ m/WWW::Shopify::Model/;
	return "WWW::Shopify::Model::" . $_[1];
}

use constant {
	PULLING_ITEM_LIMIT => 250
};

sub get_url($$@) { return $_[0]->url_handler()->get_url($_[0]->encode_url($_[1]), $_[2]); }
sub post_url($$@) { return $_[0]->url_handler()->post_url($_[0]->encode_url($_[1]), $_[2]); }
sub put_url($$@) { return $_[0]->url_handler()->put_url($_[0]->encode_url($_[1]), $_[2]); }
sub delete_url($$@) { return $_[0]->url_handler()->delete_url($_[0]->encode_url($_[1]), $_[2]); }

sub resolve_trailing_url($$$) {
	my ($self, $package, $parent_id, $parent_container) = @_;
	my $container = ($parent_container ? $parent_container : $package->container());
	return "/admin/" . $package->plural() unless (defined $container);
	die new WWW::Shopify::Exception("Must pass in a 'parent' field, in your specs when calling $package.") unless defined $parent_id;
	return "/admin/" . $container->plural() . "/" . $parent_id . "/" . $package->plural();
}

sub get_all_limit($$@) {
	my ($self, $package, $specs) = @_;
	$package = $self->translate_model($package);

	$specs->{"limit"} = PULLING_ITEM_LIMIT unless exists $specs->{"limit"};

	my ($decoded, $response) = $self->get_url($self->resolve_trailing_url($package, $specs->{parent}, $specs->{parent_container}) . ".json", $specs);

	my @return = ();
	foreach my $element (@{$decoded->{$package->plural()}}) {
		my $class = $package->from_json($element);
		$class->{parent_id} = $specs->{parent} if ($package->container());
		$class->associate($self);
		push(@return, $class);
	}
	return @return;
}

use POSIX qw/ceil/;
sub get_all {
	my ($self, $package, $specs) = @_;
	$package = $self->translate_model($package);
	$self->validate_item($package);
	return $self->get_all_limit($package, $specs) if ((defined $specs->{"limit"} && $specs->{"limit"} <= PULLING_ITEM_LIMIT) || !$package->countable());

	my $item_count = $self->get_count($package, $specs);
	die new WWW::Shopify::Exception("OVER LIMIT GET; NOT IMPLEMENTED.") if $item_count > PULLING_ITEM_LIMIT*200;
	return $self->get_all_limit($package, $specs) if ($item_count <= PULLING_ITEM_LIMIT);

	my $page_count = ceil($item_count / PULLING_ITEM_LIMIT);
	my @items = ();
	for (my $c = 0; $c < $page_count; ++$c) {
		$specs->{page} = ($c+1);
		push(@items, $self->get_all_limit($package, $specs));
	}
	return @items;
}

sub get_shop($) {
	my ($self) = @_;
	my $package = 'WWW::Shopify::Model::Shop';
	my ($decoded, $response) = $self->get_url("/admin/" . $package->singular() . ".json");
	return $package->from_json($decoded->{$package->singular()});
}

sub get_count($$@) {
	my ($self, $package, $specs) = @_;
	$package = $self->translate_model($package);
	$self->validate_item($package);
	die "Cannot count $package." unless $package->countable();
	my ($decoded, $response) = $self->get_url($self->resolve_trailing_url($package, $specs->{parent}, $specs->{parent_container}) . "/count.json", $specs);
	return $decoded->{'count'};
}

sub get($$$@) {
	my ($self, $package, $id, $specs) = @_;
	$package = $self->translate_model($package);
	$self->validate_item($package);

	my $plural = $package->plural();
	# We have a special case for asssets, for some arbitrary reason.
	my ($decoded, $response);
	if ($package !~ m/Asset/) {
		($decoded, $response) = $self->get_url($self->resolve_trailing_url($package, $specs->{parent}, $specs->{parent_container}) . "/$id.json");
	} else {
		die new WWW::Shopify::Exception("MUST have a parent with assets.") unless $specs->{parent};
		($decoded, $response) = $self->get_url("/admin/themes/" . $specs->{parent} . "/assets.json", {'asset[key]' => $id, theme_id => $specs->{parent}});
	}

	my @return = ();
	my $element = $decoded->{$package->singular()};
	my $class = $package->from_json($element);
	$class->{parent_id} = $specs->{parent} if ($package->container());
	$class->associate($self);
	return $class;
}

sub search {
	my ($self, $package, $specs) = @_;
	$package = $self->translate_model($package);
	die new WWW::Shopify::Exception("Unable to search $package; it is not marked as searchable in Shopify's API.") unless $package->searchable;
	die new WWW::Shopify::Exception("Must have a query to search.") unless $specs && $specs->{query};
	$self->validate_item($package);

	my $plural = $package->plural();
	my ($decoded, $response) = $self->get_url($self->resolve_trailing_url($package, $specs->{parent}, $specs->{parent_container}) . "/search.json", $specs);

	my @return = ();
	foreach my $element (@{$decoded->{$package->plural()}}) {
		my $class = $package->from_json($element);
		$class->{parent_id} = $specs->{parent} if ($package->container());
		$class->associate($self);
		push(@return, $class);
	}
	return @return;
}

use List::Util qw(first);
use HTTP::Request::Common;
sub create {
	my ($self, $item) = @_;
	$self->validate_item(ref($item));
	my $specs = {};
	my $missing = first { !defined $item->{$_} } (@{$item->minimal()});
	die new WWW::Shopify::Exception("Missing minimal creation member: $missing in " . ref($item)) if $missing;
	die new WWW::Shopify::Exception(ref($item) . " requires you to login with an admin account.") if $item->needs_login && !$self->logged_in_admin;
	$specs = $item->to_json();
	if ($item->needs_login) {
		my @fields = map { my $a; $item->singular . "[$_]" => $specs->{$_} } keys(%$specs);
		my $url = $self->encode_url($self->resolve_trailing_url($item, $item->{parent}, $specs->{parent_container})) . ".json";
		my $response = $self->ua->request(POST $url, [authenticity_token => $self->{authenticity_token}, @fields], Accept => 'application/json');
	 	my $json = JSON::decode_json($response->decoded_content);
		return ref($item)->from_json($json->{$item->singular});
	}
	my $method = lc($item->create_method) . "_url";
	my ($decoded, $response) = $self->$method($self->resolve_trailing_url($item, $item->{parent}, $specs->{parent_container}) . ".json", {$item->singular() => $specs});
	my $element = $decoded->{$item->singular()};
	my $object = ref($item)->from_json($element);
	$object->associate($self);
	return $object;
}

sub update {
	my ($self, $class) = @_;
	$self->validate_item(ref($class));
	die new WWW::Shopify::Exception(ref($class) . " requires you to login with an admin account.") if $class->needs_login && !$self->logged_in_admin;

	my $mods = $class->mods();
	my $plural = $class->plural();
	my $vars = $class->to_json();
	$vars = {map { $_ => $vars->{$_} } grep { exists $mods->{$_} } keys(%$vars)};
	my $hash = { $class->singular() => $vars };
	my ($decoded, $response);
	my $method = lc($class->update_method) . "_url";
	if (ref($class) !~ m/Asset/) {
		($decoded, $response) = $self->$method($self->resolve_trailing_url($class, 0) . "/" . $class->id() . ".json", $hash);
	} else {
		($decoded, $response) = $self->$method("/admin/themes/" . $class->{container_id} . "/assets.json", $hash);
	}
	my $element = $decoded->{$class->singular()};
	my $object = ref($class)->from_json($element);
	$object->associate($self);
	return $object;
}

sub delete {
	my ($self, $class) = @_;
	$self->validate_item(ref($class));
	die new WWW::Shopify::Exception(ref($class) . " requires you to login with an admin account.") if $class->needs_login && !$self->logged_in_admin;
	my $plural = $class->plural();
	die new WWW::Shopify::Exception("Class in deletion must be not null, and must be a blessed reference to a model object: " . ref($class)) unless ref($class) =~ m/Model/;
	if ($class->needs_login) {
		my $url = $self->encode_url($self->resolve_trailing_url($class, $class->parent)) . "/" . $class->id();
		my $response = $self->ua->request(POST $url, [authenticity_token => $self->{authenticity_token}, "_method" => "delete"], Accept => 'application/json');
		return $response;
	}
	else {
		my $method = lc($class->delete_method) . "_url";
		my ($decoded, $response) = $self->$method($self->resolve_trailing_url($class, 0) . "/" . $class->id() . ".json");
	}

	return 1;
}

# This function is solely for charges.
sub activate {
	my ($self, $object) = @_;
	die new WWW::Shopify::Exception("You can only activate charges.") unless defined $object && $object->activatable;
	my $specs = {};
	my $fields = $object->fields();
	for (keys(%$fields)) {
		if ($object->$_ && ref($object->$_) eq "DateTime") {
			$specs->{$_} = $object->$_->strftime('%Y-%m-%dT%H-%M-%S%z');
			$specs->{$_} =~ s/(\d\d)$/:$1/;
		}
		else {
			$specs->{$_} = $object->$_;
		}
	}

	my ($decoded, $response) = $self->post_url("/admin/" . $object->plural() . "/" . $object->id() . "/activate.json", {$object->singular() => $specs});
	my $element = $decoded->{$object->singular()};
	return ref($object)->from_json($element);
}

use HTTP::Request::Common;
sub login_admin {
	my ($self, $username, $password) = @_;
	return 1 if $self->{last_login_check} && (time - $self->{last_login_check}) < 1000;
	my $ua = $self->ua;
	die new WWW::Shopify::Exception("Unable to login as admin without a cookie jar.") unless defined $ua->cookie_jar;
	my $res = $ua->get("https://" . $self->shop_url . "/admin/auth/login");
	die new WWW::Shopify::Exception("Unable to get login page.") unless $res->is_success;
	die new WWW::Shopify::Exception("Unable to find authenticity token.") unless $res->decoded_content =~ m/name="authenticity_token".*?value="(\S+)"/ms;
	my $authenticity_token = $1;
	my $req = POST "https://" . $self->shop_url . "/admin/auth/login", [
		login => $username,
		password => $password,
		remember => 1,
		commit => "Sign In",
		authenticity_token => $authenticity_token
	];
	$res = $ua->request($req);
	die new WWW::Shopify::Exception("Unable to complete request: " . $res->decoded_content) unless $res->is_success || $res->code == 302;
	die new WWW::Shopify::Exception("Unable to login: $1.") if $res->decoded_content =~ m/class="status system-error">(.*?)<\/div>/;
	$self->{last_login_check} = time;
	$self->{authenticity_token} = $authenticity_token;
	return 1;
}

sub logged_in_admin {
	my ($self) = @_;
	return 1 if $self->{last_login_check} && (time - $self->{last_login_check}) < 1000;
	my $ua = $self->ua;
	die new WWW::Shopify::Exception("Unable to login as admin without a cookie jar.") unless defined $ua->cookie_jar;
	my $res = $ua->get('https://' . $self->shop_url . '/admin/discounts/count.json');
	if ($res->is_success) {
		$self->{last_login_check} = time;
		return 1;
	}
	return undef;
}

sub is_valid { eval { $_[0]->get_shop; }; return undef if ($@); return 1; }

# Internal methods.
sub validate_item { eval { die unless $_[1]; $_[1]->is_item; }; die new WWW::Shopify::Exception($_[1] . " is not an item!") if ($@); }

=head2 calc_webhook_signature

Calculates the webhook_signature based off the shared secret and request body passed in.

=cut

=head2 verify_webhook

Shopify webhook authentication. ALMOST the same as login authentication, but, of course, because this is shopify they've got a different system. 'Cause you know, one's not good enough.

Follows this: http://wiki.shopify.com/Verifying_Webhooks.

=cut

use Exporter 'import';
our @EXPORT_OK = qw(verify_webhook verify_login verify_proxy calc_webhook_signature calc_login_signature calc_proxy_signature);
use Digest::MD5 'md5_hex';
use Digest::SHA qw(hmac_sha256_hex hmac_sha256_base64);
use MIME::Base64;

sub calc_webhook_signature {
	my ($shared_secret, $request_body) = @_;
	my $calc_signature = hmac_sha256_base64((defined $request_body) ? $request_body : "", $shared_secret);
	while (length($calc_signature) % 4) { $calc_signature .= '='; }
	return $calc_signature;
}

sub verify_webhook {
	my ($x_shopify_hmac_sha256, $request_body, $shared_secret) = @_;
	return undef unless $x_shopify_hmac_sha256;
	return $x_shopify_hmac_sha256 eq calc_webhook_signature($shared_secret, $request_body);
}

=head2 calc_login_signature

Calculates the login signature based on the shared secret and parmaeter hash passed in.

=cut

=head2 verify_login

Shopify app dashboard verification (when someone clicks Login on the app dashboard).

This one was kinda random, 'cause they say it's like a webhook, but it's actually like legacy auth.

Also, they don't have a code parameter. For whatever reason.

=cut

sub calc_login_signature {
	my ($shared_secret, $params) = @_;
	return md5_hex($shared_secret . join("", map { "$_=" . $params->{$_} } (grep { $_ ne "signature" } keys(%$params))));
}

sub verify_login {
	my ($shared_secret, $params) = @_;
	return undef unless $params->{signature};
	return calc_login_signature($shared_secret, $params) eq $params->{signature};
}

=head2 calc_proxy_signature

Based on shared secret/hash of parameters passed in, calculates the proxy signature.

=cut

=head2 verify_proxy

This is SLIGHTLY different from the above two. For, as far as I can tell, no reason.

=cut

sub calc_proxy_signature {
	my ($shared_secret, $params) = @_;
	return hmac_sha256_hex(join("", sort(map { "$_=" . $params->{$_} } (grep { $_ ne "signature" } keys(%$params)))), $shared_secret);
}

sub verify_proxy { 
	my ($shared_secret, $params) = @_;
	return undef unless $params->{signature};
	return calc_proxy_signature($shared_secret, $params) eq $params->{signature};
}

=head1 SEE ALSO

L<WWW::Shopify::Public>, L<WWW::Shopify::Private>, L<WWW::Shopify::Test>, L<WWW::Shopify::Item>, L<WWW::Shopify::Common::DBIx>

=head1 AUTHOR

Adam Harrison (adamdharrison@gmail.com)

=head1 LICENSE

Copyright (C) 2013 Adam Harrison

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

=cut

1;
