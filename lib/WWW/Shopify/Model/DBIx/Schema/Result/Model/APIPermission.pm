
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::APIPermission;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_api_permissions');
__PACKAGE__->add_columns(
	"api_permissions_count", { data_type => 'INT', is_nullable => '1' },
	"preferences_url", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"callback_url", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"access_token", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"app_url", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"api_client_id", { is_nullable => '1', data_type => 'BIGINT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(api_client => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::APIClient', 'api_client_id', { join_type => 'left' });
sub represents { return 'WWW::Shopify::Model::APIPermission'; }
sub parent_variable { return undef; }

1;