
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::GiftCard;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_gift_cards');
__PACKAGE__->add_columns(
	"balance", { data_type => 'DECIMAL(10,2)', is_nullable => '1' },
	"expires_on", { data_type => 'DATETIME', is_nullable => '1' },
	"last_characters", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"disabled_at", { data_type => 'DATETIME', is_nullable => '1' },
	"code", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"initial_value", { is_nullable => '1', data_type => 'DECIMAL(10,2)' },
	"currency", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"template_suffix", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"masked_code", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"user_id", { data_type => 'INT', is_nullable => '1' },
	"api_client_id", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"note", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"line_item_id", { data_type => 'BIGINT', is_nullable => '1' },
	"customer_id", { is_nullable => '1', data_type => 'BIGINT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(line_item => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem', 'line_item_id');
__PACKAGE__->belongs_to(customer => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Customer', 'customer_id');
__PACKAGE__->has_many(shares_hasmany => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::EventGiftCard', 'gift_card_id');
__PACKAGE__->many_to_many(shares => 'shares_hasmany', 'event');
__PACKAGE__->has_many(events_hasmany => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::EventGiftCard', 'gift_card_id');
__PACKAGE__->many_to_many(events => 'events_hasmany', 'event');
sub represents { return 'WWW::Shopify::Model::GiftCard'; }
sub parent_variable { return undef; }

1;