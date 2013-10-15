
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::FulfillmentService;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_fulfillment_services');
__PACKAGE__->add_columns(
	"inventory_management", { data_type => 'BOOL', is_nullable => '1' },
	"credential1", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"callback_url", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"provider_id", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"requires_shipping_method", { data_type => 'BOOL', is_nullable => '1' },
	"email", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"include_pending_stock", { data_type => 'BOOL', is_nullable => '1' },
	"service_name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"tracking_support", { data_type => 'BOOL', is_nullable => '1' },
	"format", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"credential2_exists", { data_type => 'BOOL', is_nullable => '1' },
	"handle", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::FulfillmentService'; }
sub parent_variable { return undef; }

1;