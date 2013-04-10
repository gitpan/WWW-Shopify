
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::ScriptTag;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_script_tags');
__PACKAGE__->add_columns(
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"src", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'INT', is_nullable => '0' },
	"event", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"shop_id", { data_type => "INT" }
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::ScriptTag'; }
sub parent_variable { return undef; }

1;