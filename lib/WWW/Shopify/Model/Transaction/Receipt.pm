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
	# Stripe?
	"code" => new WWW::Shopify::Field::String(),
	"success" => new WWW::Shopify::Field::String(),
	"message" => new WWW::Shopify::Field::String(),
	"front_end" => new WWW::Shopify::Field::Int(),
	"avs_end" => new WWW::Shopify::Field::String(),
	"avs_result" => new WWW::Shopify::Field::String(),
	"avs_result_code" => new WWW::Shopify::Field::String(),
	"card_code" => new WWW::Shopify::Field::String(),
	"authorization_code" => new WWW::Shopify::Field::String(),
	"cardholder_authorization_code" => new WWW::Shopify::Field::String(),
	"action" => new WWW::Shopify::Field::String(),
	"risk" => new WWW::Shopify::Field::String(),
	"reference" => new WWW::Shopify::Field::String(),
	"order_number" => new WWW::Shopify::Field::String(),
	"recurring" => new WWW::Shopify::Field::String(),
	# Paypal
	"ack" => new WWW::Shopify::Field::String::Enum(["Success", "Failure"]),
	"timestamp" => new WWW::Shopify::Field::Date(),
	"correlation_id" => new WWW::Shopify::Field::String(),
	"version" => new WWW::Shopify::Field::Int(),
	"build" => new WWW::Shopify::Field::Int(),
	"amount" => new WWW::Shopify::Field::Money(),
	"amount_currency" => new WWW::Shopify::Field::Currency(),
	"avs_code" => new WWW::Shopify::Field::String(),
	"cvv2_code" => new WWW::Shopify::Field::String(),
	"transaction_id" => new WWW::Shopify::Field::String(),
	"payment_details" => new WWW::Shopify::Field::Freeform(),
	"response_code" => new WWW::Shopify::Field::String(),
	"response_reason_code" =>  new WWW::Shopify::Field::String(),
}; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1;
