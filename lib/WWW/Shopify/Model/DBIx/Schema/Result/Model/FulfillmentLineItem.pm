
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::FulfillmentLineItem;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_fulfillmentsline_items');
__PACKAGE__->add_columns(
	'id', { data_type => 'INT', is_nullable => '0', is_auto_increment => 1 },
	'fulfillment_id', { data_type => 'bigint', is_nullable => 0 },
	'line_item_id', { data_type => 'bigint', is_nullable => 0 }
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(fulfillment => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Fulfillment', 'fulfillment_id');
__PACKAGE__->belongs_to(line_item => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem', 'line_item_id');

1;