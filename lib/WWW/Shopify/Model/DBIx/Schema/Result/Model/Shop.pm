
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_shops');
__PACKAGE__->add_columns(
	"source", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"taxes_included", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"money_format", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"tax_shipping", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"currency", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"email", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"city", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"domain", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"myshopify_domain", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"public", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"shop_owner", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"province", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'INT', is_nullable => '0' },
	"country", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"customer_email", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"timezone", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"phone", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"money_with_currency_format", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"zip", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"plan_name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"address1", { data_type => 'VARCHAR(255)', is_nullable => '1' }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->has_many(blogs => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Blog', 'shop_id');
__PACKAGE__->has_many(application_charges => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::ApplicationCharge', 'shop_id');
__PACKAGE__->has_many(webhooks => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Webhook', 'shop_id');
__PACKAGE__->has_many(product_search_engines => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::ProductSearchEngine', 'shop_id');
__PACKAGE__->has_many(redirects => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Redirect', 'shop_id');
__PACKAGE__->has_many(customer_groups => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomerGroup', 'shop_id');
__PACKAGE__->has_many(pages => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Page', 'shop_id');
__PACKAGE__->has_many(discounts => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Discount', 'shop_id');
__PACKAGE__->has_many(themes => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Theme', 'shop_id');
__PACKAGE__->has_many(customers => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Customer', 'shop_id');
__PACKAGE__->has_many(custom_collections => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomCollection', 'shop_id');
__PACKAGE__->has_many(products => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'shop_id');
__PACKAGE__->has_many(carts => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Cart', 'shop_id');
__PACKAGE__->has_many(assets => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Asset', 'shop_id');
__PACKAGE__->has_many(orders => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order', 'shop_id');
__PACKAGE__->has_many(smart_collections => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::SmartCollection', 'shop_id');
__PACKAGE__->has_many(addresses => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Address', 'shop_id');
__PACKAGE__->has_many(script_tags => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::ScriptTag', 'shop_id');
__PACKAGE__->has_many(recurring_application_charges => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::RecurringApplicationCharge', 'shop_id');
__PACKAGE__->has_many(articles => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Article', 'shop_id');
__PACKAGE__->has_many(transactions => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Transaction', 'shop_id');
__PACKAGE__->has_many(checkouts => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Checkout', 'shop_id');
__PACKAGE__->has_many(risks => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Risk', 'shop_id');
__PACKAGE__->has_many(variants => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Variant', 'shop_id');

__PACKAGE__->has_many(metafields_hasmany => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::MetafieldShop', 'shop_id');
__PACKAGE__->many_to_many(metafields => 'metafields_hasmany', 'metafield');
sub represents { return 'WWW::Shopify::Model::Shop'; }
sub parent_variable { return undef; }

1;