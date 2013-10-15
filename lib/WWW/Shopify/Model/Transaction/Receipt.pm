#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Transaction::Receipt;
use parent 'WWW::Shopify::Model::NestedItem';

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"testcase" => new WWW::Shopify::Field::Boolean(),
	"authorization" => new WWW::Shopify::Field::String::Regex("[0-9]{4,10}"),
	"code" => new WWW::Shopify::Field::String(),
	"success" => new WWW::Shopify::Field::String(),
	"message" => new WWW::Shopify::Field::String(),
	"front_end" => new WWW::Shopify::Field::Int(),
	"avs_end" => new WWW::Shopify::Field::String(),
	"avs_result" => new WWW::Shopify::Field::String(),
	"risk" => new WWW::Shopify::Field::String(),
	"reference" => new WWW::Shopify::Field::String(),
	"order_number" => new WWW::Shopify::Field::String(),
	"recurring" => new WWW::Shopify::Field::String(),
}; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1;
