#!/usr/bin/perl

use strict;
use warnings;

package WWW::Shopify::Model::SmartCollection::Rule;
use parent 'WWW::Shopify::Model::NestedItem';

sub mods { return {
	"column" => new WWW::Shopify::Field::String::Words(1),
	"relation" => new WWW::Shopify::Field::String("(equals|starts_with)"),
	"condition" => new WWW::Shopify::Field::String::Words(2)
	};
}

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1;
