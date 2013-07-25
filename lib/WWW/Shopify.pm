#!/usr/bin/perl

=head1 NAME

WWW::Shopify - Main object representing acess to a particular Shopify store.

=cut

=head1 DISCLAIMER

WWW::Shopify is my first official CPAN module, so please bear with me as I try to sort out all the bugs, and deal with the unfamiliar CPAN infrastructure. Don't expect this to work out of the box as of yet, I'm still learning exactly how things are working. Hence some version problems I've been having.

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

package WWW::Shopify;

our $VERSION = '0.993';

use WWW::Shopify::Exception;
use WWW::Shopify::Field;
use Module::Find;
use WWW::Shopify::URLHandler;
use WWW::Shopify::Query;

# Make sure we include all our models so that when people call the model, we actually know what they're talking about.
BEGIN {	eval(join("\n", map { "require $_;" } findallmod WWW::Shopify::Model)); }

package WWW::Shopify;

=head1 METHODS

=head2 new($shop_url, [$email, $pass])

Creates a new shop, without using the actual API, uses automated form submission to log in.

=cut

sub new { 
	my ($package, $shop_url, $email, $password) = @_;
	die new WWW::Shopify::Exception("Can't create a shop without a shop url.") unless $shop_url;
	my $ua = LWP::UserAgent->new( ssl_opts => { SSL_version => 'SSLv3' } );
	$ua->cookie_jar({ });
	$ua->timeout(10);	
	$ua->agent("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.5 Safari/537.22");
	my $self = bless { _shop_url => $shop_url, _ua => $ua, _url_handler => undef, _api_calls => 0 }, $package;
	$self->url_handler(new WWW::Shopify::URLHandler($self));
	$self->login_admin($email, $password) if defined $email && defined $password;
	return $self;
}


sub api_calls { $_[0]->{_api_calls} = $_[1] if defined $_[1]; return $_[0]->{_api_calls}; }
sub url_handler { $_[0]->{_url_handler} = $_[1] if defined $_[1]; return $_[0]->{_url_handler}; }

=head2 encode_url($url)

Basic url encoding, works the same for public apps or logged-in apps.

=cut

sub encode_url { return "https://" . $_[0]->shop_url . $_[1]; }


=head2 ua([$new_ua])

Gets/sets the user agent we're using to access shopify's api. By default we use LWP::UserAgent, with a timeout of 5 seconds.

PLEASE NOTE: At the very least, with LWP::UserAgent, at least, on my system, I had to force the SSL layer of the agent to use SSLv3, using the line

	LWP::UserAgent->new( ssl_opts => { SSL_version => 'SSLv3' } );

Otherwise, Shopify does some very weird stuff, and some very weird errors are spit out. Just FYI.

=cut

sub ua { $_[0]->{_ua} = $_[1] if defined $_[1]; return $_[0]->{_ua}; }


=head2 shop_url([$shop_url])

Gets/sets the shop url that we're going to be making calls to.

=cut

# Modifiable Attributes
sub shop_url { $_[0]->{_shop_url} = $_[1] if defined $_[1]; return $_[0]->{_shop_url}; }

sub translate_model($) {
	return $_[1] if $_[1] =~ m/WWW::Shopify::Model/;
	return "WWW::Shopify::Model::" . $_[1];
}

use constant {
	PULLING_ITEM_LIMIT => 250,
	CALL_LIMIT_REFRESH => (60*60*5),
	CALL_LIMIT_MAX => 500
};

sub get_url { return $_[0]->url_handler->get_url($_[0]->encode_url($_[1]), $_[2], $_[3]); }
sub post_url { return $_[0]->url_handler->post_url($_[0]->encode_url($_[1]), $_[2], $_[3]); }
sub put_url { return $_[0]->url_handler->put_url($_[0]->encode_url($_[1]), $_[2], $_[3]); }
sub delete_url { return $_[0]->url_handler->delete_url($_[0]->encode_url($_[1]), $_[2], $_[3]); }

use Devel::StackTrace;
sub resolve_trailing_url {
	my ($self, $package, $action, $parent) = @_;
	my $method = lc($action) . "_through_parent";
	if ($package->$method) {
		die new WWW::Shopify::Exception("Cannot get, no parent specified.") unless $parent;
		return "/admin/" . $parent->plural . "/" . $parent->id . "/" . $package->plural;
	}
	return "/admin/" . $package->plural;
}

sub get_all_limit {
	my ($self, $package, $specs) = @_;
	$package = $self->translate_model($package);
	$specs->{"limit"} = PULLING_ITEM_LIMIT unless exists $specs->{"limit"};
	return () if ($specs->{limit} == 0);
	return $self->get_shop if $package->is_shop;
	my ($decoded, $response) = $self->get_url($self->resolve_trailing_url($package, "get", $specs->{parent}) . ".json", $specs);
	return map { my $object = $package->from_json($_, $self); $object->associated_parent($specs->{parent}); $object; } @{$decoded->{$package->plural}};
}

