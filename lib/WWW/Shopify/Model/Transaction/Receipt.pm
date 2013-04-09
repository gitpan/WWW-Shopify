#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Transaction::Receipt;
use parent 'WWW::Shopify::Model::NestedItem';

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"testcase" => new WWW::Shopify::Field::Boolean(),
	"authorization" => new WWW::Shopify::Field::String("[0-9]{4,10}")
}; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1;
