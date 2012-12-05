#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Product::Image;
use parent "WWW::Shopify::Model::NestedItem";

sub mods() { return {
	"position" => new WWW::Shopify::Field::Int(1, 4),
	"src" => new WWW::Shopify::Field::String::URL::Image()};
}
sub stats() { return {
	"id" => new WWW::Shopify::Field::Identifier(),
	"product_id" => new WWW::Shopify::Field::Relation::ReferenceOne('WWW::Shopify::Model::Product'),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now')};
}
sub minimal() { return []; } 

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1
