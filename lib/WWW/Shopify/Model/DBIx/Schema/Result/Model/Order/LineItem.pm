
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_orders_line_items');
__PACKAGE__->add_columns(
	"order_id", { data_type => 'bigint' },
	"price", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"requires_shipping", { data_type => 'BOOL', is_nullable => '1' },
	"name", { data_type => 'TEXT', is_nullable => '1' },
	"title", { is_nullable => '1', data_type => 'TEXT' },
	"variant_inventory_management", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"taxable", { is_nullable => '1', data_type => 'BOOL' },
	"grams", { is_nullable => '1', data_type => 'INT' },
	"gift_card", { data_type => 'BOOL', is_nullable => '1' },
	"vendor", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"quantity", { data_type => 'INT', is_nullable => '1' },
	"sku", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"fulfillment_status", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"fulfillment_service", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"product_exists", { data_type => 'BOOL', is_nullable => '1' },
	"variant_title", { is_nullable => '1', data_type => 'TEXT' },
	"product_id", { is_nullable => '1', data_type => 'BIGINT' },
	"variant_id", { data_type => 'BIGINT', is_nullable => '1' }
);
__PACKAGE__->set_primary_key('id');





__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id');
__PACKAGE__->belongs_to(variant => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Variant', 'variant_id');
__PACKAGE__->has_many(properties => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem::Property', 'line_item_id');
__PACKAGE__->has_many(tax_lines => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem::TaxLine', 'line_item_id');
sub represents { return 'WWW::Shopify::Model::Order::LineItem'; }
sub parent_variable { return 'order_id'; }

1;