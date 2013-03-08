#!/usr/bin/perl

use strict;
use warnings;

package WWW::Shopify::Model::Product::Variant;
use parent 'WWW::Shopify::Model::NestedItem';

sub mods { return {
	"fufillment_service" => new WWW::Shopify::Field::String("(manual|automatic)"),
	"grams" => new WWW::Shopify::Field::Int(1, 20000),
	"inventory_management" => new WWW::Shopify::Field::String("(manual|shopify)"),
	"inventory_policy" => new WWW::Shopify::Field::String("continue"),
	"option1" => new WWW::Shopify::Field::String::Words(1),
	"option2" => new WWW::Shopify::Field::String::Words(1),
	"option3" => new WWW::Shopify::Field::String::Words(1),
	"position" => new WWW::Shopify::Field::Int(1, 4),
	"price" => new WWW::Shopify::Field::Money(),
	"requires_shipping" => new WWW::Shopify::Field::Boolean(),
	"sku" => new WWW::Shopify::Field::String(1, 20000),
	"taxable" => new WWW::Shopify::Field::Boolean(),
	"title" => new WWW::Shopify::Field::String::Words(1, 3),
	"compare_at_price" => new WWW::Shopify::Field::Money(),
	"inventory_quantity" => new WWW::Shopify::Field::Int(1, 20),
	"metafields" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Metafield") 
};
}
sub stats() { return {
	"id" => new WWW::Shopify::Field::Identifier(),
	"product_id" => new WWW::Shopify::Field::Relation::ReferenceOne('WWW::Shopify::Model::Product'),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now')};
}
sub minimal() { return ["option1", "price"]; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1
