
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::DiscountProduct;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_discountsproducts');
__PACKAGE__->add_columns(
	'discount_id', { data_type => 'INT', is_nullable => 0 },
	'product_id', { data_type => 'INT', is_nullable => 0 }
);
__PACKAGE__->belongs_to(discount => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Discount', 'discount_id');
__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id');

1;