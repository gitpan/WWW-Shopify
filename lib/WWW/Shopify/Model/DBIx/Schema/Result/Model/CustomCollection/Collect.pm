
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomCollection::Collect;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_collects');
__PACKAGE__->add_columns(
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"featured", { is_nullable => '1', data_type => 'BOOL' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"position", { is_nullable => '1', data_type => 'INT' },
	"sort_value", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"collection_id", { is_nullable => '1', data_type => 'BIGINT' },
	"product_id", { data_type => 'BIGINT', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(collection => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomCollection', 'collection_id');
__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id');
sub represents { return 'WWW::Shopify::Model::CustomCollection::Collect'; }
sub parent_variable { return undef; }

1;