
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_line_items');
__PACKAGE__->add_columns(
	"sku", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"fulfillment_service", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'INT', is_nullable => '0' },
	"grams", { data_type => 'INT', is_nullable => '1' },
	"quantity", { data_type => 'INT', is_nullable => '1' },
	"name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"variant_title", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"fulfillment_status", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"price", { data_type => 'DECIMAL', is_nullable => '1' },
	"title", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"variant_inventory_management", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"requires_shipping", { data_type => 'BOOL', is_nullable => '1' },
	"vendor", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"product_id", { data_type => 'INT', is_nullable => '1' },
	"variant_id", { data_type => 'INT', is_nullable => '1' },
	"shop_id", { data_type => "INT" }
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id');
__PACKAGE__->belongs_to(variant => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Variant', 'variant_id');
__PACKAGE__->has_many(properties => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem::Property', 'line_item_id');
sub represents { return 'WWW::Shopify::Model::Order::LineItem'; }
sub parent_variable { return undef; }

1;