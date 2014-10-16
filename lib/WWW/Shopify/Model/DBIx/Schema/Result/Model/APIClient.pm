
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::APIClient;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_api_clients');
__PACKAGE__->add_columns(
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"support_url", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"kind", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"api_key", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"visible", { data_type => 'BOOL', is_nullable => '1' },
	"shared_secret", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"number", { is_nullable => '1', data_type => 'INT' },
	"api_permissions_count", { is_nullable => '1', data_type => 'INT' },
	"embedded", { is_nullable => '1', data_type => 'BOOL' },
	"title", { data_type => 'TEXT', is_nullable => '1' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"api_url", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"application_developer_id", { data_type => 'BIGINT', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(application_developer => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'application_developer_id');
sub represents { return 'WWW::Shopify::Model::APIClient'; }
sub parent_variable { return undef; }

1;