#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Product::Option;
use parent "WWW::Shopify::Model::NestedItem";

sub stats() { return {"name" => new WWW::Shopify::Field::String::Words(1)}; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1
