
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Variant;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_products_variants');
__PACKAGE__->add_columns(
	"option1", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"sku", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"position", { data_type => 'INT', is_nullable => '1' },
	"compare_at_price", { data_type => 'DECIMAL', is_nullable => '1' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"id", { data_type => 'INT', is_nullable => '0' },
	"inventory_policy", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"inventory_management", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"grams", { data_type => 'INT', is_nullable => '1' },
	"option3", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"taxable", { data_type => 'BOOL', is_nullable => '1' },
	"option2", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"inventory_quantity", { data_type => 'INT', is_nullable => '1' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"price", { data_type => 'DECIMAL', is_nullable => '1' },
	"title", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"fufillment_service", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"requires_shipping", { data_type => 'BOOL', is_nullable => '1' },
	"product_id", { data_type => 'INT' },
	"shop_id", { data_type => "INT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id');
__PACKAGE__->has_many(metafields_hasmany => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::MetafieldVariant', 'variant_id');
__PACKAGE__->many_to_many(metafields => 'metafields_hasmany', 'metafield');
sub represents { return 'WWW::Shopify::Model::Product::Variant'; }
sub parent_variable { return 'product_id'; }

1;