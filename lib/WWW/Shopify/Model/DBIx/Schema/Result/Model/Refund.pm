
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Refund;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_orders_refunds');
__PACKAGE__->add_columns(
	"order_id", { data_type => 'bigint' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"restock", { is_nullable => '1', data_type => 'BOOL' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"note", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"user_id", { is_nullable => '1', data_type => 'BIGINT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(user => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::User', 'user_id');
__PACKAGE__->has_many(refund_line_items => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Refund::LineItem', 'refund_id');
__PACKAGE__->has_many(transactions_hasmany => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::RefundTransaction', 'refund_id');
__PACKAGE__->many_to_many(transactions => 'transactions_hasmany', 'transaction');
sub represents { return 'WWW::Shopify::Model::Refund'; }
sub parent_variable { return 'order_id'; }

1;