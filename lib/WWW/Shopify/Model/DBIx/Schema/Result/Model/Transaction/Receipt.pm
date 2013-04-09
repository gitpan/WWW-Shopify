
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Transaction::Receipt;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_transactions_receipts');
__PACKAGE__->add_columns(
	"authorization", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"testcase", { data_type => 'BOOL', is_nullable => '1' },
	"transaction_id", { data_type => 'INT' },
	"id", { data_type => 'INT' }
);
__PACKAGE__->set_primary_key('id');




sub represents { return 'WWW::Shopify::Model::Transaction::Receipt'; }
sub parent_variable { return 'transaction_id'; }

1;