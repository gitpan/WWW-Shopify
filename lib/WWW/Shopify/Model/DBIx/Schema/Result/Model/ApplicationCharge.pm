
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::ApplicationCharge;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_application_charges');
__PACKAGE__->add_columns(
	"test", { data_type => 'BOOL', is_nullable => '1' },
	"status", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"cancelled_on", { data_type => 'DATETIME', is_nullable => '1' },
	"return_url", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"confirmation_url", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"price", { data_type => 'DECIMAL', is_nullable => '1' },
	"activated_on", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'INT', is_nullable => '0' },
	"billing_on", { data_type => 'DATETIME', is_nullable => '1' },
	"shop_id", { data_type => "INT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::ApplicationCharge'; }
sub parent_variable { return undef; }

1;