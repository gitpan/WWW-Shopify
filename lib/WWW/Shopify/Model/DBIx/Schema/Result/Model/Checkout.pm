
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Checkout;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_checkouts');
__PACKAGE__->add_columns(
	"cart_token", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"buyer_accepts_marketing", { data_type => 'BOOL', is_nullable => '1' },
	"email", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"id", { data_type => 'INT', is_nullable => '1' },
	"token", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"billing_address_id", { data_type => 'INT', is_nullable => '1' },
	"customer_id", { data_type => 'INT', is_nullable => '1' },
	"shipping_address_id", { data_type => 'INT', is_nullable => '1' },
	"shop_id", { data_type => "INT" }
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(billing_address => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Address', 'billing_address_id');
__PACKAGE__->belongs_to(customer => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Customer', 'customer_id');
__PACKAGE__->belongs_to(shipping_address => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Address', 'shipping_address_id');
sub represents { return 'WWW::Shopify::Model::Checkout'; }
sub parent_variable { return undef; }

1;