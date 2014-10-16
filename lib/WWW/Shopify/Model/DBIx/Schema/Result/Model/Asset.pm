
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Asset;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_themes_assets');
__PACKAGE__->add_columns(
	"theme_id", { data_type => 'bigint' },
	"size", { is_nullable => '1', data_type => 'INT' },
	"key", { is_nullable => '0', data_type => 'VARCHAR(255)' },
	"public_url", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"updated_at", { is_nullable => '1', data_type => 'DATETIME' },
	"source_key", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"value", { data_type => 'TEXT', is_nullable => '1' },
	"attachment", { is_nullable => '1', data_type => 'TEXT' },
	"src", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"content_type", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"id", { data_type => 'BIGINT', is_nullable => 0, is_auto_increment => 1 },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::Asset'; }
sub parent_variable { return 'theme_id'; }

1;