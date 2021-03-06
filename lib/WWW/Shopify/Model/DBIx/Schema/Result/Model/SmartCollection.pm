
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::SmartCollection;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_smart_collections');
__PACKAGE__->add_columns(
	"template_suffix", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"sort_order", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"handle", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"published_at", { is_nullable => '1', data_type => 'DATETIME' },
	"published_scope", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"title", { data_type => 'TEXT', is_nullable => '1' },
	"updated_at", { is_nullable => '1', data_type => 'DATETIME' },
	"body_html", { data_type => 'TEXT', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->has_many(rules => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::SmartCollection::Rule', 'smart_collection_id');
__PACKAGE__->has_many(image => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::SmartCollection::Image', 'smart_collection_id');
sub represents { return 'WWW::Shopify::Model::SmartCollection'; }
sub parent_variable { return undef; }

1;