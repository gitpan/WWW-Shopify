#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

=head1 NAME

WWW::Shopify::Public - Main object representing public app access to a particular Shopify store.

=cut

=head1 DESCRIPTION

Inherits all methods from L<WWW::Shopify>, provides additional mechanisms to modify the used access_token, user-agent and url handler.

=cut

package WWW::Shopify::Public;
use parent 'WWW::Shopify';

=head1 METHODS

=head2 new($url, $api_key, $access_token)

Creates a new WWW::Shopify::Public object, which allows you to make calls via the shopify public app interface.

You can see an overview of the authentication workflow for a public app here: L<< http://api.shopify.com/authentication.html >> 

=cut

sub new { 
	my $class = shift;
	my ($shop_url, $api_key, $access_token) = @_;
	die new WWW::Shopify::Exception("Can't create a shop without an api key.") unless $api_key;
	my $self = $class->SUPER::new($shop_url);
	$self->api_key($api_key);
	$self->access_token($access_token);
	$self->ua->default_header("X-Shopify-Access-Token" => $access_token);
	return $self;
}

=head2 api_key([$api_key])

Gets/sets the app's access token.

=cut

sub api_key { $_[0]->{_api_key} = $_[1] if defined $_[1]; return $_[0]->{_api_key}; }

=head2 access_token([$access_token])

Gets/sets the app's access token.

=cut

sub access_token { $_[0]->{_access_token} = $_[1] if defined $_[1]; return $_[0]->{_access_token}; }

sub is_valid { my $self = shift; $self->SUPER::is_valid(@_); return $self->{_access_token}; }

=head2 authorize_url(@$scope, $redirect)

When the shop doesn't have an access_token, this is what you should be redirecting your client to. Inputs should be your scope, as an array, and the url you want to redirect to.

=cut

use URI::Escape;
sub authorize_url {
	my ($self, $scope, $redirect) = (@_);
	my $hostname = $self->shop_url;
	my %parameters = (
		'client_id' => $self->api_key,
		'scope' => join(",", @$scope),
		'redirect_uri' => $redirect
	);
	return "https://$hostname/admin/oauth/authorize?" . join("&", map { "$_=" . uri_escape($parameters{$_}) } keys(%parameters));
}

=head2 exchange_token($shared_secret, $code)

When you have a temporary code, which you should get from authorize_url's redirect and you want to exchange it for a token, you call this.

=cut

sub exchange_token {
	my ($self, $shared_secret, $code) = (@_);
	
	my $req = HTTP::Request->new(POST => "https://" . $self->shop_url . "/admin/oauth/access_token");
  	$req->content_type('application/x-www-form-urlencoded');
	my %parameters = (
		'client_id' => $self->api_key,
		'client_secret' => $shared_secret,
		'code' => $code
	);
	$req->content(join("&", map { "$_=" . uri_escape($parameters{$_}) } keys(%parameters)));
	my $res;
	# If you go through the install too fast, Shopify will give you an access denied thing. So in that case, let's repeat until 
	my $success = undef;
	for (my $i = 0; $i < 5 && !$success; ++$i) {
		$res = $self->ua->request($req);
		$success = $res->is_success();
		sleep 1 unless $success;
	}
	die new WWW::Shopify::Exception("Unable to reach server for https://" . $self->shop_url . "/admin/oauth/access_token: " . $res->code() . ".\n" . $res->content) unless $res->is_success();
	my $decoded = JSON::decode_json($res->content);
	die new WWW::Shopify::Exception("Unable to retrieve access token.") unless defined $decoded->{access_token};
	return $decoded->{access_token};
}

=head1 SEE ALSO

L<WWW::Shopify::Item>, L<WWW::Shopify>

=head1 AUTHOR

Adam Harrison (adamdharrison@gmail.com)

=head1 LICENSE

See LICENSE in the main directory.

=cut

1;
