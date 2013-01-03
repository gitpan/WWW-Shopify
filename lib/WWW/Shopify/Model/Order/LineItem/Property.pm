#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Order::LineItem::Property;
use parent "WWW::Shopify::Model::Item";

sub stats($) { return {
	"name" => new WWW::Shopify::Field::String(),
	"value" => new WWW::Shopify::Field::String()};
}

sub plural() { return 'properties'; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1
