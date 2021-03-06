
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomCollection::Collect;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_collects');
__PACKAGE__->add_columns(
	"sort_value", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"featured", { data_type => 'BOOL', is_nullable => '1' },
	"position", { is_nullable => '1', data_type => 'INT' },
	"product_id", { data_type => 'BIGINT', is_nullable => '1' },
	"collection_id", { is_nullable => '1', data_type => 'BIGINT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id', { join_type => 'left' });
__PACKAGE__->belongs_to(collection => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomCollection', 'collection_id', { join_type => 'left' });
sub represents { return 'WWW::Shopify::Model::CustomCollection::Collect'; }
sub parent_variable { return undef; }

1;