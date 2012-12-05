#!/usr/bin/perl

use strict;
use warnings;

package WWW::Shopify::Model::SmartCollection::Image;
use parent 'WWW::Shopify::Model::NestedItem';

sub stats { return {
	"created_at" =>  new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"src" =>  new WWW::Shopify::Field::String::URL::Shopify()
	};
}

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1;
