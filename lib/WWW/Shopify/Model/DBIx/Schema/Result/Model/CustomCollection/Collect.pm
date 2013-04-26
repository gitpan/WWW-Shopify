
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomCollection::Collect;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_custom_collections_collects');
__PACKAGE__->add_columns(
	"custom_collection_id", { data_type => 'INT' },
	"position", { data_type => 'INT', is_nullable => '1' },
	"id", { data_type => 'INT' },
	"product_id", { data_type => 'INT', is_nullable => '1' }
);
__PACKAGE__->set_primary_key('id');





__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id');
sub represents { return 'WWW::Shopify::Model::CustomCollection::Collect'; }
sub parent_variable { return 'custom_collection_id'; }

1;