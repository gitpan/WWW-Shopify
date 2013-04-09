
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::SmartCollection::Rule;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_smart_collections_rules');
__PACKAGE__->add_columns(
	"relation", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"condition", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"column", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"smart_collection_id", { data_type => 'INT' },
	"id", { data_type => 'INT' }
);
__PACKAGE__->set_primary_key('id');




sub represents { return 'WWW::Shopify::Model::SmartCollection::Rule'; }
sub parent_variable { return 'smart_collection_id'; }

1;