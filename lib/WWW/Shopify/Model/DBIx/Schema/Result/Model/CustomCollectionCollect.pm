
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomCollectionCollect;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_custom_collectionscollects');
__PACKAGE__->add_columns(
	'id', { data_type => 'INT', is_nullable => '0', is_auto_increment => 1 },
	'custom_collection_id', { data_type => 'bigint', is_nullable => 0 },
	'collect_id', { data_type => 'bigint', is_nullable => 0 }
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(custom_collection => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomCollection', 'custom_collection_id');
__PACKAGE__->belongs_to(collect => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomCollection::Collect', 'collect_id');

1;