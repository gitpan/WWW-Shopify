
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
	"quantity", { is_nullable => '1', data_type => 'INT' },
	"grams", { is_nullable => '1', data_type => 'INT' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"vendor", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"requires_shipping", { data_type => 'BOOL', is_nullable => '1' },
	"title", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"taxable", { data_type => 'BOOL', is_nullable => '1' },
	"price", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"variant_title", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"sku", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"fulfillment_service", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"variant_id", { data_type => 'BIGINT', is_nullable => '1' },
	"product_id", { is_nullable => '1', data_type => 'BIGINT' }
);
__PACKAGE__->set_primary_key('id');





__PACKAGE__->belongs_to(variant => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Variant', 'variant_id');
__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id');
__PACKAGE__->has_many(properties => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem::Property', 'line_item_id');
sub represents { return 'WWW::Shopify::Model::Checkout::LineItem'; }
sub parent_variable { return 'checkout_id'; }

1;