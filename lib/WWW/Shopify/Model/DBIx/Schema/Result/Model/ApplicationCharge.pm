
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::ApplicationCharge;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_application_charges');
__PACKAGE__->add_columns(
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"confirmation_url", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"activated_on", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"price", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"cancelled_on", { is_nullable => '1', data_type => 'DATETIME' },
	"billing_on", { data_type => 'DATETIME', is_nullable => '1' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"test", { data_type => 'BOOL', is_nullable => '1' },
	"status", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"return_url", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::ApplicationCharge'; }
sub parent_variable { return undef; }

1;