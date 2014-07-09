
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Image;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_products_images');
__PACKAGE__->add_columns(
	"position", { is_nullable => '1', data_type => 'INT' },
	"src", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"filename", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"attachment", { is_nullable => '1', data_type => 'TEXT' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"updated_at", { is_nullable => '1', data_type => 'DATETIME' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"product_id", { data_type => 'BIGINT' }
);
__PACKAGE__->set_primary_key('id');





__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id');
__PACKAGE__->has_many(metafields_hasmany => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::MetafieldImage', 'image_id');
__PACKAGE__->many_to_many(metafields => 'metafields_hasmany', 'metafield');
sub represents { return 'WWW::Shopify::Model::Product::Image'; }
sub parent_variable { return 'product_id'; }

1;