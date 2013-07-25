
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::ClientDetails;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_orders_properties');
__PACKAGE__->add_columns(
	"order_id", { data_type => 'bigint' },
	"browser_ip", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"session_hash", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"user_agent", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"accept_language", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'INT', is_nullable => 0, is_auto_increment => 1 }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::Order::ClientDetails'; }
sub parent_variable { return 'order_id'; }

1;