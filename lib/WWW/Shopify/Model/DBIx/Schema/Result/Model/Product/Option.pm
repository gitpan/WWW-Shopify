
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Option;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_products_options');
__PACKAGE__->add_columns(
	"name", { data_type => 'TEXT', is_nullable => '1' },
	"position", { is_nullable => '1', data_type => 'INT' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"product_id", { data_type => 'BIGINT' }
);
__PACKAGE__->set_primary_key('id');





__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id');
sub represents { return 'WWW::Shopify::Model::Product::Option'; }
sub parent_variable { return 'product_id'; }

1;