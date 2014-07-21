
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
	"grams", { is_nullable => '1', data_type => 'INT' },
	"variant_inventory_management", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"vendor", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"variant_title", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"sku", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"taxable", { data_type => 'BOOL', is_nullable => '1' },
	"fulfillment_status", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"quantity", { data_type => 'INT', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"requires_shipping", { is_nullable => '1', data_type => 'BOOL' },
	"price", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"fulfillment_service", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"title", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"product_exists", { is_nullable => '1', data_type => 'BOOL' },
	"gift_card", { is_nullable => '1', data_type => 'BOOL' },
	"variant_id", { is_nullable => '1', data_type => 'BIGINT' },
	"product_id", { is_nullable => '1', data_type => 'BIGINT' }
);
__PACKAGE__->set_primary_key('id');





__PACKAGE__->belongs_to(variant => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Variant', 'variant_id');
__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id');
__PACKAGE__->has_many(properties => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem::Property', 'line_item_id');
__PACKAGE__->has_many(tax_lines => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem::TaxLine', 'line_item_id');
sub represents { return 'WWW::Shopify::Model::Order::LineItem'; }
sub parent_variable { return 'order_id'; }

1;