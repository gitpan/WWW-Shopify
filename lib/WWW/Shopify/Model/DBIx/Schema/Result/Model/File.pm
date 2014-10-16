
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::File;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_files');
__PACKAGE__->add_columns(
	"size", { data_type => 'INT', is_nullable => '1' },
	"key", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"content_type", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"updated_at", { is_nullable => '1', data_type => 'DATETIME' },
	"public_url", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => 0, is_auto_increment => 1 },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::File'; }
sub parent_variable { return undef; }

1;