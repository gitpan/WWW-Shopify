
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Fulfillment;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_orders_fulfillments');
__PACKAGE__->add_columns(
	"tracking_number", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"tracking_company", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"service", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"notify_customer", { is_nullable => '1', data_type => 'BOOL' },
	"updated_at", { is_nullable => '1', data_type => 'DATETIME' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"status", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"order_id", { data_type => 'BIGINT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(order => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order', 'order_id');
__PACKAGE__->has_many(line_items => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Fulfillment::LineItem', 'fulfillment_id');
__PACKAGE__->has_one(receipt => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Fulfillment::Receipt', 'fulfillment_id');
sub represents { return 'WWW::Shopify::Model::Order::Fulfillment'; }
sub parent_variable { return 'order_id'; }

1;