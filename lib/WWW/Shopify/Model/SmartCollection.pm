#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

use WWW::Shopify::Model::SmartCollection::Rule;
use WWW::Shopify::Model::SmartCollection::Image;

package WWW::Shopify::Model::SmartCollection;
use parent 'WWW::Shopify::Model::Item';

sub singular { return "smart_collection"; }
sub mods { return {
		"body_html" => new WWW::Shopify::Field::Text::HTML(),
		"handle" => new WWW::Shopify::Field::String("[a-z]{2,8}\-[a-z]{2,8}"),
		"sort_order" => new WWW::Shopify::Field::String("(manual|automatic)"),
		"template_suffix" => new WWW::Shopify::Field::String(),
		"title" => new WWW::Shopify::Field::String::Words(1, 2),
		"rules" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::SmartCollection::Rule"),
		"image" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::SmartCollection::Image")
	};
}
sub stats { return {
	"id" => new WWW::Shopify::Field::Identifier(),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"published_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now')};
}
# Minimal variables required to create.
sub minimal { return ["topic", "address"]; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1
