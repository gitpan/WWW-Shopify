
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Fulfillment::LineItem;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_fulfillments_line_items');
__PACKAGE__->add_columns(
	"fulfillment_id", { data_type => 'bigint' },
	"title", { is_nullable => '1', data_type => 'TEXT' },
	"variant_inventory_management", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"name", { data_type => 'TEXT', is_nullable => '1' },
	"requires_shipping", { data_type => 'BOOL', is_nullable => '1' },
	"price", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"variant_title", { is_nullable => '1', data_type => 'TEXT' },
	"product_exists", { is_nullable => '1', data_type => 'BOOL' },
	"fulfillment_service", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"fulfillment_status", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"sku", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"vendor", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"quantity", { data_type => 'INT', is_nullable => '1' },
	"gift_card", { is_nullable => '1', data_type => 'BOOL' },
	"grams", { data_type => 'INT', is_nullable => '1' },
	"taxable", { data_type => 'BOOL', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"product_id", { data_type => 'BIGINT', is_nullable => '1' },
	"variant_id", { data_type => 'BIGINT', is_nullable => '1' }
);
__PACKAGE__->set_primary_key('id');





__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id');
__PACKAGE__->belongs_to(variant => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Variant', 'variant_id');
__PACKAGE__->has_many(properties => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Fulfillment::LineItem::Property', 'line_item_id');
__PACKAGE__->has_many(tax_lines => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Fulfillment::LineItem::TaxLine', 'line_item_id');
sub represents { return 'WWW::Shopify::Model::Order::Fulfillment::LineItem'; }
sub parent_variable { return 'fulfillment_id'; }

1;