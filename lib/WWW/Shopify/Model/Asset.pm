#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Asset;
use parent "WWW::Shopify::Model::Item";

sub parent($) { return "WWW::Shopify::Model::Theme"; }

sub countable() { return 0; }

sub identifier($) { return "key"; }
sub mods($) { return {
		"key" => new WWW::Shopify::Field::Identifier::String(),
		"value" => new WWW::Shopify::Field::Text::HTML(),
		"attachment" => new WWW::Shopify::Field::Text()
	};
}
sub stats($) { return {
	"public_url" => new WWW::Shopify::Field::String::URL(),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"content_type" => new WWW::Shopify::Field::String("image/(gif|jpg|png)"),
	"size" => new WWW::Shopify::Field::Int(1, 5000)};
}
sub minimal($) { return ["key"]; }

sub create_method { return "PUT"; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1
