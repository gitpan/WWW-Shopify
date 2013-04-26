
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::PaymentDetails;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_orders_payment_details');
__PACKAGE__->add_columns(
	"order_id", { data_type => 'INT' },
	"credit_card_company", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"credit_card_numer", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"avs_result_code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"credit_card_bin", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"cvv_result_code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'INT' }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::Order::PaymentDetails'; }
sub parent_variable { return 'order_id'; }

1;