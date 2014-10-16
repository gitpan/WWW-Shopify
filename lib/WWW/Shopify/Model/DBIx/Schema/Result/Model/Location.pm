
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Location;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_locations');
__PACKAGE__->add_columns(
	"address2", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"country", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"phone", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"zip", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"location_type", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"city", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"address1", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"province", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::Location'; }
sub parent_variable { return undef; }

1;