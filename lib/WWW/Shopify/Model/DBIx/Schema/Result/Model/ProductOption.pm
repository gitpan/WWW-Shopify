
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::ProductOption;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_productsoptions');
__PACKAGE__->add_columns(
	'product_id', { data_type => 'INT', is_nullable => 0 },
	'option_id', { data_type => 'INT', is_nullable => 0 }
);
__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id');
__PACKAGE__->belongs_to(option => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Option', 'option_id');

1;