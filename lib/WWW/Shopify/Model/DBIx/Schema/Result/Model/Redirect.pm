
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Redirect;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_redirects');
__PACKAGE__->add_columns(
	"target", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'INT', is_nullable => '1' },
	"path", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"shop_id", { data_type => "INT" }
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::Redirect'; }
sub parent_variable { return undef; }

1;