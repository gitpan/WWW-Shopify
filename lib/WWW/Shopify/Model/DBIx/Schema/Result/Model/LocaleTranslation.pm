
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::LocaleTranslation;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_locales_locale_translations');
__PACKAGE__->add_columns(
	"text", { is_nullable => '1', data_type => 'TEXT' },
	"english", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"locale_id", { data_type => 'BIGINT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(locale => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Locale', 'locale_id');
sub represents { return 'WWW::Shopify::Model::LocaleTranslation'; }
sub parent_variable { return 'locale_id'; }

1;