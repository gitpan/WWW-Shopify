
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Transaction::Receipt;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_transactions_receipts');
__PACKAGE__->add_columns(
	"recurring", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"cvv2_code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"message", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"amount", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"transaction_id", { is_nullable => '0', data_type => 'VARCHAR(255)' },
	"ack", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"version", { data_type => 'INT', is_nullable => '1' },
	"reference", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"avs_result", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"risk", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"testcase", { is_nullable => '1', data_type => 'BOOL' },
	"authorization", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"correlation_id", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"avs_end", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"code", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"build", { is_nullable => '1', data_type => 'INT' },
	"amount_currency", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"timestamp", { data_type => 'DATETIME', is_nullable => '1' },
	"front_end", { is_nullable => '1', data_type => 'INT' },
	"payment_details", { data_type => 'TEXT', is_nullable => '1' },
	"success", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"order_number", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"avs_code", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"id", { data_type => 'BIGINT', is_nullable => 0, is_auto_increment => 1 }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::Transaction::Receipt'; }
sub parent_variable { return 'transaction_id'; }

1;