
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::MetafieldImage;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_metafieldsimages');
__PACKAGE__->add_columns(
	'id', { data_type => 'INT', is_nullable => '0', is_auto_increment => 1 },
	'image_id', { data_type => 'bigint', is_nullable => 0 },
	'metafield_id', { data_type => 'bigint', is_nullable => 0 }
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(image => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Image', 'image_id');
__PACKAGE__->belongs_to(metafield => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Metafield', 'metafield_id');

1;