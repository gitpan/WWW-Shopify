
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Cart::LineItem;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_carts_line_items');
__PACKAGE__->add_columns(
	"cart_id", { data_type => 'bigint' },
	"title", { is_nullable => '1', data_type => 'TEXT' },
	"vendor", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"sku", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"quantity", { is_nullable => '1', data_type => 'INT' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"grams", { data_type => 'INT', is_nullable => '1' },
	"price", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"line_price", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"variant_id", { is_nullable => '1', data_type => 'BIGINT' }
);
__PACKAGE__->set_primary_key('id');





__PACKAGE__->belongs_to(variant => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Variant', 'variant_id');
sub represents { return 'WWW::Shopify::Model::Cart::LineItem'; }
sub parent_variable { return 'cart_id'; }

1;