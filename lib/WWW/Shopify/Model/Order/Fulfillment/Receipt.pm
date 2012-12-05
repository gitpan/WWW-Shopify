#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Order::Fulfillment::Receipt;
use parent "WWW::Shopify::Model::NestedItem";

sub stats($) { return {
	"testcase" => new WWW::Shopify::Field::Boolean(),
	"authorization" => new WWW::Shopify::Field::String("[0-9]{5,10}")};
}

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1;
