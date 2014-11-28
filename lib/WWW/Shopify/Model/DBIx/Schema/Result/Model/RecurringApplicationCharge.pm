
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::RecurringApplicationCharge;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_recurring_application_charges');
__PACKAGE__->add_columns(
	"return_url", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"status", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"billing_on", { is_nullable => '1', data_type => 'DATETIME' },
	"trial_ends_on", { is_nullable => '1', data_type => 'DATETIME' },
	"activated_on", { data_type => 'TEXT', is_nullable => '1' },
	"name", { data_type => 'TEXT', is_nullable => '1' },
	"price", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"updated_at", { is_nullable => '1', data_type => 'DATETIME' },
	"confirmation_url", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"test", { is_nullable => '1', data_type => 'BOOL' },
	"cancelled_on", { is_nullable => '1', data_type => 'DATETIME' },
	"trial_days", { is_nullable => '1', data_type => 'INT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::RecurringApplicationCharge'; }
sub parent_variable { return undef; }

1;