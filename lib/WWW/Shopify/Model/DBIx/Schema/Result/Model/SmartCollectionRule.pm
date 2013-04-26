
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::SmartCollectionRule;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_smart_collectionsrules');
__PACKAGE__->add_columns(
	'smart_collection_id', { data_type => 'INT', is_nullable => 0 },
	'rule_id', { data_type => 'INT', is_nullable => 0 }
);
__PACKAGE__->belongs_to(smart_collection => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::SmartCollection', 'smart_collection_id');
__PACKAGE__->belongs_to(rule => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::SmartCollection::Rule', 'rule_id');

1;