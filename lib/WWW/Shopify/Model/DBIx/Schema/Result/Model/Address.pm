
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Address;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_addresses');
__PACKAGE__->add_columns(
	"city", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"province_code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"address1", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"latitude", { is_nullable => '1', data_type => 'FLOAT' },
	"zip", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"first_name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"country", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"longitude", { data_type => 'FLOAT', is_nullable => '1' },
	"phone", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"province", { data_type => 'TEXT', is_nullable => '1' },
	"country_code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"last_name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"name", { is_nullable => '1', data_type => 'TEXT' },
	"company", { data_type => 'TEXT', is_nullable => '1' },
	"address2", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::Address'; }
sub parent_variable { return undef; }

1;