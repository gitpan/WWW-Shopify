
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Event;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_events');
__PACKAGE__->add_columns(
	"subject_type", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"message", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"body", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"subject_id", { data_type => 'BIGINT', is_nullable => '1' },
	"verb", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"arguments", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::Event'; }
sub parent_variable { return undef; }

1;