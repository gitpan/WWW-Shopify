#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;
use WWW::Shopify::Model::Product::Image;
use WWW::Shopify::Model::Product::Option;
use WWW::Shopify::Model::Product::Variant;

package WWW::Shopify::Model::Product;
use parent "WWW::Shopify::Model::Item";

=head1 NAME

Product - Shopify Product

=cut

=head1 DESCRIPTION

Represents information about a product on shopify.

=cut

=head1 USAGE

For information about how to use items, please see L<WWW::Shopify::Model::Item>.

=cut

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"body_html" => new WWW::Shopify::Field::Text::HTML(),
	"variants" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Product::Variant"),
	"handle" => new WWW::Shopify::Field::String("[a-z]{2,8}\-[a-z]{2,8}"),
	"product_type" => new WWW::Shopify::Field::String::Words(1,2),
	"template_suffix" => new WWW::Shopify::Field::String(),
	"title" => new WWW::Shopify::Field::String::Words(1,2),
	"vendor" => new WWW::Shopify::Field::String::Words(1,2),
	"tags" => new WWW::Shopify::Field::String::Words(1,7),
	"images" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Product::Image"),
	"options" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Product::Option"),
	"metafields" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Metafield"),
	"id" => new WWW::Shopify::Field::Identifier(),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"published_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now')};
}

sub creation_minimal { return qw(title product_type vendor); }
sub creation_filled { return qw(id created_at); }
# Odd, even without an update method, it still has an updated at.
sub update_filled { return qw(updated_at); }
sub update_fields { return qw(metafields handle product_type title template_suffix vendor tags images options); }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

=head1 SEE ALSO

L<WWW::Shopify::Model::Item> L<http://api.shopify.com/product.html>

=head1 AUTHOR

Adam Harrison

=head1 LICENSE

See LICENSE in the main directory.

=cut


1
