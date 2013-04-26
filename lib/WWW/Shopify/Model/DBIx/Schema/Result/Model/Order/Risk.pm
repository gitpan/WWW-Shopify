
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Risk;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_orders_risks');
__PACKAGE__->add_columns(
	"source", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"order_id", { data_type => 'DECIMAL', is_nullable => '1' },
	"score", { data_type => 'FLOAT', is_nullable => '1' },
	"recommendation", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"cause_cancel", { data_type => 'BOOL', is_nullable => '1' },
	"display", { data_type => 'BOOL', is_nullable => '1' },
	"message", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'INT' },
	"shop_id", { data_type => "INT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::Order::Risk'; }
sub parent_variable { return 'order_id'; }

1;