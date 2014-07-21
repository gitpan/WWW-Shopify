
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Checkout::ShippingLine;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_checkouts_shipping_lines');
__PACKAGE__->add_columns(
	"checkout_id", { data_type => 'bigint' },
	"rate", { data_type => 'FLOAT', is_nullable => '1' },
	"title", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"price", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"id", { data_type => 'BIGINT', is_nullable => 0, is_auto_increment => 1 }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::Checkout::ShippingLine'; }
sub parent_variable { return 'checkout_id'; }

1;