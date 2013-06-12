
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::ShippingLine;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_orders_shipping_lines');
__PACKAGE__->add_columns(
	"order_id", { data_type => 'bigint' },
	"source", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"title", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"price", { data_type => 'DECIMAL', is_nullable => '1' },
	"code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'INT' }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::Order::ShippingLine'; }
sub parent_variable { return 'order_id'; }

1;