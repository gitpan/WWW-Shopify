
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Comment;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_articles_comments');
__PACKAGE__->add_columns(
	"body_html", { is_nullable => '1', data_type => 'TEXT' },
	"updated_at", { data_type => 'DATETIME', is_nullable => '1' },
	"email", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"body", { data_type => 'TEXT', is_nullable => '1' },
	"created_at", { is_nullable => '1', data_type => 'DATETIME' },
	"id", { data_type => 'BIGINT', is_nullable => '0' },
	"ip", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"published_at", { is_nullable => '1', data_type => 'DATETIME' },
	"status", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"user_agent", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"blog_id", { is_nullable => '1', data_type => 'BIGINT' },
	"article_id", { data_type => 'BIGINT' },
	"shop_id", { data_type => "BIGINT" }
);
__PACKAGE__->set_primary_key('id');



__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');

__PACKAGE__->belongs_to(blog => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Blog', 'blog_id', { join_type => 'left' });
__PACKAGE__->belongs_to(article => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Article', 'article_id');
sub represents { return 'WWW::Shopify::Model::Comment'; }
sub parent_variable { return 'article_id'; }

1;