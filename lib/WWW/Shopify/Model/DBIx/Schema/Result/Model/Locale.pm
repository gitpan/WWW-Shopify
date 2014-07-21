
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Locale;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_locales');
__PACKAGE__->add_columns(
	"owner_name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"progress", { is_nullable => '1', data_type => 'INT' },
	"owner_id", { is_nullable => '1', data_type => 'BIGINT' },
	"shop_count", { data_type => 'INT', is_nullable => '1' },
	"owner_email", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"user_count", { data_type => 'INT', is_nullable => '1' },
	"name", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->has_many(authorships => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Locale::Authorship', 'locale_id');
sub represents { return 'WWW::Shopify::Model::Locale'; }
sub parent_variable { return undef; }

1;