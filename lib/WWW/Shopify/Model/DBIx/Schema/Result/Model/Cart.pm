
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Cart;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_carts');
__PACKAGE__->add_columns(
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"id", { data_type => 'INT', is_nullable => '1' },
	"token", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"note", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"shop_id", { data_type => "INT" }
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->has_many(line_items => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Cart::LineItem', 'cart_id');
sub represents { return 'WWW::Shopify::Model::Cart'; }
sub parent_variable { return undef; }

1;