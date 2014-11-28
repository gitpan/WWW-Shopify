
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_orders');
__PACKAGE__->add_columns(
	"financial_status", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"subtotal_price", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"total_weight", { data_type => 'FLOAT', is_nullable => '1' },
	"total_tax", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"browser_ip", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"landing_site", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"gateway", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"order_number", { is_nullable => '1', data_type => 'INT' },
	"processing_method", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"taxes_included", { is_nullable => '1', data_type => 'BOOL' },
	"total_price", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"source_name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"source_url", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"email", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"referring_site", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"currency", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"cancelled_at", { data_type => 'DATETIME', is_nullable => '1' },
	"send_receipt", { data_type => 'BOOL', is_nullable => '1' },
	"number", { data_type => 'INT', is_nullable => '1' },
	"send_fulfillment_receipt", { data_type => 'BOOL', is_nullable => '1' },
	"fulfillment_status", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"note", { is_nullable => '1', data_type => 'TEXT' },
	"cart_token", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"send_webhooks", { data_type => 'BOOL', is_nullable => '1' },
	"total_discounts", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"inventory_behaviour", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"total_price_usd", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"total_line_items_price", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"landing_site_ref", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"source_identifier", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"cancel_reason", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"tags", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"reference", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"token", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"buyer_accepts_marketing", { data_type => 'BOOL', is_nullable => '1' },
	"closed_at", { data_type => 'DATETIME', is_nullable => '1' },
	"source", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"location_id", { is_nullable => '1', data_type => 'BIGINT' },
	"shipping_address_id", { data_type => 'BIGINT', is_nullable => '1' },
	"customer_id", { data_type => 'BIGINT', is_nullable => '1' },
	"billing_address_id", { is_nullable => '1', data_type => 'BIGINT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(location => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Location', 'location_id', { join_type => 'left' });
__PACKAGE__->belongs_to(shipping_address => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Address', 'shipping_address_id', { join_type => 'left' });
__PACKAGE__->belongs_to(customer => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Customer', 'customer_id', { join_type => 'left' });
__PACKAGE__->belongs_to(billing_address => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Address', 'billing_address_id', { join_type => 'left' });
__PACKAGE__->has_many(discount_codes => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::DiscountCode', 'order_id');
__PACKAGE__->has_many(fulfillments => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Fulfillment', 'order_id');
__PACKAGE__->has_many(line_items => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem', 'order_id');
__PACKAGE__->has_many(tax_lines => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::TaxLine', 'order_id');
__PACKAGE__->has_many(shipping_lines => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::ShippingLine', 'order_id');
__PACKAGE__->has_many(refund => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Refund', 'order_id');
__PACKAGE__->has_many(note_attributes => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::NoteAttributes', 'order_id');
__PACKAGE__->has_many(transactions => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Transaction', 'order_id');
__PACKAGE__->has_one(payment_details => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::PaymentDetails', 'order_id');
__PACKAGE__->has_one(client_details => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::ClientDetails', 'order_id');
__PACKAGE__->has_many(metafields_hasmany => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::MetafieldOrder', 'order_id');
__PACKAGE__->many_to_many(metafields => 'metafields_hasmany', 'metafield');
sub represents { return 'WWW::Shopify::Model::Order'; }
sub parent_variable { return undef; }

1;