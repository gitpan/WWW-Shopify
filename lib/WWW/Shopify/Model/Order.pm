#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Order;
use parent "WWW::Shopify::Model::Item";

sub stats($) { return {
	"buyer_accepts_marketing" => new WWW::Shopify::Field::Boolean(),
	"cancel_reason" => new WWW::Shopify::Field::String(),
	"cancelled_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"cart_token" => new WWW::Shopify::Field::String("[0-9a-f]{32}"),
	"closed_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"currency" => new WWW::Shopify::Field::Currency(),
	"email" => new WWW::Shopify::Field::String::Email(),
	"financial_status" => new WWW::Shopify::Field::String::Enum(["authorized", "pending", "paid", "abandoned", "refunded", "voided"]),
	"fulfillment_status" => new WWW::Shopify::Field::String(),
	"gateway" => new WWW::Shopify::Field::String(),
	"id" => new WWW::Shopify::Field::Identifier(),
	"landing_site" => new WWW::Shopify::Field::String::URL(),
	"name" => new WWW::Shopify::Field::String("#[1-9][0-9]{0,3}"),
	"note" => new WWW::Shopify::Field::String::Words(3, 20),
	"number" => new WWW::Shopify::Field::Int(),
	"referring_site" => new WWW::Shopify::Field::String::URL(),
	"subtotal_price" => new WWW::Shopify::Field::Money(),
	"taxes_included" => new WWW::Shopify::Field::Boolean(),
	"token" => new WWW::Shopify::Field::String("[0-9a-f]{32}"),
	"total_discounts" =>  new WWW::Shopify::Field::Money(),
	"total_line_items_price" =>  new WWW::Shopify::Field::Money(),
	"total_price" =>  new WWW::Shopify::Field::Money(),
	"total_price_usd" =>  new WWW::Shopify::Field::Money(),
	"total_tax" =>  new WWW::Shopify::Field::Money(),
	"total_weight" => new WWW::Shopify::Field::Float(),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"browser_ip" => new WWW::Shopify::Field::String::IPAddress(),
	"landing_site_ref" => new WWW::Shopify::Field::String("[a-z]{0,4}"),
	"order_number" => new WWW::Shopify::Field::Int(),
	"discount_codes" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Order::DiscountCode"),
	"note_attributes" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Order::NoteAttributes"),
	"processing_method" => new WWW::Shopify::Field::String("(direct|indirect)"),
	"line_items" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Order::LineItem"),
	"shipping_lines" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Order::ShippingLine"),
	"tax_lines" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Order::TaxLine"),
#	"payment_details" => ["WWW::Shopify::Model::Order::PaymentDetails", WWW::Shopify->RELATION_ONE],
#	"billing_address" => ["WWW::Shopify::Model::Address", WWW::Shopify->RELATION_ONE],
#	"shipping_address" => ["WWW::Shopify::Model::Address", WWW::Shopify->RELATION_ONE],
	"fufillments" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Order::Fulfillment"),
#	"client_details" => ["WWW::Shopify::Model::Order::ClientDetails", WWW::Shopify->RELATION_ONE],
	"customer" => new WWW::Shopify::Field::Relation::OwnOne("WWW::Shopify::Model::Customer"),
	"metafields" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Metafield") };
}

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1
