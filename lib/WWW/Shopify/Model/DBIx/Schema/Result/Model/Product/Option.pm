
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Option;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_products_options');
__PACKAGE__->add_columns(
	"name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"product_id", { data_type => 'INT' },
	"id", { data_type => 'INT' }
);
__PACKAGE__->set_primary_key('id');




sub represents { return 'WWW::Shopify::Model::Product::Option'; }
sub parent_variable { return 'product_id'; }

1;