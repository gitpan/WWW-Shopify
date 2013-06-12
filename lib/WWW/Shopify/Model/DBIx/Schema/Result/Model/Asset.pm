
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
	"attachment", { data_type => 'TEXT', is_nullable => '1' },
	"value", { data_type => 'TEXT', is_nullable => '1' },
	"public_url", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"size", { data_type => 'INT', is_nullable => '1' },
	"key", { data_type => 'VARCHAR(255)', is_nullable => '0' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"content_type", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"shop_id", { data_type => "INT" }
);
__PACKAGE__->set_primary_key('key');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::Asset'; }
sub parent_variable { return 'theme_id'; }

1;