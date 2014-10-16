
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::EmailTemplate;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_email_templates');
__PACKAGE__->add_columns(
	"body", { is_nullable => '1', data_type => 'TEXT' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"body_html", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"include_html", { data_type => 'BOOL', is_nullable => '1' },
	"title", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');


sub represents { return 'WWW::Shopify::Model::EmailTemplate'; }
sub parent_variable { return undef; }

1;