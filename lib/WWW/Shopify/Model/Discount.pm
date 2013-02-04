#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Discount;
use parent "WWW::Shopify::Model::Item";

sub stats { return {
		"applies_once" => new WWW::Shopify::Field::Boolean(),
		"applies_to_id" => new WWW::Shopify::Field::Relation::ReferenceOne("WWW::Shopify::Model::Product"),
		"code" => new WWW::Shopify::Field::String(),
		"ends_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
		"starts_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
		"id" => new WWW::Shopify::Field::Identifier(),
		"minimum_order_amount" => new WWW::Shopify::Field::Money(),
		"status" => new WWW::Shopify::Field::String::Enum(["enabled", "disabled"]),
		"usage_limit" => new WWW::Shopify::Field::Int(),
		"value" => new WWW::Shopify::Field::Money(),
		"discount_type" => new WWW::Shopify::Field::String::Enum(["fixed_amount", "disabled"]),
		"applies_to_resource" => new WWW::Shopify::Field::String::Enum(["order", "product", "collection", "customer_group"]),
		"times_used" => new WWW::Shopify::Field::Int(),
		"applies_to" => new WWW::Shopify::Field::Relation::OwnOne("WWW::Shopify::Model::Product")
	};
}

sub minimal { return ['discount_type', 'code', 'minimum_order_amount', 'value']; }

sub needs_login { return 1; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1;
