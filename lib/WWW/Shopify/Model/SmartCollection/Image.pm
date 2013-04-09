#!/usr/bin/perl

use strict;
use warnings;

package WWW::Shopify::Model::SmartCollection::Image;
use parent 'WWW::Shopify::Model::NestedItem';

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"created_at" =>  new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"src" =>  new WWW::Shopify::Field::String::URL::Shopify()
}; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1;
