
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Transaction::Receipt;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_transactions_receipts');
__PACKAGE__->add_columns(
	"avs_result", { is_nullable => '0', data_type => 'VARCHAR(255)' },
	"currency", { is_nullable => '0', data_type => 'VARCHAR(255)' },
	"paid", { is_nullable => '0', data_type => 'BOOL' },
	"failure_message", { data_type => 'TEXT', is_nullable => '0' },
	"build", { is_nullable => '0', data_type => 'INT' },
	"refunded", { data_type => 'TEXT', is_nullable => '0' },
	"success", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"invoice", { is_nullable => '0', data_type => 'TEXT' },
	"authorization", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"order_number", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"cardholder_authorization_code", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"correlation_id", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"ack", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"recurring", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"front_end", { data_type => 'INT', is_nullable => '0' },
	"payment_details", { is_nullable => '0', data_type => 'TEXT' },
	"object", { is_nullable => '0', data_type => 'VARCHAR(255)' },
	"shipping", { data_type => 'TEXT', is_nullable => '0' },
	"avs_result_code", { is_nullable => '0', data_type => 'VARCHAR(255)' },
	"customer", { data_type => 'TEXT', is_nullable => '0' },
	"amount_refunded", { data_type => 'INT', is_nullable => '0' },
	"livemode", { data_type => 'BOOL', is_nullable => '0' },
	"avs_end", { is_nullable => '0', data_type => 'VARCHAR(255)' },
	"amount", { data_type => 'DECIMAL(10,2)', is_nullable => '0' },
	"response_reason_code", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"cvv2_code", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"metadata", { is_nullable => '0', data_type => 'TEXT' },
	"receipt_number", { data_type => 'TEXT', is_nullable => '0' },
	"balance_transaction", { data_type => 'TEXT', is_nullable => '0' },
	"version", { data_type => 'INT', is_nullable => '0' },
	"avs_code", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"created", { data_type => 'INT', is_nullable => '0' },
	"description", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"captured", { is_nullable => '0', data_type => 'BOOL' },
	"code", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"message", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"reference", { is_nullable => '0', data_type => 'VARCHAR(255)' },
	"timestamp", { is_nullable => '0', data_type => 'DATETIME' },
	"card_code", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"risk", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"dispute", { data_type => 'TEXT', is_nullable => '0' },
	"amount_currency", { is_nullable => '0', data_type => 'VARCHAR(255)' },
	"testcase", { is_nullable => '0', data_type => 'BOOL' },
	"failure_code", { data_type => 'TEXT', is_nullable => '0' },
	"refunds", { is_nullable => '0', data_type => 'TEXT' },
	"transaction_id", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"card", { data_type => 'TEXT', is_nullable => '0' },
	"action", { is_nullable => '0', data_type => 'VARCHAR(255)' },
	"statement_description", { data_type => 'TEXT', is_nullable => '0' },
	"fraud_details", { data_type => 'TEXT', is_nullable => '0' },
	"response_code", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"receipt_email", { data_type => 'TEXT', is_nullable => '0' },
	"authorization_code", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"id", { data_type => 'BIGINT', is_nullable => 0, is_auto_increment => 1 }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::Transaction::Receipt'; }
sub parent_variable { return 'transaction_id'; }

1;