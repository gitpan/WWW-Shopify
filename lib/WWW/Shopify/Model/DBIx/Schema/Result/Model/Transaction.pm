
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Transaction;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_orders_transactions');
__PACKAGE__->add_columns(
	"gateway", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"status", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"authorization", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"amount", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"kind", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"order_id", { data_type => 'BIGINT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(order => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order', 'order_id');
__PACKAGE__->has_many(receipt => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Transaction::Receipt', 'transaction_id');
sub represents { return 'WWW::Shopify::Model::Transaction'; }
sub parent_variable { return 'order_id'; }

1;