
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::CarrierService;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_carrier_services');
__PACKAGE__->add_columns(
	"name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"carrier_service_type", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"service_discovery", { data_type => 'BOOL', is_nullable => '1' },
	"format", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"active", { data_type => 'BOOL', is_nullable => '1' },
	"callback_url", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::CarrierService'; }
sub parent_variable { return undef; }

1;