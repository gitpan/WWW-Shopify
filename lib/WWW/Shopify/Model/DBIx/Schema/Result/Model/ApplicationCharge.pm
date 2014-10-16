
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::ApplicationCharge;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_application_charges');
__PACKAGE__->add_columns(
	"test", { is_nullable => '1', data_type => 'BOOL' },
	"status", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"billing_on", { data_type => 'DATETIME', is_nullable => '1' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"return_url", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"price", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"confirmation_url", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"cancelled_on", { data_type => 'DATETIME', is_nullable => '1' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"name", { is_nullable => '1', data_type => 'TEXT' },
	"activated_on", { data_type => 'TEXT', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::ApplicationCharge'; }
sub parent_variable { return undef; }

1;