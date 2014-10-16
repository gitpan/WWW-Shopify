
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::ShippingAddress;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_addresses');
__PACKAGE__->add_columns(
	"city", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"province_code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"address1", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"latitude", { is_nullable => '1', data_type => 'FLOAT' },
	"zip", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"first_name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"country", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"longitude", { is_nullable => '1', data_type => 'FLOAT' },
	"phone", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"province", { data_type => 'TEXT', is_nullable => '1' },
	"country_code", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"last_name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"name", { is_nullable => '1', data_type => 'TEXT' },
	"company", { data_type => 'TEXT', is_nullable => '1' },
	"address2", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::Order::ShippingAddress'; }
sub parent_variable { return undef; }

1;