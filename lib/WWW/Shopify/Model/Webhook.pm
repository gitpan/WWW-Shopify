#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Webhook;
use parent "WWW::Shopify::Model::Item";

=head1 NAME

Webhook - Shopify Webhook

=cut

=head1 DESCRIPTION

Represents information about a webhook on shopify. Webhooks are callbacks; whenver a trigger condition is met, shopify will send HTTP requests to the designated URL.

The following topics are acceptable as an input parameter; this is copied from the Shopify documentation.

	orders/create, orders/updated, orders/paid, orders/cancelled, orders/fulfilled, orders/partially_fulfilled,  
	app/uninstalled, customer_groups/create, customer_groups/update, customer_groups/delete, products/create,
	products/update, products/delete, collections/create, collections/update, collections/delete, carts/create, carts/update

=cut

=head1 USAGE

For information about how to use items, please see L<WWW::Shopify::Model::Item>.

=cut

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"format" => new WWW::Shopify::Field::String("(xml|json)"),
	"address" => new WWW::Shopify::Field::String::URL(),
	"topic" => new WWW::Shopify::Field::String::Enum(
		qw(	
			orders/create orders/updated orders/paid orders/cancelled orders/fulfilled orders/partially_fulfilled
			app/uninstalled customer_groups/create customer_groups/update customer_groups/delete products/create
			products/update products/delete collections/create collections/update collections/delete carts/create carts/update
		)
	),
	"id" => new WWW::Shopify::Field::Identifier(),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now')
}; }

sub creation_minimal { return qw(address topic format); }
sub creation_filled { return qw(created_at); }
sub update_filled { return qw(updated_at); }
sub update_fields { return qw(address topic format); }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

=head1 SEE ALSO

L<WWW::Shopify::Model::Item> L<http://api.shopify.com/webhook.html>

=head1 AUTHOR

Adam Harrison

=head1 LICENSE

See LICENSE in the main directory.

=cut

1
