
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
	"condition", { is_nullable => '0', data_type => 'VARCHAR(255)' },
	"column", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"relation", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"id", { data_type => 'BIGINT', is_nullable => 0, is_auto_increment => 1 }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::SmartCollection::Rule'; }
sub parent_variable { return 'smart_collection_id'; }

1;