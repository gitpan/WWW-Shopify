
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Article;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_blogs_articles');
__PACKAGE__->add_columns(
	"title", { is_nullable => '1', data_type => 'TEXT' },
	"author", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"published", { data_type => 'BOOL', is_nullable => '1' },
	"published_at", { is_nullable => '1', data_type => 'DATETIME' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"body_html", { is_nullable => '1', data_type => 'TEXT' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"tags", { data_type => 'TEXT', is_nullable => '1' },
	"summary_html", { is_nullable => '1', data_type => 'TEXT' },
	"blog_id", { data_type => 'BIGINT' },
	"user_id", { data_type => 'BIGINT', is_nullable => '1' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(blog => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Blog', 'blog_id');
__PACKAGE__->belongs_to(user => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::User', 'user_id', { join_type => 'left' });
__PACKAGE__->has_many(metafields_hasmany => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::ArticleMetafield', 'article_id');
__PACKAGE__->many_to_many(metafields => 'metafields_hasmany', 'metafield');
sub represents { return 'WWW::Shopify::Model::Article'; }
sub parent_variable { return 'blog_id'; }

1;