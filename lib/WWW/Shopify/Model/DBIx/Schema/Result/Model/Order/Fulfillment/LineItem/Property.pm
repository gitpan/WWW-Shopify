
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Fulfillment::LineItem::Property;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_line_items_properties');
__PACKAGE__->add_columns(
	"line_item_id", { data_type => 'bigint' },
	"name", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"value", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"id", { data_type => 'BIGINT', is_nullable => 0, is_auto_increment => 1 }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::Order::Fulfillment::LineItem::Property'; }
sub parent_variable { return 'line_item_id'; }

1;