=head2 get_all($self, $package, $filters)

Gets up to 249 * CALL_LIMIT objects (currently 124750) from Shopify at once. Goes in a loop until it's got everything. Performs a count first to see where it's at.

If you don't want this behaviour, use the limit filter.

=cut

use POSIX qw/ceil/;
use List::Util qw(min);
sub get_all {
	my ($self, $package, $specs) = @_;
	$package = $self->translate_model($package);
	$self->validate_item($package);
	return $self->get_shop if $package->is_shop;
	return $self->get_all_limit($package, $specs) if ((defined $specs->{"limit"} && $specs->{"limit"} <= PULLING_ITEM_LIMIT) || !$package->countable());

	my $item_count = $self->get_count($package, $specs);
	$item_count = min($specs->{limit}, $item_count) if defined $specs->{limit};
	die new WWW::Shopify::Exception("OVER LIMIT GET; NOT IMPLEMENTED.") if $item_count > PULLING_ITEM_LIMIT*499;
	$specs->{limit} = $item_count;
	return $self->get_all_limit($package, $specs) if $item_count <= PULLING_ITEM_LIMIT;
	my $page_count = ceil($item_count / PULLING_ITEM_LIMIT);
	my @return = ();
	my $start_page = $specs->{since_page} ? $specs->{since_page} : 1;
	$specs->{limit} = PULLING_ITEM_LIMIT;
	eval {
		for($start_page..$page_count) {
			$specs->{page} = $_;
			push(@return, $self->get_all_limit($package, $specs));
		};
	};
	if ($@) {
		$@->extra(\@return) if ref($@) && $@->isa('WWW::Shopify::Exception::CallLimit');
		die $@;
	}
	return @return if wantarray;
	return $return[0] if int(@return) > 0;
	return undef;
}

=head2 get_shop($self)

Returns the actual shop object.

	my $shop = $sa->get_shop;

=cut

sub get_shop {
	my ($self) = @_;
	my $package = 'WWW::Shopify::Model::Shop';
	my ($decoded, $response) = $self->get_url("/admin/" . $package->singular() . ".json");
	my $object = $package->from_json($decoded->{$package->singular()}, $self);
	return $object;
}

=head2 get_count($self, $package, $filters)

Gets the item count from the shopify store. So if we wanted to count all our orders, we'd do:

	my $order = $sa->get('Order', 142345, { status => "any" });

It's as easy as that. Keep in mind not all items are countable (who the hell knows why); a glaring exception is assets. Either check the shopify docs, or grep for the sub "countable".

=cut

sub get_count {
	my ($self, $package, $specs) = @_;
	$package = $self->translate_model($package);
	$self->validate_item($package);
	die "Cannot count $package." unless $package->countable();
	my ($decoded, $response) = $self->get_url($self->resolve_trailing_url($package, "get", $specs->{parent}) . "/count.json", $specs);
	return $decoded->{'count'};
}

=head2 get($self, $package, $id)

Gets the item from the shopify store. Returns it in local (classed up) form. In order to get an order for example:

	my $order = $sa->get('Order', 142345);

It's as easy as that.

=cut

sub get {
	my ($self, $package, $id, $specs) = @_;
	$package = $self->translate_model($package);
	$self->validate_item($package);
	# We have a special case for asssets, for some arbitrary reason.
	my ($decoded, $response);
	if ($package !~ m/Asset/) {
		($decoded, $response) = $self->get_url($self->resolve_trailing_url($package, "get", $specs->{parent}) . "/$id.json");
	} else {
		die new WWW::Shopify::Exception("MUST have a parent with assets.") unless $specs->{parent};
		($decoded, $response) = $self->get_url("/admin/themes/" . $specs->{parent}->id . "/assets.json", {'asset[key]' => $id, theme_id => $specs->{parent}->id});
	}
	my $class = $package->from_json($decoded->{$package->singular()}, $self);
	$class->associated_parent($specs->{parent});
	return $class;
}

=head2 search($self, $package, $item, { query => $query })

Searches for the item from the shopify store. Not all items are searchable, check the API docs, or grep this module's source code and look for the "searchable" sub.

A popular thing to search for is customers by email, you can do so like the following:

	my $customer = $sa->search("Customer", { query => "email:me@example.com" });

=cut

