
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::SmartCollection::Rule;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_smart_collections_rules');
__PACKAGE__->add_columns(
	"smart_collection_id", { data_type => 'bigint' },
	"relation", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"condition", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"column", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'INT', is_nullable => 0, is_auto_increment => 1 }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::SmartCollection::Rule'; }
sub parent_variable { return 'smart_collection_id'; }

1;