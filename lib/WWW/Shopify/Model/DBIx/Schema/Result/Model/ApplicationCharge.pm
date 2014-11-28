
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::ApplicationCharge;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_application_charges');
__PACKAGE__->add_columns(
	"billing_on", { data_type => 'DATETIME', is_nullable => '1' },
	"status", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"return_url", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"name", { is_nullable => '1', data_type => 'TEXT' },
	"price", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"activated_on", { is_nullable => '1', data_type => 'TEXT' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"updated_at", { is_nullable => '1', data_type => 'DATETIME' },
	"test", { is_nullable => '1', data_type => 'BOOL' },
	"confirmation_url", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"cancelled_on", { is_nullable => '1', data_type => 'DATETIME' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::ApplicationCharge'; }
sub parent_variable { return undef; }

1;