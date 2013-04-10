
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Image;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_products_images');
__PACKAGE__->add_columns(
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"src", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"position", { data_type => 'INT', is_nullable => '1' },
	"id", { data_type => 'INT', is_nullable => '0' },
	"product_id", { data_type => 'INT', is_nullable => '1' }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id');
sub represents { return 'WWW::Shopify::Model::Product::Image'; }
sub parent_variable { return 'product_id'; }

1;