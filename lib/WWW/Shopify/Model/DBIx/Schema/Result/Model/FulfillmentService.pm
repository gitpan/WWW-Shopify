
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::FulfillmentService;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_fulfillment_services');
__PACKAGE__->add_columns(
	"credential2_exists", { data_type => 'BOOL', is_nullable => '1' },
	"format", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"include_pending_stock", { is_nullable => '1', data_type => 'BOOL' },
	"service_name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"email", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"callback_url", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"credential1", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"tracking_support", { data_type => 'BOOL', is_nullable => '1' },
	"provider_id", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"handle", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"inventory_management", { is_nullable => '1', data_type => 'BOOL' },
	"requires_shipping_method", { is_nullable => '1', data_type => 'BOOL' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::FulfillmentService'; }
sub parent_variable { return undef; }

1;