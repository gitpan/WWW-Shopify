
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::MetafieldShop;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_metafieldsshops');
__PACKAGE__->add_columns(
	'shop_id', { data_type => 'INT', is_nullable => 0 },
	'metafield_id', { data_type => 'INT', is_nullable => 0 }
);
__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');
__PACKAGE__->belongs_to(metafield => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Metafield', 'metafield_id');

1;