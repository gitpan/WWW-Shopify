#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::RecurringApplicationCharge;
use parent "WWW::Shopify::Model::Item";

sub stats($) { return {
	"name" => new WWW::Shopify::Field::String::Words(1,3),
	"price" => new WWW::Shopify::Field::Money(),
	"return_url" => new WWW::Shopify::Field::String::URL(),
	"activated_on" => new WWW::Shopify::Field::String::Words(1, 3),
	"billing_on" => new WWW::Shopify::Field::Date(),
	"cancelled_on" => new WWW::Shopify::Field::Date(),
	"created_at" => new WWW::Shopify::Field::Date(),
	"id" => new WWW::Shopify::Field::Identifier(),
	"status" => new WWW::Shopify::Field::String::Enum(["pending", "accepted", "declined"]),
	"test" => new WWW::Shopify::Field::Boolean(),
	"trial_days" => new WWW::Shopify::Field::Int(0, 31),
	"trial_ends_on" => new WWW::Shopify::Field::Date(),
	"updated_at" => new WWW::Shopify::Field::Date(),
	"confirmation_url" => new WWW::Shopify::Field::String::URL()};
}
sub countable() { return undef; }
sub activatable($) { return 1; }
sub minimal() { return ["name", "price", "return_url"]; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1;
