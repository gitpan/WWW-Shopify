
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Location;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_locations');
__PACKAGE__->add_columns(
	"country", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"address2", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"city", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"address1", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"phone", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"location_type", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"updated_at", { is_nullable => '1', data_type => 'DATETIME' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"zip", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"province", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::Location'; }
sub parent_variable { return undef; }

1;