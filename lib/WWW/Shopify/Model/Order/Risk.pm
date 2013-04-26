#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Order::Risk;
use parent "WWW::Shopify::Model::Item";

sub parent { return 'WWW::Shopify::Model::Order'; }
my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"order_id" => new WWW::Shopify::Field::Money(),
	"message" => new WWW::Shopify::Field::String(),
	"recommendation" => new WWW::Shopify::Field::String::Enum([qw(cancel investigate accept)]),
	"score" => new WWW::Shopify::Field::Float(),
	"cause_cancel" => new WWW::Shopify::Field::Boolean(),
	"source" => new WWW::Shopify::Field::String(),
	"display" => new WWW::Shopify::Field::Boolean()
}; }

sub countable { return undef; }
sub deletable { return 1; }
sub gettable { return undef; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1;
