
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::BillingAddress;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_addresses');
__PACKAGE__->add_columns(
	"province", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"city", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"country_code", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"latitude", { data_type => 'FLOAT', is_nullable => '1' },
	"zip", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"country", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"company", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"address2", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"last_name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"longitude", { data_type => 'FLOAT', is_nullable => '1' },
	"name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"phone", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"province_code", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"first_name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"address1", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::Order::BillingAddress'; }
sub parent_variable { return undef; }

1;