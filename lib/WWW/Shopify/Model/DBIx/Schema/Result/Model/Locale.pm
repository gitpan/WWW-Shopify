
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Locale;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_locales');
__PACKAGE__->add_columns(
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"user_count", { data_type => 'INT', is_nullable => '1' },
	"owner_name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"progress", { is_nullable => '1', data_type => 'INT' },
	"shop_count", { is_nullable => '1', data_type => 'INT' },
	"name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"owner_id", { data_type => 'BIGINT', is_nullable => '1' },
	"owner_email", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->has_many(authorships => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Locale::Authorship', 'locale_id');
sub represents { return 'WWW::Shopify::Model::Locale'; }
sub parent_variable { return undef; }

1;