
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Page;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_pages');
__PACKAGE__->add_columns(
	"body_html", { is_nullable => '1', data_type => 'TEXT' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"template_suffix", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"published_at", { is_nullable => '1', data_type => 'DATETIME' },
	"summary_html", { data_type => 'TEXT', is_nullable => '1' },
	"updated_at", { is_nullable => '1', data_type => 'DATETIME' },
	"title", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"handle", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"author", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"shop_id", { is_nullable => '1', data_type => 'BIGINT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');
__PACKAGE__->has_many(metafields_hasmany => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::MetafieldPage', 'page_id');
__PACKAGE__->many_to_many(metafields => 'metafields_hasmany', 'metafield');
sub represents { return 'WWW::Shopify::Model::Page'; }
sub parent_variable { return undef; }

1;