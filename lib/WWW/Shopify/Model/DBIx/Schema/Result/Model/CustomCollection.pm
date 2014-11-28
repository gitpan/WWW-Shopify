
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomCollection;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_custom_collections');
__PACKAGE__->add_columns(
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"body_html", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"published_at", { data_type => 'DATETIME', is_nullable => '1' },
	"title", { data_type => 'TEXT', is_nullable => '1' },
	"published_scope", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"published", { data_type => 'BOOL', is_nullable => '1' },
	"template_suffix", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"handle", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"sort_order", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->has_one(image => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomCollection::Image', 'custom_collection_id');
__PACKAGE__->has_many(metafields_hasmany => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomCollectionMetafield', 'custom_collection_id');
__PACKAGE__->many_to_many(metafields => 'metafields_hasmany', 'metafield');
__PACKAGE__->has_many(collects_hasmany => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomCollectionCollect', 'custom_collection_id');
__PACKAGE__->many_to_many(collects => 'collects_hasmany', 'collect');
sub represents { return 'WWW::Shopify::Model::CustomCollection'; }
sub parent_variable { return undef; }

1;