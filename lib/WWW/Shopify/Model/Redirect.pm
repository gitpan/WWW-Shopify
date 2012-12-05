#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Redirect;
use parent 'WWW::Shopify::Model::Item';

sub mods() { return {
	"path" => new WWW::Shopify::Field::String(),
	"target" => new WWW::Shopify::Field::String()};
}
sub stats() { return {"id" => new WWW::Shopify::Field::Identifier()}; }
sub minimal() { return ["path", "target"]; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1
