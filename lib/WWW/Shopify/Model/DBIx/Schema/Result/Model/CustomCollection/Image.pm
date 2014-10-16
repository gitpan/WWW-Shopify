
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::CustomCollection::Image;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_custom_collections_images');
__PACKAGE__->add_columns(
	"custom_collection_id", { data_type => 'bigint' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"src", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"attachment", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"id", { data_type => 'BIGINT', is_nullable => 0, is_auto_increment => 1 }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::CustomCollection::Image'; }
sub parent_variable { return 'custom_collection_id'; }

1;