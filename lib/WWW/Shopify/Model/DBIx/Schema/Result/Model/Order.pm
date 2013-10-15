
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_orders');
__PACKAGE__->add_columns(
	"total_price", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"closed_at", { data_type => 'DATETIME', is_nullable => '1' },
	"taxes_included", { data_type => 'BOOL', is_nullable => '1' },
	"email", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"total_price_usd", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"total_discounts", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"order_number", { data_type => 'INT', is_nullable => '1' },
	"financial_status", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"landing_site", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"cart_token", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"total_line_items_price", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"fulfillment_status", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"subtotal_price", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"total_tax", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"source", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"number", { data_type => 'INT', is_nullable => '1' },
	"gateway", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"buyer_accepts_marketing", { data_type => 'BOOL', is_nullable => '1' },
	"cancel_reason", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"currency", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"reference", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"landing_site_ref", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"token", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"cancelled_at", { data_type => 'DATETIME', is_nullable => '1' },
	"total_weight", { data_type => 'FLOAT', is_nullable => '1' },
	"processing_method", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"referring_site", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"note", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"browser_ip", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"billing_address_id", { data_type => 'BIGINT', is_nullable => '1' },
	"shipping_address_id", { data_type => 'BIGINT', is_nullable => '1' },
	"customer_id", { data_type => 'BIGINT', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(billing_address => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Address', 'billing_address_id');
__PACKAGE__->belongs_to(shipping_address => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Address', 'shipping_address_id');
__PACKAGE__->belongs_to(customer => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Customer', 'customer_id');
__PACKAGE__->has_many(line_items => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem', 'order_id');
__PACKAGE__->has_many(note_attributes => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::NoteAttributes', 'order_id');
__PACKAGE__->has_many(discount_codes => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::DiscountCode', 'order_id');
__PACKAGE__->has_many(shipping_lines => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::ShippingLine', 'order_id');
__PACKAGE__->has_many(tax_lines => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::TaxLine', 'order_id');
__PACKAGE__->has_many(fulfillments => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Fulfillment', 'order_id');
__PACKAGE__->has_one(payment_details => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::PaymentDetails', 'order_id');
__PACKAGE__->has_one(client_details => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::ClientDetails', 'order_id');
__PACKAGE__->has_many(metafields_hasmany => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::MetafieldOrder', 'order_id');
__PACKAGE__->many_to_many(metafields => 'metafields_hasmany', 'metafield');
sub represents { return 'WWW::Shopify::Model::Order'; }
sub parent_variable { return undef; }

1;