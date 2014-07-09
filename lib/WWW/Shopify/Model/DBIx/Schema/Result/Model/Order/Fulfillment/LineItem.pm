
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
	"variant_inventory_management", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"fulfillment_status", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"variant_title", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"price", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"sku", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"product_exists", { is_nullable => '1', data_type => 'BOOL' },
	"taxable", { data_type => 'BOOL', is_nullable => '1' },
	"fulfillment_service", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"requires_shipping", { data_type => 'BOOL', is_nullable => '1' },
	"title", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"quantity", { data_type => 'INT', is_nullable => '1' },
	"vendor", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"gift_card", { data_type => 'BOOL', is_nullable => '1' },
	"grams", { data_type => 'INT', is_nullable => '1' },
	"variant_id", { data_type => 'BIGINT', is_nullable => '1' },
	"product_id", { data_type => 'BIGINT', is_nullable => '1' }
);
__PACKAGE__->set_primary_key('id');





__PACKAGE__->belongs_to(variant => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Variant', 'variant_id');
__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id');
__PACKAGE__->has_many(tax_lines => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Fulfillment::LineItem::TaxLine', 'line_item_id');
__PACKAGE__->has_many(properties => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Fulfillment::LineItem::Property', 'line_item_id');
sub represents { return 'WWW::Shopify::Model::Order::Fulfillment::LineItem'; }
sub parent_variable { return 'fulfillment_id'; }

1;