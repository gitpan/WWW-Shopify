#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::ScriptTag;
use parent "WWW::Shopify::Model::Item";

sub stats($) { return {
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"event" => new WWW::Shopify::Field::String::Enum(["onload"]),
	"id" => new WWW::Shopify::Field::Identifier(),
	"src" => new WWW::Shopify::Field::String::URL(),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now')};
}

sub minimal() { return ["event", "src"]; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1;
