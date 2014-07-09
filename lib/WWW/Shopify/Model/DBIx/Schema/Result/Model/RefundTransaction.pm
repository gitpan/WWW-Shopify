
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::RefundTransaction;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_refundstransactions');
__PACKAGE__->add_columns(
	'id', { data_type => 'INT', is_nullable => '0', is_auto_increment => 1 },
	'refund_id', { data_type => 'bigint', is_nullable => 0 },
	'transaction_id', { data_type => 'bigint', is_nullable => 0 }
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(refund => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Refund', 'refund_id');
__PACKAGE__->belongs_to(transaction => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Transaction', 'transaction_id');

1;