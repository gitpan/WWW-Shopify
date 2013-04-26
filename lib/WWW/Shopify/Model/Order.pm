#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Order;
use parent "WWW::Shopify::Model::Item";

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
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
	"payment_details" => new WWW::Shopify::Field::Relation::OwnOne("WWW::Shopify::Model::Order::PaymentDetails"),
	"billing_address" => new WWW::Shopify::Field::Relation::OwnOne("WWW::Shopify::Model::Address"),
	"shipping_address" => new WWW::Shopify::Field::Relation::OwnOne("WWW::Shopify::Model::Address"),
	"fufillments" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Order::Fulfillment"),
	"client_details" => new WWW::Shopify::Field::Relation::OwnOne("WWW::Shopify::Model::Order::ClientDetails"),
	"customer" => new WWW::Shopify::Field::Relation::OwnOne("WWW::Shopify::Model::Customer"),
	"metafields" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Metafield")
}; }
my $queries; sub queries { return $queries; }
BEGIN { $queries = {
	created_at_min => new WWW::Shopify::Query::LowerBound('created_at'),
	created_at_max => new WWW::Shopify::Query::UpperBound('created_at'),
	updated_at_min => new WWW::Shopify::Query::LowerBound('updated_at'),
	updated_at_max => new WWW::Shopify::Query::UpperBound('updated_at'),
	status => new WWW::Shopify::Query::Enum('status', ['open', 'closed', 'cancelled', 'any']),
	financial_status => new WWW::Shopify::Query::Match('financial_status'),
	fulfillment_status => new WWW::Shopify::Query::Match('fulfillment_status'),
	since_id => new WWW::Shopify::Query::LowerBound('id')
}; }

sub creatable { return undef; }
sub updatable { return undef; }
sub closable { return 1; }
sub openable { return 1; }
sub cancellable { return 1; }

sub update_filled { return qw(updated_at); }
sub update_fields { return qw(note note_attributes email buyer_accepts_marketing); };

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1
