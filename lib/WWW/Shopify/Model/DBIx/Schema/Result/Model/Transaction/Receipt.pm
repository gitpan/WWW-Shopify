
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Transaction::Receipt;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_transactions_receipts');
__PACKAGE__->add_columns(
	"testcase", { is_nullable => '1', data_type => 'BOOL' },
	"code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"authorization_code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"transaction_id", { is_nullable => '0', data_type => 'VARCHAR(255)' },
	"action", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"cardholder_authorization_code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"avs_result_code", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"correlation_id", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"amount_currency", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"success", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"response_code", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"front_end", { data_type => 'INT', is_nullable => '1' },
	"recurring", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"timestamp", { is_nullable => '1', data_type => 'DATETIME' },
	"authorization", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"version", { is_nullable => '1', data_type => 'INT' },
	"message", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"cvv2_code", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"order_number", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"payment_details", { data_type => 'TEXT', is_nullable => '1' },
	"card_code", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"build", { data_type => 'INT', is_nullable => '1' },
	"avs_code", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"risk", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"avs_end", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"response_reason_code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"ack", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"reference", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"avs_result", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"amount", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"id", { data_type => 'BIGINT', is_nullable => 0, is_auto_increment => 1 }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::Transaction::Receipt'; }
sub parent_variable { return 'transaction_id'; }

1;