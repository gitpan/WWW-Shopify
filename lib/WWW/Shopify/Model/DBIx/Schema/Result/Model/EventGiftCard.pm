
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::EventGiftCard;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_eventsgift_cards');
__PACKAGE__->add_columns(
	'id', { data_type => 'INT', is_nullable => '0', is_auto_increment => 1 },
	'gift_card_id', { data_type => 'bigint', is_nullable => 0 },
	'event_id', { data_type => 'bigint', is_nullable => 0 }
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(gift_card => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::GiftCard', 'gift_card_id');
__PACKAGE__->belongs_to(event => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Event', 'event_id');

1;