#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::ProductSearchEngine;
use parent "WWW::Shopify::Model::Item";

sub stats($) { return {
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"name" => new WWW::Shopify::Field::Identifier::String()};
}

sub creatable($) { return undef; }
sub updatable($) { return undef; }
sub deletable($) { return undef; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1;
