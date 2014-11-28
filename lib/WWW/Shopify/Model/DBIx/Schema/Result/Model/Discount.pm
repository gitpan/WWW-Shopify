
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Discount;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_discounts');
__PACKAGE__->add_columns(
	"ends_at", { data_type => 'DATETIME', is_nullable => '1' },
	"status", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"times_used", { is_nullable => '1', data_type => 'INT' },
	"minimum_order_amount", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"value", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"code", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"discount_type", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"usage_limit", { is_nullable => '1', data_type => 'INT' },
	"applies_to_resource", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"applies_once", { is_nullable => '1', data_type => 'BOOL' },
	"starts_at", { is_nullable => '1', data_type => 'DATETIME' },
	"applies_to_id", { is_nullable => '1', data_type => 'BIGINT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(applies_to => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'applies_to_id', { join_type => 'left' });
sub represents { return 'WWW::Shopify::Model::Discount'; }
sub parent_variable { return undef; }

1;