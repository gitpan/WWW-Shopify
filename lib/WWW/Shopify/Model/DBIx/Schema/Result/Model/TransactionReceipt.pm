
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::TransactionReceipt;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_transactionsreceipts');
__PACKAGE__->add_columns(
	'transaction_id', { data_type => 'INT', is_nullable => 0 },
	'receipt_id', { data_type => 'INT', is_nullable => 0 }
);
__PACKAGE__->belongs_to(transaction => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Transaction', 'transaction_id');
__PACKAGE__->belongs_to(receipt => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Transaction::Receipt', 'receipt_id');

1;