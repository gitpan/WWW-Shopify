#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Order::DiscountCode;
use parent "WWW::Shopify::Model::NestedItem";

sub stats($) { return {
	"code" => new WWW::Shopify::Field::String("[A-Z][0-9]{4,10}"),
	"amount" => new WWW::Shopify::Field::Money()};
}

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1
