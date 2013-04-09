
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::OrderLineItem;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_ordersline_items');
__PACKAGE__->add_columns(
	'order_id', { data_type => 'INT', is_nullable => 0 },
	'line_item_id', { data_type => 'INT', is_nullable => 0 }
);
__PACKAGE__->belongs_to(order => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order', 'order_id');
__PACKAGE__->belongs_to(line_item => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem', 'line_item_id');

1;