#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Product::Option;
use parent "WWW::Shopify::Model::NestedItem";

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {"name" => new WWW::Shopify::Field::String::Words(1)}; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1
