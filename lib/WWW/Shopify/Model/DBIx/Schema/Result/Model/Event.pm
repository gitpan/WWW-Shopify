
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Event;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_events');
__PACKAGE__->add_columns(
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"subject_type", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"arguments", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"message", { data_type => 'TEXT', is_nullable => '1' },
	"body", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"subject_id", { is_nullable => '1', data_type => 'BIGINT' },
	"verb", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::Event'; }
sub parent_variable { return undef; }

1;