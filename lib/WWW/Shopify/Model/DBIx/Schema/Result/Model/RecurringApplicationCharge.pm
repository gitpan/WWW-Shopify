
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::RecurringApplicationCharge;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_recurring_application_charges');
__PACKAGE__->add_columns(
	"confirmation_url", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"price", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"trial_days", { is_nullable => '1', data_type => 'INT' },
	"name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"activated_on", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"status", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"return_url", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"trial_ends_on", { is_nullable => '1', data_type => 'DATETIME' },
	"billing_on", { is_nullable => '1', data_type => 'DATETIME' },
	"cancelled_on", { is_nullable => '1', data_type => 'DATETIME' },
	"test", { data_type => 'BOOL', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::RecurringApplicationCharge'; }
sub parent_variable { return undef; }

1;