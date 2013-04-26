
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::OrderDiscountCode;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_ordersdiscount_codes');
__PACKAGE__->add_columns(
	'order_id', { data_type => 'INT', is_nullable => 0 },
	'discount_code_id', { data_type => 'INT', is_nullable => 0 }
);
__PACKAGE__->belongs_to(order => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order', 'order_id');
__PACKAGE__->belongs_to(discount_code => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::DiscountCode', 'discount_code_id');

1;