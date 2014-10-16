
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
	"code", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"tax", { is_nullable => '1', data_type => 'FLOAT' },
	"tax_type", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"tax_percentage", { is_nullable => '1', data_type => 'FLOAT' },
	"tax_name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { is_nullable => '0', data_type => 'BIGINT' }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::Country::Province'; }
sub parent_variable { return 'country_id'; }

1;