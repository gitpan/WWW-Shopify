
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Comment;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_articles_comments');
__PACKAGE__->add_columns(
	"status", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"body", { is_nullable => '1', data_type => 'TEXT' },
	"email", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"user_agent", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"updated_at", { is_nullable => '1', data_type => 'DATETIME' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"ip", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"published_at", { data_type => 'DATETIME', is_nullable => '1' },
	"body_html", { data_type => 'TEXT', is_nullable => '1' },
	"blog_id", { is_nullable => '1', data_type => 'BIGINT' },
	"article_id", { data_type => 'BIGINT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(blog => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Blog', 'blog_id');
__PACKAGE__->belongs_to(article => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Article', 'article_id');
sub represents { return 'WWW::Shopify::Model::Comment'; }
sub parent_variable { return 'article_id'; }

1;