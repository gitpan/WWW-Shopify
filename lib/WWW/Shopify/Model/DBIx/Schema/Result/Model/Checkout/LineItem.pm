
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Checkout::LineItem;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_checkouts_line_items');
__PACKAGE__->add_columns(
	"checkout_id", { data_type => 'bigint' },
	"fulfillment_service", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"vendor", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"sku", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"quantity", { is_nullable => '1', data_type => 'INT' },
	"variant_title", { data_type => 'TEXT', is_nullable => '1' },
	"title", { is_nullable => '1', data_type => 'TEXT' },
	"grams", { data_type => 'INT', is_nullable => '1' },
	"price", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"taxable", { is_nullable => '1', data_type => 'BOOL' },
	"requires_shipping", { data_type => 'BOOL', is_nullable => '1' },
	"product_id", { data_type => 'BIGINT', is_nullable => '1' },
	"variant_id", { data_type => 'BIGINT', is_nullable => '1' }
);
__PACKAGE__->set_primary_key('id');





__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id');
__PACKAGE__->belongs_to(variant => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Variant', 'variant_id');
__PACKAGE__->has_many(properties => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem::Property', 'line_item_id');
sub represents { return 'WWW::Shopify::Model::Checkout::LineItem'; }
sub parent_variable { return 'checkout_id'; }

1;