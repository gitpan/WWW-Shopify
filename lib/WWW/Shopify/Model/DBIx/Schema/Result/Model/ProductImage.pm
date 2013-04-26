
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::ProductImage;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_productsimages');
__PACKAGE__->add_columns(
	'product_id', { data_type => 'INT', is_nullable => 0 },
	'image_id', { data_type => 'INT', is_nullable => 0 }
);
__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id');
__PACKAGE__->belongs_to(image => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Image', 'image_id');

1;