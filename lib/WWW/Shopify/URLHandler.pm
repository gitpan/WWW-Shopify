#!/usr/bin/perl

use strict;
use warnings;

package WWW::Shopify::URLHandler;
use JSON qw(from_json to_json encode_json);
use Data::Dumper;
use Scalar::Util qw(weaken);

sub new {
	my ($package, $parent) = @_;
	my $self = bless {_parent => $parent}, $package;
	weaken($self->{_parent});
	return $self;
}
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
	print STDERR Dumper($response) if $ENV{'SHOPIFY_LOG'} && $ENV{'SHOPIFY_LOG'} > 1;
	if (!$response->is_success) {
		die new WWW::Shopify::Exception::CallLimit($response) if $response->code() == 429;
		die new WWW::Shopify::Exception::InvalidKey($response) if $response->code() == 401;
		die new WWW::Shopify::Exception::NotFound($response) if $response->code() == 404;
		die new WWW::Shopify::Exception($response);
	}
	my $limit = $response->header('x-shopify-shop-api-call-limit');
	if ($limit) {
		die new WWW::Shopify::Exception("Unrecognized limit.") unless $limit =~ m/(\d+)\/\d+/;
		$self->parent->api_calls($1);
	}
	my $content = $response->decoded_content;
	# From JSON because decodec content is already a perl internal string.
	my $decoded = from_json($content);
	return ($decoded, $response);
}

sub use_url($$$$) {
	my ($self, $method, $url, $hash) = @_;
	my $request = HTTP::Request->new($method, $url);
	print STDERR "$method $url\n" if $ENV{'SHOPIFY_LOG'};
	$request->header("Accept" => "application/json", "Content-Type" => "application/json");
	$request->content($hash ? encode_json($hash) : undef);
	my $response = $self->parent->ua->request($request);
	print STDERR Dumper($response) if $ENV{'SHOPIFY_LOG'} && $ENV{'SHOPIFY_LOG'} > 1;
	if (!$response->is_success) {
		die new WWW::Shopify::Exception::CallLimit($response) if $response->code() == 429;
		die new WWW::Shopify::Exception::InvalidKey($response) if $response->code() == 401;
		die new WWW::Shopify::Exception($response);
	}
	my $limit = $response->header('x-shopify-shop-api-call-limit');
	if ($limit) {
		die new WWW::Shopify::Exception("Unrecognized limit.") unless $limit =~ m/(\d+)\/\d+/;
		$self->parent->api_calls($1);
	}
	# From JSON because decodec content is already a perl internal string.
	my $decoded = (length($response->decoded_content) >= 2) ? from_json($response->decoded_content) : undef;
	return ($decoded, $response);
}
sub put_url($$$) { return shift->use_url("PUT", @_); }
sub post_url($$$) { return shift->use_url("POST", @_); }
sub delete_url($$$) { return shift->use_url("DELETE", @_); }

1;
