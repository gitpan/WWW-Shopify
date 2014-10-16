
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Blog;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_blogs');
__PACKAGE__->add_columns(
	"tags", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"handle", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"template_suffix", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"feedburner_location", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"feedburner", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"title", { data_type => 'TEXT', is_nullable => '1' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"commentable", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->has_many(metafields_hasmany => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::BlogMetafield', 'blog_id');
__PACKAGE__->many_to_many(metafields => 'metafields_hasmany', 'metafield');
sub represents { return 'WWW::Shopify::Model::Blog'; }
sub parent_variable { return undef; }

1;