#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Page;
use parent 'WWW::Shopify::Model::Item';

sub mods() { return {
	"author" => new WWW::Shopify::Field::String::Name(),
	"body_html" => new WWW::Shopify::Field::Text::HTML(),
	"summary_html" => new WWW::Shopify::Field::Text::HTML(),
	"title" => new WWW::Shopify::Field::String::Words(1, 3),
	"handle" => new WWW::Shopify::Field::String::Words(1),
	"metafields" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Metafield")
};
}
sub stats { return {
	"id" => new WWW::Shopify::Field::Identifier(),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"published_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00'),
};
}
# Minimal variables required to create.
sub minimal() { return ["title"]; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1;
