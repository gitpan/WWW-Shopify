
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomerGroup;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_customer_groups');
__PACKAGE__->add_columns(
	"name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"query", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"updated_at", { is_nullable => '1', data_type => 'DATETIME' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::CustomerGroup'; }
sub parent_variable { return undef; }

1;