
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Metafield;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_metafields');
__PACKAGE__->add_columns(
	"namespace", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"value", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"description", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"key", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"value_type", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"id", { data_type => 'INT', is_nullable => '1' },
	"owner_resource", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"owner_id", { data_type => 'INT', is_nullable => '1' },
	"shop_id", { data_type => "INT" }
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(owner => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'owner_id');
sub represents { return 'WWW::Shopify::Model::Metafield'; }
sub parent_variable { return undef; }

1;