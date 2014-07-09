
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Checkout;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_checkouts');
__PACKAGE__->add_columns(
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"cart_token", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"abandoned_checkout_url", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"email", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"total_price", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"total_discounts", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"total_weight", { is_nullable => '1', data_type => 'FLOAT' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"subtotal_price", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"taxes_included", { data_type => 'BOOL', is_nullable => '1' },
	"referring_site", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"total_tax", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"token", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"landing_site", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"buyer_accepts_marketing", { data_type => 'BOOL', is_nullable => '1' },
	"note", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"source_name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"total_line_items_price", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"shipping_address_id", { is_nullable => '1', data_type => 'BIGINT' },
	"customer_id", { is_nullable => '1', data_type => 'BIGINT' },
	"billing_address_id", { is_nullable => '1', data_type => 'BIGINT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(shipping_address => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Address', 'shipping_address_id');
__PACKAGE__->belongs_to(customer => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Customer', 'customer_id');
__PACKAGE__->belongs_to(billing_address => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Address', 'billing_address_id');
__PACKAGE__->has_many(line_items => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Checkout::LineItem', 'checkout_id');
__PACKAGE__->has_many(note_attributes => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Checkout::NoteAttributes', 'checkout_id');
__PACKAGE__->has_many(shipping_lines => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Checkout::ShippingLine', 'checkout_id');
__PACKAGE__->has_many(tax_lines => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Checkout::TaxLine', 'checkout_id');
__PACKAGE__->has_many(discount_codes => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Checkout::DiscountCode', 'checkout_id');
sub represents { return 'WWW::Shopify::Model::Checkout'; }
sub parent_variable { return undef; }

1;