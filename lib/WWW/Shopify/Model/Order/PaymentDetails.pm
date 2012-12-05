#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Order::PaymentDetails;
use parent "WWW::Shopify::Model::NestedItem";

sub plural($) { return $_[0]->singular(); }

sub stats($) { return {
	"avs_result_code" => new WWW::Shopify::Field::String(),
	"credit_card_bin" => new WWW::Shopify::Field::String(),
	"cvv_result_code" => new WWW::Shopify::Field::String(),
	"credit_card_numer" => new WWW::Shopify::Field::String('XXXX\-XXXX\-XXXX\-\d{4}'),
	"credit_card_company" => new WWW::Shopify::Field::String("(Visa|Mastercard|AMEX")};
}

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1;
