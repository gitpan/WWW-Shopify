#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Order::TaxLine;
use parent "WWW::Shopify::Model::NestedItem";

sub stats($) { return {
	"price" => new WWW::Shopify::Field::Money(),
	"rate" => new WWW::Shopify::Field::Float(0.01, 0.5),
	"title" => new WWW::Shopify::Field::String::Words(1, 3)};
}

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1;
