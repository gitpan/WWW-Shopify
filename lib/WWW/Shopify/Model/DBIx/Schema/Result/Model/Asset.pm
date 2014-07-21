
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
	"key", { is_nullable => '0', data_type => 'VARCHAR(255)' },
	"updated_at", { is_nullable => '1', data_type => 'DATETIME' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"attachment", { is_nullable => '1', data_type => 'TEXT' },
	"source_key", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"size", { is_nullable => '1', data_type => 'INT' },
	"src", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"public_url", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"content_type", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"value", { is_nullable => '1', data_type => 'TEXT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('key', 'theme_id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::Asset'; }
sub parent_variable { return 'theme_id'; }

1;