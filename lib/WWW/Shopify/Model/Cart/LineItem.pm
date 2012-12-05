#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Cart::LineItem;
use parent 'WWW::Shopify::Model::NestedItem';

sub stats($) { return {
	"grams" => new WWW::Shopify::Field::Int(1, 2000),
	"id" => new WWW::Shopify::Field::Identifier(),
	"price" => new WWW::Shopify::Field::Money(),
	"line_price" => new WWW::Shopify::Field::Money(),
	"quantity" => new WWW::Shopify::Field::Int(1, 20),
	"sku" => new WWW::Shopify::Field::String(),
	"title" => new WWW::Shopify::Field::String::Words(1, 3),
	"variant_id" => new WWW::Shopify::Field::Relation::ReferenceOne('WWW::Shopify::Model::Product::Variant'),
	"vendor" => new WWW::Shopify::Field::String()};
}
# Minimal variables required to create.
sub minimal() { return ['title']; }
sub singular() { return 'line_item'; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1;
