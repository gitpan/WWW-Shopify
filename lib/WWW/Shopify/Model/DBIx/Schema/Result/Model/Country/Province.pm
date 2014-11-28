
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Country::Province;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_countries_provinces');
__PACKAGE__->add_columns(
	"country_id", { data_type => 'bigint' },
	"tax_name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"tax", { data_type => 'FLOAT', is_nullable => '1' },
	"code", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"tax_type", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"tax_percentage", { is_nullable => '1', data_type => 'FLOAT' }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::Country::Province'; }
sub parent_variable { return 'country_id'; }

1;