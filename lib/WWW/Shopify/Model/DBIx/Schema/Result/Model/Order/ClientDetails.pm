
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::ClientDetails;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_orders_client_details');
__PACKAGE__->add_columns(
	"order_id", { data_type => 'bigint' },
	"session_hash", { is_nullable => '0', data_type => 'VARCHAR(255)' },
	"accept_language", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"user_agent", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"browser_ip", { is_nullable => '0', data_type => 'VARCHAR(255)' },
	"id", { data_type => 'BIGINT', is_nullable => 0, is_auto_increment => 1 }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::Order::ClientDetails'; }
sub parent_variable { return 'order_id'; }

1;