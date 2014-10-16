
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Cart;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_carts');
__PACKAGE__->add_columns(
	"token", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"note", { is_nullable => '1', data_type => 'TEXT' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"updated_at", { is_nullable => '1', data_type => 'DATETIME' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->has_many(line_items => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Cart::LineItem', 'cart_id');
sub represents { return 'WWW::Shopify::Model::Cart'; }
sub parent_variable { return undef; }

1;