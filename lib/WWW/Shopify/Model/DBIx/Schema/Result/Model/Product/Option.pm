
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Option;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_products_options');
__PACKAGE__->add_columns(
	"position", { data_type => 'INT', is_nullable => '1' },
	"name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'INT', is_nullable => '0' },
	"product_id", { data_type => 'INT' }
);
__PACKAGE__->set_primary_key('id');





__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id');
sub represents { return 'WWW::Shopify::Model::Product::Option'; }
sub parent_variable { return 'product_id'; }

1;