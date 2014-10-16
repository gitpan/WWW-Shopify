
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::User;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_users');
__PACKAGE__->add_columns(
	"bio", { data_type => 'TEXT', is_nullable => '1' },
	"permissions", { data_type => 'TEXT', is_nullable => '1' },
	"receive_announcements", { is_nullable => '1', data_type => 'INT' },
	"last_name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"user_type", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"im", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"email", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"url", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"account_owner", { is_nullable => '1', data_type => 'BOOL' },
	"phone", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"first_name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::User'; }
sub parent_variable { return undef; }

1;