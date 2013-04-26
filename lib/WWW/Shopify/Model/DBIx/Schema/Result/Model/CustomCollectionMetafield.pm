
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomCollectionMetafield;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_custom_collectionsmetafields');
__PACKAGE__->add_columns(
	'id', { data_type => 'INT', is_nullable => 0, is_auto_increment => 1 },
	'custom_collection_id', { data_type => 'INT', is_nullable => 0 },
	'metafield_id', { data_type => 'INT', is_nullable => 0 }
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(custom_collection => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomCollection', 'custom_collection_id');
__PACKAGE__->belongs_to(metafield => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Metafield', 'metafield_id');

1;