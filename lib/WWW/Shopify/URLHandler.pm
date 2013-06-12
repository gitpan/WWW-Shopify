#!/usr/bin/perl

use strict;
use warnings;

package WWW::Shopify::URLHandler;
use JSON;

sub new($) { return bless {_parent => $_[1]}, $_[0]; }
sub parent { $_[0]->{_parent} = $_[1] if defined $_[1]; return $_[0]->{_parent}; }

sub get_url($$@) {
	my ($self, $url, $parameters) = @_;
	my $uri = URI->new($url);
	my %filtered = ();
	for (keys(%$parameters)) {
		if ($parameters->{$_} && ref($parameters->{$_}) eq "DateTime") {
			$filtered{$_} = $parameters->{$_}->strftime('%Y-%m-%d %H:%M:%S%z')
		}
		elsif ($_ ne "parent") {
			$filtered{$_} = $parameters->{$_};
		}
	}
	$uri->query_form(\%filtered);
	print STDERR "GET " . $uri->as_string . "\n" if $ENV{'SHOPIFY_LOG'};
	my $request = HTTP::Request->new("GET", $uri);
	$request->header("Accept" => "application/json");
	my $response = $self->parent->ua->request($request);
	if (!$response->is_success) {
		die new WWW::Shopify::Exception::CallLimit($response) if $response->code() == 503;
		die new WWW::Shopify::Exception::InvalidKey($response) if $response->code() == 401;
		die new WWW::Shopify::Exception($response);
	}
	my $limit = $response->header('x-shopify-shop-api-call-limit');
	$self->parent->api_calls($limit) if $limit;
	my $content = $response->decoded_content;
	my $decoded = JSON::decode_json($content);
	return ($decoded, $response);
}

sub use_url($$$$) {
	my ($self, $method, $url, $hash) = @_;
	my $request = HTTP::Request->new($method, $url);
	print STDERR "$method $url\n" if $ENV{'SHOPIFY_LOG'};
	$request->header("Accept" => "application/json", "Content-Type" => "application/json");
	$request->content($hash ? JSON::encode_json($hash) : undef);
	my $response = $self->parent->ua->request($request);
	if (!$response->is_success) {
		die new WWW::Shopify::Exception::CallLimit($response) if $response->code() == 503;
		die new WWW::Shopify::Exception::InvalidKey($response) if $response->code() == 401;
		die new WWW::Shopify::Exception($response);
	}
	my $limit = $response->header('x-shopify-shop-api-call-limit');
	$self->parent->api_calls($limit) if $limit;
	my $decoded = (length($response->decoded_content) >= 2) ? JSON::decode_json($response->decoded_content) : undef;
	return ($decoded, $response);
}
sub put_url($$$) { return shift->use_url("PUT", @_); }
sub post_url($$$) { return shift->use_url("POST", @_); }
sub delete_url($$$) { return shift->use_url("DELETE", @_); }

1;
