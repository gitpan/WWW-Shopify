#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Order::Fulfillment;
use parent "WWW::Shopify::Model::NestedItem";

sub stats($) { return {
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"id" => new WWW::Shopify::Field::Identifier(),
	"order_id" => new WWW::Shopify::Field::Relation::ReferenceOne('WWW::Shopify::Model::Order'),
	"service" => new WWW::Shopify::Field::String("(manual|automatic)"),
	"status" => new WWW::Shopify::Field::String("(success|failure)"),
	"tracking_company" => new WWW::Shopify::Field::String(),
	"tracking_number" => new WWW::Shopify::Field::String("[A-Z0-9]{5,10}"),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"receipt" => new WWW::Shopify::Field::Relation::OwnOne('WWW::Shopify::Model::Order::Fulfillment::Receipt'),
	"line_items" => new WWW::Shopify::Field::Relation::Many('WWW::Shopify::Model::Order::LineItem') };
}

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1;
