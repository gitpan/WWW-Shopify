
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::OrderShippingLine;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_ordersshipping_lines');
__PACKAGE__->add_columns(
	'order_id', { data_type => 'INT', is_nullable => 0 },
	'shipping_line_id', { data_type => 'INT', is_nullable => 0 }
);
__PACKAGE__->belongs_to(order => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order', 'order_id');
__PACKAGE__->belongs_to(shipping_line => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::ShippingLine', 'shipping_line_id');

1;