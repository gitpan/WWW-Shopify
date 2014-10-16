
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Variant;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_products_variants');
__PACKAGE__->add_columns(
	"taxable", { data_type => 'BOOL', is_nullable => '1' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"grams", { is_nullable => '1', data_type => 'INT' },
	"option1", { is_nullable => '1', data_type => 'TEXT' },
	"inventory_quantity", { is_nullable => '1', data_type => 'INT' },
	"option3", { is_nullable => '1', data_type => 'TEXT' },
	"sku", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"position", { is_nullable => '1', data_type => 'INT' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"old_inventory_quantity", { is_nullable => '1', data_type => 'INT' },
	"inventory_policy", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"inventory_management", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"price", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"updated_at", { is_nullable => '1', data_type => 'DATETIME' },
	"requires_shipping", { data_type => 'BOOL', is_nullable => '1' },
	"barcode", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"fufillment_service", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"compare_at_price", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"title", { is_nullable => '1', data_type => 'TEXT' },
	"option2", { is_nullable => '1', data_type => 'TEXT' },
	"image_id", { is_nullable => '1', data_type => 'BIGINT' },
	"product_id", { data_type => 'BIGINT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(image => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Image', 'image_id');
__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id');
__PACKAGE__->has_many(metafields_hasmany => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::MetafieldVariant', 'variant_id');
__PACKAGE__->many_to_many(metafields => 'metafields_hasmany', 'metafield');
sub represents { return 'WWW::Shopify::Model::Product::Variant'; }
sub parent_variable { return 'product_id'; }

1;