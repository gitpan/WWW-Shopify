#!/usr/bin/perl

use strict;
use warnings;

package WWW::Shopify::Model::SmartCollection::Rule;
use parent 'WWW::Shopify::Model::NestedItem';

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"column" => new WWW::Shopify::Field::String::Words(1),
	"relation" => new WWW::Shopify::Field::String("(equals|starts_with)"),
	"condition" => new WWW::Shopify::Field::String::Words(2)
}; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1;
