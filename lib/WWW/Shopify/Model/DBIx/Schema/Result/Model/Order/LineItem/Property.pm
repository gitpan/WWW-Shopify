
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem::Property;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_line_items_properties');
__PACKAGE__->add_columns(
	"line_item_id", { data_type => 'INT' },
	"value", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'INT' }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::Order::LineItem::Property'; }
sub parent_variable { return 'line_item_id'; }

1;