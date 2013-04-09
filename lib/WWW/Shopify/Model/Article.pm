#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Article;
use parent 'WWW::Shopify::Model::Item';

sub parent { return "WWW::Shopify::Model::Blog" }
my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"author" => new WWW::Shopify::Field::String::Name(),
	"body_html" => new WWW::Shopify::Field::Text::HTML(),
	"summary_html" => new WWW::Shopify::Field::Text::HTML(),
	"published_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00'),
	"tags" => new WWW::Shopify::Field::String::Words(1, 7),
	"title" => new WWW::Shopify::Field::String::Words(1, 3),
	"id" => new WWW::Shopify::Field::Identifier(),
	"blog_id" => new WWW::Shopify::Field::Relation::Parent('WWW::Shopify::Model::Blog'),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now')
}; }

sub creation_minimal { return qw(title); }
sub update_fields { return qw(author body_html summary_html published_at tags title); }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1
