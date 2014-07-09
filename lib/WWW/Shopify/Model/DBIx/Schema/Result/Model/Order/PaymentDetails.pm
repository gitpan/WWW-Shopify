
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::PaymentDetails;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_orders_payment_details');
__PACKAGE__->add_columns(
	"order_id", { data_type => 'bigint' },
	"cvv_result_code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"avs_result_code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"credit_card_company", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"credit_card_bin", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"credit_card_number", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => 0, is_auto_increment => 1 }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::Order::PaymentDetails'; }
sub parent_variable { return 'order_id'; }

1;