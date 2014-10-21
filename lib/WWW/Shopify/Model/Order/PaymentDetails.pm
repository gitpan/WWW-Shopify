#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Order::PaymentDetails;
use parent "WWW::Shopify::Model::NestedItem";

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"avs_result_code" => new WWW::Shopify::Field::String(),
	"credit_card_bin" => new WWW::Shopify::Field::String(),
	"cvv_result_code" => new WWW::Shopify::Field::String(),
	"credit_card_number" => new WWW::Shopify::Field::String::Regex('XXXX-XXXX-XXXX-\d{4}'),
	"credit_card_company" => new WWW::Shopify::Field::String()
}; }
sub plural($) { return $_[0]->singular(); }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1;
