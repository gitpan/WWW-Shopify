#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Cart;
use parent 'WWW::Shopify::Model::Item';

sub mods() { return {
	"note" => new WWW::Shopify::Field::String::Words(1, 20),
	"token" => new WWW::Shopify::Field::String::Hash(),
	"line_items" => new WWW::Shopify::Field::Relation::Many('WWW::Shopify::Model::Cart::LineItem', 0, 10)};
}
sub stats { return {
	"id" => new WWW::Shopify::Field::Identifier(),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now')};
}
# Minimal variables required to create.
sub minimal() { return ["title"]; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1
