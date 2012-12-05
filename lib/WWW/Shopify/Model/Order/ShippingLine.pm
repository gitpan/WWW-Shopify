#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Order::ShippingLine;
use parent "WWW::Shopify::Model::NestedItem";

sub stats($) { return {
	"code" => new WWW::Shopify::Field::String::Words(1, 3),
	"price" => new WWW::Shopify::Field::Money(),
	"source" => new WWW::Shopify::Field::String("shopify"),
	"title" => new WWW::Shopify::Field::String::Words(1, 3)};
}

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1;
