
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::LinkList::Link;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_link_lists_links');
__PACKAGE__->add_columns(
	"link_list_id", { data_type => 'bigint' },
	"link_type", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"subject_id", { data_type => 'INT', is_nullable => '1' },
	"subject", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"subject_params", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"position", { data_type => 'INT', is_nullable => '1' },
	"title", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => '0' }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::LinkList::Link'; }
sub parent_variable { return 'link_list_id'; }

1;