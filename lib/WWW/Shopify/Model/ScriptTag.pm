#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::ScriptTag;
use parent "WWW::Shopify::Model::Item";

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"event" => new WWW::Shopify::Field::String::Enum(["onload"]),
	"id" => new WWW::Shopify::Field::Identifier(),
	"src" => new WWW::Shopify::Field::String::URL(),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now')
}; }

sub creation_minimal { return qw(event src); }
sub creation_filled { return qw(id created_at); }
sub update_filled { return qw(updated_at); }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1;
