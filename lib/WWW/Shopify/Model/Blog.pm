#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Blog;
use parent 'WWW::Shopify::Model::Item';

sub mods() { return {
	"title" => new WWW::Shopify::Field::String::Words(1, 3),
	"handle" => new WWW::Shopify::Field::String::Handle(),
	"commentable" => new WWW::Shopify::Field::String("(no|yes)"),
	"tags" => new WWW::Shopify::Field::String()};
}
sub stats { return {
	"id" => new WWW::Shopify::Field::Identifier(),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
#	"feedburner" => "string",
#	"feedburner_location" => "string",
#	"template_suffix" => "string"
	};
}
# Minimal variables required to create.
sub minimal() { return ["title"]; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1
