
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomerGroup;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_customer_groups');
__PACKAGE__->add_columns(
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"updated_at", { is_nullable => '1', data_type => 'DATETIME' },
	"query", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::CustomerGroup'; }
sub parent_variable { return undef; }

1;