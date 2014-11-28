
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Webhook;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_webhooks');
__PACKAGE__->add_columns(
	"address", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"format", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"topic", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::Webhook'; }
sub parent_variable { return undef; }

1;