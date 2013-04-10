
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Article;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_blogs_articles');
__PACKAGE__->add_columns(
	"summary_html", { data_type => 'TEXT', is_nullable => '1' },
	"published_at", { data_type => 'DATETIME', is_nullable => '1' },
	"author", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"tags", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"created_at", { data_type => 'DATETIME', is_nullable => '1' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"body_html", { data_type => 'TEXT', is_nullable => '1' },
	"title", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"id", { data_type => 'INT', is_nullable => '0' },
	"blog_id", { data_type => 'INT' },
	"shop_id", { data_type => "INT" }
);
__PACKAGE__->set_primary_key('id');

__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(blog => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Blog', 'blog_id');
sub represents { return 'WWW::Shopify::Model::Article'; }
sub parent_variable { return 'blog_id'; }

1;