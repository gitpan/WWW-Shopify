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
use JSON;
use URI::Escape;

package WWW::Shopify;

our $VERSION = '0.98';

use WWW::Shopify::Exception;
use WWW::Shopify::Field;
use Data::Dumper;
use Module::Find;
use WWW::Shopify::URLHandler;
use WWW::Shopify::Query;

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

sub get_url { return $_[0]->url_handler()->get_url($_[0]->encode_url($_[1]), $_[2]); }
sub post_url { return $_[0]->url_handler()->post_url($_[0]->encode_url($_[1]), $_[2]); }
sub put_url { return $_[0]->url_handler()->put_url($_[0]->encode_url($_[1]), $_[2]); }
sub delete_url { return $_[0]->url_handler()->delete_url($_[0]->encode_url($_[1]), $_[2]); }

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
	my ($decoded, $response) = $self->get_url($self->resolve_trailing_url($package, "get", $specs->{parent}) . ".json", $specs);
	return map { my $object = $package->from_json($_); $object->associate($self); $object->associated_parent($specs->{parent}); $object; } @{$decoded->{$package->plural}};
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
	return map { $specs->{page} = $_; $self->get_all_limit($package, $specs) } 1..$page_count;
}

sub get_shop {
	my ($self) = @_;
	my $package = 'WWW::Shopify::Model::Shop';
	my ($decoded, $response) = $self->get_url("/admin/" . $package->singular() . ".json");
	my $object = $package->from_json($decoded->{$package->singular()});
	$object->associate($self);
	return $object;
}

sub get_count {
	my ($self, $package, $specs) = @_;
	$package = $self->translate_model($package);
	$self->validate_item($package);
	die "Cannot count $package." unless $package->countable();
	my ($decoded, $response) = $self->get_url($self->resolve_trailing_url($package, "get", $specs->{parent}) . "/count.json", $specs);
	return $decoded->{'count'};
}

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
	my $class = $package->from_json($decoded->{$package->singular()});
	$class->associate($self);
	$class->associated_parent($specs->{parent});
	return $class;
}

sub search {
	my ($self, $package, $specs) = @_;
	$package = $self->translate_model($package);
	die new WWW::Shopify::Exception("Unable to search $package; it is not marked as searchable in Shopify's API.") unless $package->searchable;
	die new WWW::Shopify::Exception("Must have a query to search.") unless $specs && $specs->{query};
	$self->validate_item($package);

	my ($decoded, $response) = $self->get_url($self->resolve_trailing_url($package, "get", $specs->{parent}) . "/search.json", $specs);

	my @return = ();
	foreach my $element (@{$decoded->{$package->plural()}}) {
		my $class = $package->from_json($element);
		$class->associated_parent($specs->{parent}) if $specs->{parent};
		$class->associate($self);
		push(@return, $class);
	}
	return @return if wantarray;
	return $return[0] if int(@return) > 0;
	return undef;
}

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
	if ($item->needs_login) {
		my @fields = map { my $a; $item->singular . "[$_]" => $specs->{$_} } keys(%$specs);
		my $url = $self->encode_url($self->resolve_trailing_url($item, "create", $item->associated_parent)) . ".json";
		my $response = $self->ua->request(POST $url, [authenticity_token => $self->{authenticity_token}, @fields], Accept => 'application/json');
	 	my $json = JSON::decode_json($response->decoded_content);
		return ref($item)->from_json($json->{$item->singular});
	}
	my $method = lc($item->create_method) . "_url";
	my ($decoded, $response) = $self->$method($self->resolve_trailing_url($item, "create", $item->associated_parent) . ".json", {$item->singular() => $specs});
	my $element = $decoded->{$item->singular};
	my $object = ref($item)->from_json($element);
	$object->associate($self);
	$object->associated_parent($item->associated_parent);
	return $object;
}

