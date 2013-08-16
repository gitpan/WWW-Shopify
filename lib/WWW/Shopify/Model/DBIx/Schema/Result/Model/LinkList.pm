
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::LinkList;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_link_lists');
__PACKAGE__->add_columns(
	"handle", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"title", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->has_many(links => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::LinkList::Link', 'link_list_id');
sub represents { return 'WWW::Shopify::Model::LinkList'; }
sub parent_variable { return undef; }

1;