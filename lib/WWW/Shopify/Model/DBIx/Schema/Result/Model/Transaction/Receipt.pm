
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Transaction::Receipt;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_transactions_receipts');
__PACKAGE__->add_columns(
	"avs_code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"authorization", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"timestamp", { data_type => 'DATETIME', is_nullable => '1' },
	"reference", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"ack", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"testcase", { data_type => 'BOOL', is_nullable => '1' },
	"code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"success", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"order_number", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"avs_end", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"recurring", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"version", { data_type => 'INT', is_nullable => '1' },
	"cvv2_code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"build", { data_type => 'INT', is_nullable => '1' },
	"correlation_id", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"message", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"amount", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"transaction_id", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"avs_result", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"amount_currency", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"front_end", { data_type => 'INT', is_nullable => '1' },
	"risk", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'INT', is_nullable => 0, is_auto_increment => 1 }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::Transaction::Receipt'; }
sub parent_variable { return 'transaction_id'; }

1;