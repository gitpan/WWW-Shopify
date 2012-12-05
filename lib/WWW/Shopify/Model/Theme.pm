#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Theme;
use parent 'WWW::Shopify::Model::Item';

sub mods() { return {
	"name" => new WWW::Shopify::Field::String::Words(1),
	"role" => new WWW::Shopify::Field::String::("(main|mobile|unpublished)")};
}
sub stats() { return {
	"id" => new WWW::Shopify::Field::Identifier(),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now')};
}
sub minimal { return ["topic", "address"]; }

sub countable { return 0; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1