sub update {
	my ($self, $class) = @_;
	$self->validate_item(ref($class));
	my %mods = map { $_ => 1 } $class->update_fields;
	my $vars = $class->to_json();
	$vars = { $class->singular => {map { $_ => $vars->{$_} } grep { exists $mods{$_} } keys(%$vars)} };
	my $method = lc($class->update_method) . "_url";

	my ($decoded, $response) = $self->$method($self->resolve_trailing_url($class, "update", $class->associated_parent) . "/" . $class->id . ".json", $vars);

	my $element = $decoded->{$class->singular()};
	my $object = ref($class)->from_json($element);
	$object->associate($self);
	$object->associated_parent($class->associated_parent);
	return $object;
}

sub delete {
	my ($self, $class) = @_;
	$self->validate_item(ref($class));

	if ($class->needs_login) {
		my $url = $self->encode_url($self->resolve_trailing_url($class, "delete", $class->associated_parent)) . "/" . $class->id();
		my $response = $self->ua->request(POST $url, [authenticity_token => $self->{authenticity_token}, "_method" => "delete"], Accept => 'application/json');
		return $response;
	}
	else {
		my $method = lc($class->delete_method) . "_url";
		if (ref($class) =~ m/Asset/) {
			my $url = $self->resolve_trailing_url(ref($class), "delete", $class->associated_parent) . ".json";
			$self->$method($url, {'asset[key]' => $class->key, theme_id => $class->associated_parent->id });
		}
		else {
			$self->$method($self->resolve_trailing_url($class, "delete", $class->associated_parent) . "/" . $class->id . ".json");
		}
	}
	return 1;
}

# This function is solely for discount codes.
sub activate {
	my ($self, $object) = @_;
	die new WWW::Shopify::Exception("You can only activate charges.") unless defined $object && $object->activatable;
	my ($decoded, $response) = $self->post_url("/admin/" . $object->plural . "/" . $object->id . "/activate.json", {$object->singular() => $object->to_json});
	my $element = $decoded->{$object->singular()};
	$object = ref($object)->from_json($element);
	$object->associate($self);
	return $object;
}

sub disable {
	my ($self, $object) = @_;
	die new WWW::Shopify::Exception("You can only disable discount codes.") unless defined $object && $object->disablable;
	die new WWW::Shopify::Exception(ref($object) . " requires you to login with an admin account.") if $object->needs_login && !$self->logged_in_admin;
	my $id = $object->id;
	my $url = $self->encode_url($self->resolve_trailing_url($object, "disable", $object->associated_parent)) . "/$id/disable.json";
	my $response = $self->ua->request(POST $url, [authenticity_token => $self->{authenticity_token}], Accept => 'application/json');
 	my $json = JSON::decode_json($response->decoded_content);
	$object = ref($object)->from_json($json->{$object->singular});
	$object->associate($self);
	return $object;
}
sub enable {
	my ($self, $object) = @_;
	die new WWW::Shopify::Exception("You can only enable discount codes.") unless defined $object && $object->disablable;
	die new WWW::Shopify::Exception(ref($object) . " requires you to login with an admin account.") if $object->needs_login && !$self->logged_in_admin;
	my $id = $object->id;
	my $url = $self->encode_url($self->resolve_trailing_url($object, "enable", $object->associated_parent)) . "/$id/enable.json";
	my $response = $self->ua->request(POST $url, [authenticity_token => $self->{authenticity_token}], Accept => 'application/json');
 	my $json = JSON::decode_json($response->decoded_content);
	$object = ref($object)->from_json($json->{$object->singular});
	$object->associate($self);
	return $object;
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
	return undef unless $res->is_success;
	$self->{last_login_check} = time;
	return 1;
}

sub is_valid { eval { $_[0]->get_shop; }; return undef if ($@); return 1; }

# Internal methods.
sub validate_item {
	eval {	die unless $_[1]; $_[1]->is_item; };
	die new WWW::Shopify::Exception($_[1] . " is not an item!") if ($@);
	die new WWW::Shopify::Exception($_[1] . " requires you to login with an admin account.") if $_[1]->needs_login && !$_[0]->logged_in_admin;
}


=head2 upload_files

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