sub search {
	my ($self, $package, $specs) = @_;
	$package = $self->translate_model($package);
	die new WWW::Shopify::Exception("Unable to search $package; it is not marked as searchable in Shopify's API.") unless $package->searchable;
	die new WWW::Shopify::Exception("Must have a query to search.") unless $specs && $specs->{query};
	$self->validate_item($package);

	my ($decoded, $response) = $self->get_url($self->resolve_trailing_url($package, "get", $specs->{parent}) . "/search.json", $specs);

	my @return = ();
	foreach my $element (@{$decoded->{$package->plural()}}) {
		my $class = $package->from_json($element, $self);
		$class->associated_parent($specs->{parent}) if $specs->{parent};
		push(@return, $class);
	}
	return @return if wantarray;
	return $return[0] if int(@return) > 0;
	return undef;
}

=head2 create($self, $item)

Creates the item on the shopify store. Not all items are creatable, check the API docs, or grep this module's source code and look for the "creatable" sub.

=cut

use List::Util qw(first);
use HTTP::Request::Common;
sub create {
	my ($self, $item, $options) = @_;
	$self->validate_item(ref($item));
	my $specs = {};
	my $missing = first { !defined $item->{$_} } $item->creation_minimal;
	die new WWW::Shopify::Exception("Missing minimal creation member: $missing in " . ref($item)) if $missing;
	die new WWW::Shopify::Exception(ref($item) . " requires you to login with an admin account.") if $item->needs_login && !$self->logged_in_admin;
	$specs = $item->to_json();
	my $method = lc($item->create_method) . "_url";
	my ($decoded, $response) = $self->$method($self->resolve_trailing_url($item, "create", $item->associated_parent) . ".json", {$item->singular() => $specs}, $item->needs_login);
	my $element = $decoded->{$item->singular};
	my $object = ref($item)->from_json($element, $self);
	$object->associated_parent($item->associated_parent);
	return $object;
}

=head2 update($self, $item)

Updates the item from the shopify store. Not all items are updatable, check the API docs, or grep this module's source code and look for the "updatable" sub.

=cut

sub update {
	my ($self, $class) = @_;
	$self->validate_item(ref($class));
	my %mods = map { $_ => 1 } $class->update_fields;
	my $vars = $class->to_json();
	$vars = { $class->singular => {map { $_ => $vars->{$_} } grep { exists $mods{$_} } keys(%$vars)} };
	my $method = lc($class->update_method) . "_url";

	my ($decoded, $response) = $self->$method($self->resolve_trailing_url($class, "update", $class->associated_parent) . "/" . $class->id . ".json", $vars);

	my $element = $decoded->{$class->singular()};
	my $object = ref($class)->from_json($element, $self);
	$object->associated_parent($class->associated_parent);
	return $object;
}

=head2 delete($self, $item)

Deletes the item from the shopify store. Not all items are deletable, check the API docs, or grep this module's source code and look for the "deletable" sub.

=cut

sub delete {
	my ($self, $class) = @_;
	$self->validate_item(ref($class));
	my $method = lc($class->delete_method) . "_url";
	if (ref($class) =~ m/Asset/) {
		my $url = $self->resolve_trailing_url(ref($class), "delete", $class->associated_parent) . ".json?asset[key]=" . $class->key;
		$self->$method($url);
	}
	else {
		$self->$method($self->resolve_trailing_url($class, "delete", $class->associated_parent) . "/" . $class->id . ".json");
	}
	return 1;
}

# For simple things like activating, enabling, disabling, that are a simple post to a custom URL.
# Sometimes returns an object, sometimes returns a 1.
use List::Util qw(first);
sub custom_action {
	my ($self, $object, $action) = @_;
	die new WWW::Shopify::Exception("You can't $action " . $object->plural . ".") unless defined $object && first { $_ eq $action } $object->actions;
	my $id = $object->id;
	my $url = $self->resolve_trailing_url($object, $action, $object->associated_parent) . "/$id/$action.json";
	my ($decoded, $response) = $self->post_url($url, {$object->singular() => $object->to_json});
	return 1 if !$decoded;
	my $element = $decoded->{$object->singular()};
	$object = ref($object)->from_json($element, $self);
	return $object;
}

=head2 activate($self, $charge), disable($self, $discount), enable($self, $discount), open($self, $order), close($self, $order), cancel($self, $order)

Special actions that do what they say.

=cut

sub activate { return $_[0]->custom_action($_[1], "activate"); }
sub disable { return $_[0]->custom_action($_[1], "disable"); }
sub enable { return $_[0]->custom_action($_[1], "enable"); }
sub open { return $_[0]->custom_action($_[1], "open"); }
sub close { return $_[0]->custom_action($_[1], "close"); }
sub cancel { return $_[0]->custom_action($_[1], "cancel"); }

=head2 login_admin($self, $email, $password)

Logs you in to the shop as an admin, allowing you to create and manipulate discount codes, as well as upload files into user-space (not theme space).

