#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Order::Fulfillment;
use parent "WWW::Shopify::Model::NestedItem";

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"id" => new WWW::Shopify::Field::Identifier(),
	"order_id" => new WWW::Shopify::Field::Relation::Parent('WWW::Shopify::Model::Order'),
	"service" => new WWW::Shopify::Field::String::Enum(["manual", "automatic"]),
	"status" => new WWW::Shopify::Field::String::Enum(["success", "failure"]),
	"tracking_company" => new WWW::Shopify::Field::String(),
	"tracking_number" => new WWW::Shopify::Field::String("[A-Z0-9]{5,10}"),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"receipt" => new WWW::Shopify::Field::Relation::OwnOne('WWW::Shopify::Model::Order::Fulfillment::Receipt'),
	"line_items" => new WWW::Shopify::Field::Relation::Many('WWW::Shopify::Model::Order::LineItem') };
}
sub cancellable { return undef; }
sub deletable { return undef; }

sub read_scope { return "read_orders"; }
sub write_scope { return "write_orders"; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1;
