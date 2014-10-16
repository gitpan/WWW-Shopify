
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_orders');
__PACKAGE__->add_columns(
	"source_name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"browser_ip", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"inventory_behaviour", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"send_webhooks", { is_nullable => '1', data_type => 'BOOL' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"total_price_usd", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"note", { data_type => 'TEXT', is_nullable => '1' },
	"cart_token", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"total_price", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"buyer_accepts_marketing", { data_type => 'BOOL', is_nullable => '1' },
	"gateway", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"landing_site", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"financial_status", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"send_fulfillment_receipt", { is_nullable => '1', data_type => 'BOOL' },
	"referring_site", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"source", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"number", { is_nullable => '1', data_type => 'INT' },
	"currency", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"tags", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"subtotal_price", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"closed_at", { data_type => 'DATETIME', is_nullable => '1' },
	"token", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"reference", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"processing_method", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"total_weight", { data_type => 'FLOAT', is_nullable => '1' },
	"fulfillment_status", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"total_tax", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"order_number", { data_type => 'INT', is_nullable => '1' },
	"total_line_items_price", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"source_url", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"total_discounts", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"taxes_included", { is_nullable => '1', data_type => 'BOOL' },
	"cancel_reason", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"source_identifier", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"send_receipt", { is_nullable => '1', data_type => 'BOOL' },
	"landing_site_ref", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"email", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"cancelled_at", { data_type => 'DATETIME', is_nullable => '1' },
	"location_id", { is_nullable => '1', data_type => 'BIGINT' },
	"customer_id", { is_nullable => '1', data_type => 'BIGINT' },
	"shipping_address_id", { is_nullable => '1', data_type => 'BIGINT' },
	"billing_address_id", { is_nullable => '1', data_type => 'BIGINT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(location => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Location', 'location_id');
__PACKAGE__->belongs_to(customer => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Customer', 'customer_id');
__PACKAGE__->belongs_to(shipping_address => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Address', 'shipping_address_id');
__PACKAGE__->belongs_to(billing_address => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Address', 'billing_address_id');
__PACKAGE__->has_many(refund => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Refund', 'order_id');
__PACKAGE__->has_many(note_attributes => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::NoteAttributes', 'order_id');
__PACKAGE__->has_many(tax_lines => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::TaxLine', 'order_id');
__PACKAGE__->has_many(line_items => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem', 'order_id');
__PACKAGE__->has_many(transactions => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Transaction', 'order_id');
__PACKAGE__->has_many(shipping_lines => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::ShippingLine', 'order_id');
__PACKAGE__->has_many(fulfillments => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Fulfillment', 'order_id');
__PACKAGE__->has_many(discount_codes => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::DiscountCode', 'order_id');
__PACKAGE__->has_one(payment_details => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::PaymentDetails', 'order_id');
__PACKAGE__->has_one(client_details => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::ClientDetails', 'order_id');
__PACKAGE__->has_many(metafields_hasmany => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::MetafieldOrder', 'order_id');
__PACKAGE__->many_to_many(metafields => 'metafields_hasmany', 'metafield');
sub represents { return 'WWW::Shopify::Model::Order'; }
sub parent_variable { return undef; }

1;