Doens't get around the API call limit, unfortunately.

=cut

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
	$res = $self->ua->request(GET "https://" . $self->shop_url . "/admin");
	die new WWW::Shopify::Exception() unless $res->decoded_content =~ m/meta content="(.*?)" name="csrf-token"/;
	$self->{authenticity_token} = $1;
	$ua->default_header('X-CSRF-Token' => $self->{authenticity_token});
	return 1;
}

=head2 logged_in_admin($self)

Determines whether or not you're logged in to the Shopify store as an admin.

=cut

sub logged_in_admin {
	my ($self) = @_;
	return 1 if $self->{last_login_check} && (time - $self->{last_login_check}) < 1000;
	my $ua = $self->ua;
	die new WWW::Shopify::Exception("Unable to login as admin without a cookie jar.") unless defined $ua->cookie_jar;
	my $res = $ua->get('https://' . $self->shop_url . '/admin/discounts/count.json');
	return undef unless $res->is_success;
	$self->{last_login_check} = time;
	return 1;
}

sub is_valid { eval { $_[0]->get_shop; }; return undef if ($@); return 1; }



=head2 create_private_app()

Automates a form submission to generate a private app. Returns a WWW::Shopify::Private with the appropriate credentials. Must be logged in.

=cut

use WWW::Shopify::Private;
use List::Util qw(first);
sub create_private_app {
	my ($self) = @_;
	my $app = $self->create(new WWW::Shopify::Model::APIClient({}));
	my @permissions = $self->get_all("APIPermission");
	my $permission = first { $_->api_client->api_key eq $app->api_key } @permissions;
	return new WWW::Shopify::Private($self->shop_url, $app->api_key, $permission->access_token);
}


=head2 delete_private_app($private_api)

Removes a private app. Must be logged in.

=cut

sub delete_private_app {
	my ($self, $api) = @_;
	my @apps = $self->get_all("APIPermission");
	my $app = first { $_->api_client && $_->api_client->api_key eq $api->api_key } @apps;
	die new WWW::Shopify::Exception("Can't find app with api key " . $api->api_key) unless $app;
	return $self->delete(new WWW::Shopify::Model::APIClient({ id => $app->api_client->id }));
}


# Internal methods.
sub validate_item {
	eval {	die unless $_[1]; $_[1]->is_item; };
	die new WWW::Shopify::Exception($_[1] . " is not an item!") if ($@);
	die new WWW::Shopify::Exception($_[1] . " requires you to login with an admin account.") if $_[1]->needs_login && !$_[0]->logged_in_admin;
}


=head2 upload_files($self, @image_paths)

Requires log in. Uploads an array of files/images into the shop's non-theme file/image management system by automating a form submission.

	$sa->login_admin("email", "password");
	$sa->upload_files("image1.jpg", "image2.jpg");

Gets around the issue that this is not actually exposed to the API.

=cut

sub upload_files {
	my ($self, @images) = @_;
	die new WWW::Shopify::Exception("Uploading files/images requires you to login with an admin account.") unless $self->logged_in_admin;
	foreach my $path (@images) {
		die new WWW::Shopify::Exception("Unable to determine extension type.") unless $path =~ m/\.(\w{2,4})$/;
		my $req = POST "https://" . $self->shop_url . "/admin/files.json",
			Content_Type => "form-data",
			Accept => "application/json",
			Content => [authenticity_token => $self->{authenticity_token}, "file[file]" => [$path]];
		my $res = $self->ua->request($req);
		die new WWW::Shopify::Exception("Error uploading $path.") unless $res->is_success;
	}
	return int(@images);
}

=cut

=head1 EXPORTED FUNCTIONS

The functions below are exported as part of the package.

=cut

=head2 calc_webhook_signature($shared_secret, $request_body)

Calculates the webhook_signature based off the shared secret and request body passed in.

=cut

=head2 verify_webhook($shared_Secret, $request_body)

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

=head2 calc_login_signature($shared_secret, $%params)

Calculates the login signature based on the shared secret and parmaeter hash passed in.

=cut

=head2 verify_login($shared_secret, $%params)

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

=head2 calc_proxy_signature($shared_secret, $%params)

Based on shared secret/hash of parameters passed in, calculates the proxy signature.

=cut

=head2 verify_proxy($shared_secret, %$params)

This is SLIGHTLY different from the above two. For, as far as I can tell, no reason.

=cut

sub calc_proxy_signature {
	my ($shared_secret, $params) = @_;
	return hmac_sha256_hex(join("", sort(map { 
		my $p = $params->{$_};
		"$_=" . (ref($p) eq "ARRAY" ? join("$_=", @$p) : $p);
	} (grep { $_ ne "signature" } keys(%$params)))), $shared_secret);
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
