#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::CustomerGroup;
use parent "WWW::Shopify::Model::Item";

sub stats($) { return {
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"id" => new WWW::Shopify::Field::Identifier(),
	"name" => new WWW::Shopify::Field::String::Words(1, 3),
	"query" => new WWW::Shopify::Field::String::Custom(sub { 
		return 1;
	})};
}

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1;
