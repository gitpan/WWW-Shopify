#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Article;
use parent 'WWW::Shopify::Model::Item';

sub parent { return "WWW::Shopify::Model::Blog" }
sub mods() { return {
	"author" => new WWW::Shopify::Field::String::Name(),
	"body_html" => new WWW::Shopify::Field::Text::HTML(),
	"summary_html" => new WWW::Shopify::Field::Text::HTML(),
	"published_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00'),
	"tags" => new WWW::Shopify::Field::String::Words(1, 7),
	"title" => new WWW::Shopify::Field::String::Words(1, 3)};
}
sub stats() { return {
	"id" => new WWW::Shopify::Field::Identifier(),
	"blog_id" => new WWW::Shopify::Field::Relation::ReferenceOne('WWW::Shopify::Model::Blog'),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now')};
}
sub minimal() { return ["title"]; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1
