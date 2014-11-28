
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Metafield;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_metafields');
__PACKAGE__->add_columns(
	"key", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"value", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"description", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"value_type", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"namespace", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"owner_resource", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"owner_id", { data_type => 'BIGINT', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(owner => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'owner_id', { join_type => 'left' });
sub represents { return 'WWW::Shopify::Model::Metafield'; }
sub parent_variable { return undef; }

1;