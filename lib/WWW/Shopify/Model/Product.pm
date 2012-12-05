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

sub mods($) { return {
	"body_html" => new WWW::Shopify::Field::Text::HTML(),
	"variants" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Product::Variant"),
	"handle" => new WWW::Shopify::Field::String("[a-z]{2,8}\-[a-z]{2,8}"),
	"product_type" => new WWW::Shopify::Field::String::Words(1,2),
	"template_suffix" => new WWW::Shopify::Field::String(),
	"title" => new WWW::Shopify::Field::String::Words(1,2),
	"vendor" => new WWW::Shopify::Field::String::Words(1,2),
	"tags" => new WWW::Shopify::Field::String::Words(1,7),
	"description" => new WWW::Shopify::Field::String::Words(1,40),
	"images" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Product::Image"),
	"options" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Product::Option") };
}
sub stats($) { return {
	"id" => new WWW::Shopify::Field::Identifier(),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"published_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now')};
}
sub minimal($) { return ["title", "product_type", "vendor"]; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

=head1 SEE ALSO

L<WWW::Shopify::Model::Item> L<http://api.shopify.com/product.html>

=head1 AUTHOR

Adam Harrison

=head1 LICENSE

See LICENSE in the main directory.

=cut


1
