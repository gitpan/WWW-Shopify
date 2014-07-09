
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Risk;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_orders_risks');
__PACKAGE__->add_columns(
	"recommendation", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"score", { is_nullable => '1', data_type => 'FLOAT' },
	"order_id", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"message", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"source", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"cause_cancel", { data_type => 'BOOL', is_nullable => '1' },
	"display", { data_type => 'BOOL', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => 0, is_auto_increment => 1 },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::Order::Risk'; }
sub parent_variable { return 'order_id'; }

1;