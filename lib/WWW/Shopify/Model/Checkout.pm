#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Checkout;
use parent "WWW::Shopify::Model::Item";

sub stats($) { return {
	"buyer_accepts_marketing" => new WWW::Shopify::Field::Boolean(),
	"cart_token" => new WWW::Shopify::Field::String::Hash(),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"email" => new WWW::Shopify::Field::String::Email(),
	"id" => new WWW::Shopify::Field::Identifier(),
	"token" => new WWW::Shopify::Field::String::Hash(),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"billing_address" => new WWW::Shopify::Field::Relation::OwnOne('WWW::Shopify::Model::Address'),
	"shipping_address" => new WWW::Shopify::Field::Relation::OwnOne('WWW::Shopify::Model::Address'),
	"customer" => new WWW::Shopify::Field::Relation::OwnOne('WWW::Shopify::Model::Customer')};
}

sub creatable($) { return undef; }
sub updatable($) { return undef; }
sub deletable($) { return undef; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1;
