
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::RecurringApplicationCharge;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_recurring_application_charges');
__PACKAGE__->add_columns(
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"cancelled_on", { is_nullable => '1', data_type => 'DATETIME' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"confirmation_url", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"price", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"activated_on", { is_nullable => '1', data_type => 'TEXT' },
	"name", { is_nullable => '1', data_type => 'TEXT' },
	"status", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"test", { is_nullable => '1', data_type => 'BOOL' },
	"trial_ends_on", { is_nullable => '1', data_type => 'DATETIME' },
	"trial_days", { data_type => 'INT', is_nullable => '1' },
	"return_url", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"billing_on", { is_nullable => '1', data_type => 'DATETIME' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::RecurringApplicationCharge'; }
sub parent_variable { return undef; }

1;