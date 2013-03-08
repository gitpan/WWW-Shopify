#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Metafield;
use parent "WWW::Shopify::Model::Item";

sub stats { 
	return {
		"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
		"id" => new WWW::Shopify::Field::Identifier(),
		"owner_id" => new WWW::Shopify::Field::Relation::ReferenceOne('WWW::Shopify::Model::Shop'),
		"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
		"owner_resource" => new WWW::Shopify::Field::String::Enum(["shop"])
	};
}
sub mods {
	return {
		"description" => new WWW::Shopify::Field::String(),
		"key" => new WWW::Shopify::Field::String(),
		"namespace" => new WWW::Shopify::Field::String(),
		"value_type" => new WWW::Shopify::Field::String::Enum(["integer", "float", "string"]),
		"value" => new WWW::Shopify::Field::String()
	};
}
sub minimal { return ["key"]; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1;
