
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Customer;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_customers');
__PACKAGE__->add_columns(
	"password_confirmation", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"accepts_marketing", { data_type => 'BOOL', is_nullable => '1' },
	"multipass_identifier", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"first_name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"email", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"total_spent", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"orders_count", { is_nullable => '1', data_type => 'INT' },
	"password", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"image_url", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"state", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"note", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"last_name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"verified_email", { is_nullable => '1', data_type => 'BOOL' },
	"send_email_invite", { is_nullable => '1', data_type => 'BOOL' },
	"tags", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"last_order_name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"default_address_id", { data_type => 'BIGINT', is_nullable => '1' },
	"last_order_id", { data_type => 'BIGINT', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->add_unique_constraint(constraint_name => [ "email" ]);

__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(default_address => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Address', 'default_address_id');
__PACKAGE__->belongs_to(last_order => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order', 'last_order_id');
__PACKAGE__->has_many(metafields_hasmany => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomerMetafield', 'customer_id');
__PACKAGE__->many_to_many(metafields => 'metafields_hasmany', 'metafield');
__PACKAGE__->has_many(addresses_hasmany => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::AddressCustomer', 'customer_id');
__PACKAGE__->many_to_many(addresses => 'addresses_hasmany', 'address');
sub represents { return 'WWW::Shopify::Model::Customer'; }
sub parent_variable { return undef; }

1;