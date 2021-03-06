
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Page;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_pages');
__PACKAGE__->add_columns(
	"template_suffix", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"handle", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"summary_html", { data_type => 'TEXT', is_nullable => '1' },
	"published_at", { is_nullable => '1', data_type => 'DATETIME' },
	"author", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"title", { data_type => 'TEXT', is_nullable => '1' },
	"updated_at", { is_nullable => '1', data_type => 'DATETIME' },
	"body_html", { data_type => 'TEXT', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"shop_id", { is_nullable => '1', data_type => 'BIGINT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id', { join_type => 'left' });
__PACKAGE__->has_many(metafields_hasmany => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::MetafieldPage', 'page_id');
__PACKAGE__->many_to_many(metafields => 'metafields_hasmany', 'metafield');
sub represents { return 'WWW::Shopify::Model::Page'; }
sub parent_variable { return undef; }

1;