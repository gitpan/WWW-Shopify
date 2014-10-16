
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Country;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_countries');
__PACKAGE__->add_columns(
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"tax", { data_type => 'FLOAT', is_nullable => '1' },
	"code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->has_many(provinces => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Country::Province', 'country_id');
sub represents { return 'WWW::Shopify::Model::Country'; }
sub parent_variable { return undef; }

1;