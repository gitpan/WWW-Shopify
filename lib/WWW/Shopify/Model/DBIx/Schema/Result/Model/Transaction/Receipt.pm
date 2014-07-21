
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Transaction::Receipt;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_transactions_receipts');
__PACKAGE__->add_columns(
	"authorization", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"message", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"avs_code", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"amount", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"build", { data_type => 'INT', is_nullable => '1' },
	"code", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"action", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"payment_details", { data_type => 'TEXT', is_nullable => '1' },
	"authorization_code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"front_end", { is_nullable => '1', data_type => 'INT' },
	"card_code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"ack", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"avs_result_code", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"cvv2_code", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"testcase", { is_nullable => '1', data_type => 'BOOL' },
	"avs_result", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"recurring", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"risk", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"transaction_id", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"correlation_id", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"amount_currency", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"avs_end", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"version", { is_nullable => '1', data_type => 'INT' },
	"response_reason_code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"timestamp", { data_type => 'DATETIME', is_nullable => '1' },
	"response_code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"order_number", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"cardholder_authorization_code", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"reference", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"success", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => 0, is_auto_increment => 1 }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::Transaction::Receipt'; }
sub parent_variable { return 'transaction_id'; }

1;