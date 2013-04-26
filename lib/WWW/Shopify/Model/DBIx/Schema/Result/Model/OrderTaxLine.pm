
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::OrderTaxLine;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_orderstax_lines');
__PACKAGE__->add_columns(
	'order_id', { data_type => 'INT', is_nullable => 0 },
	'tax_line_id', { data_type => 'INT', is_nullable => 0 }
);
__PACKAGE__->belongs_to(order => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order', 'order_id');
__PACKAGE__->belongs_to(tax_line => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::TaxLine', 'tax_line_id');

1;