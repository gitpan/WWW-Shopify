#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Redirect;
use parent 'WWW::Shopify::Model::Item';

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"path" => new WWW::Shopify::Field::String(),
	"target" => new WWW::Shopify::Field::String(),
	"id" => new WWW::Shopify::Field::Identifier()
}; }

sub creation_minimal { return qw(path target); }
sub creation_filled { return qw(id); }

sub read_scope { return "read_content"; }
sub write_scope { return "write_content"; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1
