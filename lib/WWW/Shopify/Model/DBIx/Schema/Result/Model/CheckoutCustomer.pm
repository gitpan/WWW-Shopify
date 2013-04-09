
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::CheckoutCustomer;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_checkoutscustomers');
__PACKAGE__->add_columns(
	'checkout_id', { data_type => 'INT', is_nullable => 0 },
	'customer_id', { data_type => 'INT', is_nullable => 0 }
);
__PACKAGE__->belongs_to(checkout => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Checkout', 'checkout_id');
__PACKAGE__->belongs_to(customer => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Customer', 'customer_id');

1;