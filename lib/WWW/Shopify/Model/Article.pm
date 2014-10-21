#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Article;
use parent 'WWW::Shopify::Model::Item';

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"author" => new WWW::Shopify::Field::String::Name(),
	"body_html" => new WWW::Shopify::Field::Text::HTML(),
	"summary_html" => new WWW::Shopify::Field::Text::HTML(),
	"published" => new WWW::Shopify::Field::Boolean(),
	"published_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00'),
	"metafields" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Metafield"),
	"tags" => new WWW::Shopify::Field::String::Words(1, 7),
	"title" => new WWW::Shopify::Field::String::Words(1, 3),
	"user_id" => new WWW::Shopify::Field::Int(),
	"id" => new WWW::Shopify::Field::Identifier(),
	"blog_id" => new WWW::Shopify::Field::Relation::Parent('WWW::Shopify::Model::Blog'),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now')
}; }

my $queries; sub queries { return $queries; }
BEGIN { $queries = {
	created_at_min => new WWW::Shopify::Query::LowerBound('created_at'),
	created_at_max => new WWW::Shopify::Query::UpperBound('created_at'),
	updated_at_min => new WWW::Shopify::Query::LowerBound('updated_at'),
	updated_at_max => new WWW::Shopify::Query::UpperBound('updated_at'),
	published_at_min => new WWW::Shopify::Query::LowerBound('published_at'),
	published_at_max => new WWW::Shopify::Query::UpperBound('published_at'),
	published_status => new WWW::Shopify::Query::Enum('published', ['published', 'unpublished', 'any']),
	since_id => new WWW::Shopify::Query::LowerBound('id')
}; }

sub has_metafields { return 1; }
sub parent { return "WWW::Shopify::Model::Blog" }
sub creation_minimal { return qw(title); }
sub update_fields { return qw(author body_html summary_html published_at tags title); }
sub included_in_parnet { return 0; }

sub read_scope { return "read_content"; }
sub write_scope { return "write_content"; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1
