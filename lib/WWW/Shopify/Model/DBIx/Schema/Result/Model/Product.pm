
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Product;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_products');
__PACKAGE__->add_columns(
	"body_html", { data_type => 'TEXT', is_nullable => '1' },
	"vendor", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"title", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"template_suffix", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"tags", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"published_scope", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"published_at", { is_nullable => '1', data_type => 'DATETIME' },
	"updated_at", { is_nullable => '1', data_type => 'DATETIME' },
	"handle", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"product_type", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->has_many(variants => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Variant', 'product_id');
__PACKAGE__->has_many(images => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Image', 'product_id');
__PACKAGE__->has_many(options => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Option', 'product_id');
__PACKAGE__->has_many(metafields_hasmany => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::MetafieldProduct', 'product_id');
__PACKAGE__->many_to_many(metafields => 'metafields_hasmany', 'metafield');
sub represents { return 'WWW::Shopify::Model::Product'; }
sub parent_variable { return undef; }
__PACKAGE__->has_many('collects', 'WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomCollection::Collect', 'product_id');

1;