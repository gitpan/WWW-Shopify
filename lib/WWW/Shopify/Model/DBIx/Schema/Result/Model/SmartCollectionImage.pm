
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::SmartCollectionImage;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_smart_collectionsimages');
__PACKAGE__->add_columns(
	'smart_collection_id', { data_type => 'INT', is_nullable => 0 },
	'image_id', { data_type => 'INT', is_nullable => 0 }
);
__PACKAGE__->belongs_to(smart_collection => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::SmartCollection', 'smart_collection_id');
__PACKAGE__->belongs_to(image => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::SmartCollection::Image', 'image_id');

1;