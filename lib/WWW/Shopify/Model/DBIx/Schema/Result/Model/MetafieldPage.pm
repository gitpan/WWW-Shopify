
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::MetafieldPage;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_metafieldspages');
__PACKAGE__->add_columns(
	'page_id', { data_type => 'INT', is_nullable => 0 },
	'metafield_id', { data_type => 'INT', is_nullable => 0 }
);
__PACKAGE__->belongs_to(page => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Page', 'page_id');
__PACKAGE__->belongs_to(metafield => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Metafield', 'metafield_id');

1;