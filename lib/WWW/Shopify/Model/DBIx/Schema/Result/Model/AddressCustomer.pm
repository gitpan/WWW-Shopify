
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::AddressCustomer;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_addressescustomers');
__PACKAGE__->add_columns(
	'id', { data_type => 'INT', is_nullable => 0, is_auto_increment => 1 },
	'customer_id', { data_type => 'INT', is_nullable => 0 },
	'address_id', { data_type => 'INT', is_nullable => 0 }
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(customer => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Customer', 'customer_id');
__PACKAGE__->belongs_to(address => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Address', 'address_id');

1;