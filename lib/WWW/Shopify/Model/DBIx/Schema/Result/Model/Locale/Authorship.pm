
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Locale::Authorship;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_locales_authorships');
__PACKAGE__->add_columns(
	"user_id", { data_type => 'BIGINT', is_nullable => '1' },
	"accepted", { is_nullable => '1', data_type => 'BOOL' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"locale_id", { data_type => 'BIGINT' }
);
__PACKAGE__->set_primary_key('id');





__PACKAGE__->belongs_to(locale => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Locale', 'locale_id');
sub represents { return 'WWW::Shopify::Model::Locale::Authorship'; }
sub parent_variable { return 'locale_id'; }

1;