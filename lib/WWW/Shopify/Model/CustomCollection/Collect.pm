#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::CustomCollection::Collect;
use parent "WWW::Shopify::Model::NestedItem";

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"product_id" => new WWW::Shopify::Field::Relation::ReferenceOne("WWW::Shopify::Model::Product"),
	"position" => new WWW::Shopify::Field::Int()
}; }

sub creation_minimal { return qw(product_id); }
sub creation_filled { return qw(position); }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1;
