#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Order::NoteAttributes;
use parent "WWW::Shopify::Model::NestedItem";

sub stats($) { return {
	"name" => new WWW::Shopify::Field::String::Words(1, 3),
	"value" => new WWW::Shopify::Field::String::Words(1, 10)};
}
sub singular($) { return "note_attribute"; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1
