
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::LinkList::Link;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_link_lists_links');
__PACKAGE__->add_columns(
	"position", { data_type => 'INT', is_nullable => '1' },
	"title", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"subject_params", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"link_type", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"subject", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"subject_id", { is_nullable => '1', data_type => 'INT' },
	"link_list_id", { data_type => 'BIGINT' }
);
__PACKAGE__->set_primary_key('id');





__PACKAGE__->belongs_to(link_list => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::LinkList', 'link_list_id');
sub represents { return 'WWW::Shopify::Model::LinkList::Link'; }
sub parent_variable { return 'link_list_id'; }

1;