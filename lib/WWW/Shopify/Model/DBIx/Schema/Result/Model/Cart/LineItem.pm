
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
	"sku", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"line_price", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"vendor", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"quantity", { is_nullable => '1', data_type => 'INT' },
	"price", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"title", { data_type => 'TEXT', is_nullable => '1' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"grams", { data_type => 'INT', is_nullable => '1' },
	"variant_id", { data_type => 'BIGINT', is_nullable => '1' }
);
__PACKAGE__->set_primary_key('id');





__PACKAGE__->belongs_to(variant => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Variant', 'variant_id', { join_type => 'left' });
sub represents { return 'WWW::Shopify::Model::Cart::LineItem'; }
sub parent_variable { return 'cart_id'; }

1;