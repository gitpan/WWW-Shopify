#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Product::Image;
use parent "WWW::Shopify::Model::NestedItem";

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"id" => new WWW::Shopify::Field::Identifier(),
	"position" => new WWW::Shopify::Field::Int(1, 4),
	"src" => new WWW::Shopify::Field::String::URL::Image(),
	"product_id" => new WWW::Shopify::Field::Relation::Parent('WWW::Shopify::Model::Product'),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now')
}; }

sub creation_minimal { return qw(position src); }
sub creation_filled { return qw(id created_at ); }
# Odd, even without an update method, it still has an updated at.
sub updated_filled { return qw(updated_at); } 

sub updatable { return undef; }

sub read_scope { return "read_products"; }
sub write_scope { return "write_products"; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1
