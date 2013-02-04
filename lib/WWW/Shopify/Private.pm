#!/usr/bin/perl


=head1 NAME

WWW::Shopify::Private - Main object representing private app access to a particular Shopify store.

=cut

=head1 DESCRIPTION

Inherits all methods from L<WWW::Shopify>, provides additional mechanisms to modify the used password, user-agent and url handler.

=cut

use strict;
use warnings;

package WWW::Shopify::Private;
use parent 'WWW::Shopify';
use File::Temp qw/ tempfile /;;

=head1 METHODS

=head2 new(url, api_key, password)

Creates a new WWW::Shopify::Private object, which allows you to make calls via the shopify private app interface.s

=cut

sub new($$$$) { 
	my ($class, $shop_url, $api_key, $password) = @_;
	my $UA = LWP::UserAgent->new( ssl_opts => { SSL_version => 'SSLv3' } );
	$UA->timeout(5);
	$UA->cookie_jar({ });
	my $self = bless {
		_shop_url => $shop_url,
		_api_key => $api_key,
		_password => $password,
		_ua => $UA,
		_url_handler => undef,
	}, $class;
	$self->url_handler(new WWW::Shopify::URLHandler($self));
	return $self;
}

sub url_handler { $_[0]->{_url_handler} = $_[1] if defined $_[1]; return $_[0]->{_url_handler}; }

=head2 encode_url(url)

Modifies the requested url by prepending the api key and the password, as well as the shop's url, before sending the request off to the user agent.

=cut

sub encode_url { return "https://" . $_[0]->api_key . ":" . $_[0]->password . "@" . $_[0]->shop_url . $_[1]; }

=head2 password([new_password])

Gets/sets the app's private password.

=cut

sub password { $_[0]->{_password} = $_[1] if defined $_[1]; return $_[0]->{_password}; }

=head2 ua([new_ua])

Gets/sets the user agent we're using to access shopify's api. By default we use LWP::UserAgent, with a timeout of 5 seconds.

PLEASE NOTE: At the very least, with LWP::UserAgent, at least, on my system, I had to force the SSL layer of the agent to use SSLv3, using the line

	LWP::UserAgent->new( ssl_opts => { SSL_version => 'SSLv3' } );

Otherwise, Shopify does some very weird stuff, and some very weird errors are spit out. Just FYI.

=cut

sub ua { $_[0]->{_ua} = $_[1] if defined $_[1]; return $_[0]->{_ua}; }

=head1 SEE ALSO

L<WWW::Shopify::Item>, L<WWW::Shopify>

=head1 AUTHOR

Adam Harrison (adamdharrison@gmail.com)

=head1 LICENSE

See LICENSE in the main directory.

=cut


1;
