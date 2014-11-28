
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::APIClient;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_api_clients');
__PACKAGE__->add_columns(
	"title", { is_nullable => '1', data_type => 'TEXT' },
	"visible", { is_nullable => '1', data_type => 'BOOL' },
	"embedded", { is_nullable => '1', data_type => 'BOOL' },
	"api_url", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"api_permissions_count", { is_nullable => '1', data_type => 'INT' },
	"shared_secret", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"support_url", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"api_key", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"kind", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"number", { is_nullable => '1', data_type => 'INT' },
	"application_developer_id", { data_type => 'BIGINT', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(application_developer => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'application_developer_id', { join_type => 'left' });
sub represents { return 'WWW::Shopify::Model::APIClient'; }
sub parent_variable { return undef; }

1;