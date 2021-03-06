
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::ShippingLine::TaxLine;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_shipping_lines_tax_lines');
__PACKAGE__->add_columns(
	"shipping_line_id", { data_type => 'bigint' },
	"price", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"rate", { is_nullable => '1', data_type => 'FLOAT' },
	"title", { data_type => 'TEXT', is_nullable => '0' },
	"id", { data_type => 'BIGINT', is_nullable => 0, is_auto_increment => 1 }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::Order::ShippingLine::TaxLine'; }
sub parent_variable { return 'shipping_line_id'; }

1;