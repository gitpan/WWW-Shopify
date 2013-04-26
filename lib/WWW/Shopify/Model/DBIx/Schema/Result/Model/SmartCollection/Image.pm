
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::SmartCollection::Image;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_smart_collections_images');
__PACKAGE__->add_columns(
	"smart_collection_id", { data_type => 'INT' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"src", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'INT' }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::SmartCollection::Image'; }
sub parent_variable { return 'smart_collection_id'; }

1;