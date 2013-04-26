
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::LineItemProperty;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_line_itemsproperties');
__PACKAGE__->add_columns(
	'line_item_id', { data_type => 'INT', is_nullable => 0 },
	'property_id', { data_type => 'INT', is_nullable => 0 }
);
__PACKAGE__->belongs_to(line_item => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem', 'line_item_id');
__PACKAGE__->belongs_to(property => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem::Property', 'property_id');

1;