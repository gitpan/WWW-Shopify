#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::CustomCollection;
use parent "WWW::Shopify::Model::Item";

sub stats($) { return {
	"body_html" => new WWW::Shopify::Field::String::HTML(),
	"handle" => new WWW::Shopify::Field::String(),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"published_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"id" => new WWW::Shopify::Field::Identifier::String(),
	"sort_order" => new WWW::Shopify::Field::String::Enum(["manual", "automatic"]),
	"template_suffix" => new WWW::Shopify::Field::String(),
	"metafields" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Metafield") };
}

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;
sub has_metafields { return 1; }

1;
