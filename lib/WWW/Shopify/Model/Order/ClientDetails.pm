#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Order::ClientDetails;
use parent "WWW::Shopify::Model::NestedItem";

sub stats($) { return {
	"accept_language" => new WWW::Shopify::Field::String(),
	"browser_ip" => new WWW::Shopify::Field::String::IPAddress(),
	"session_hash" => new WWW::Shopify::Field::String("[0-9A-F]{32}"),
	"user_agent" => new WWW::Shopify::Field::String()};
}

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1;
