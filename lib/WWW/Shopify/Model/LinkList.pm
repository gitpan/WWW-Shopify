#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::LinkList;
use parent "WWW::Shopify::Model::Item";

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"handle" => new WWW::Shopify::Field::String::Handle(),
	"title" => new WWW::Shopify::Field::String(),
	"id" => new WWW::Shopify::Field::Identifier(),
#	"default" => new WWW::Shopify::Field::Boolean(),
	"links" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::LinkList::Link")
}; }

sub singular { return "link_list"; }

sub creation_minimal { return qw(handle); }
sub creation_filled { return qw(id); }
sub update_filled { return qw(); }

sub needs_login { return 1; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1;
