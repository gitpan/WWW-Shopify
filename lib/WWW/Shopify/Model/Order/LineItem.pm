#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Order::LineItem;
use parent "WWW::Shopify::Model::Item";

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"fulfillment_service" => new WWW::Shopify::Field::String("(automatic|manual)"),
	"fulfillment_status" => new WWW::Shopify::Field::String(),
	"grams" => new WWW::Shopify::Field::Int(1, 2000),
	"id" => new WWW::Shopify::Field::Identifier(),
	"price" => new WWW::Shopify::Field::Money(),
	"product_id" => new WWW::Shopify::Field::Relation::ReferenceOne('WWW::Shopify::Model::Product'),
	"quantity" => new WWW::Shopify::Field::Int(1, 20),
	"requires_shipping" => new WWW::Shopify::Field::Boolean(),
	"sku" => new WWW::Shopify::Field::String(),
	"title" => new WWW::Shopify::Field::String::Words(1, 3),
	"variant_id" => new WWW::Shopify::Field::Relation::ReferenceOne('WWW::Shopify::Model::Product::Variant'),
	"variant_title" => new WWW::Shopify::Field::String::Words(1,3),
	"vendor" => new WWW::Shopify::Field::String(),
	"name" => new WWW::Shopify::Field::String::Words(1, 3),
	"properties" => => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Order::LineItem::Property"),
	"variant_inventory_management" => new WWW::Shopify::Field::String("(shopify|manual)")};
}

sub creatable { return undef; }
sub updatable { return undef; }
sub deletable { return undef; }

sub singular() { return 'line_item'; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1
