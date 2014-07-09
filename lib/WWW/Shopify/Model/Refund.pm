#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Refund;
use parent 'WWW::Shopify::Model::Item';

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"created_at" => new WWW::Shopify::Field::Date(),
	"id" => new WWW::Shopify::Field::Identifier(),
	"note" => new WWW::Shopify::Field::String(),
	"refund_line_items" => new WWW::Shopify::Field::Relation::Many('WWW::Shopify::Model::Refund::LineItem'),
	"restock" => new WWW::Shopify::Field::Boolean(),
	"transactions" => new WWW::Shopify::Field::Relation::Many('WWW::Shopify::Model::Transaction'),
	"user_id" => new WWW::Shopify::Field::Identifier()
}; }

sub parent { return 'WWW::Shopify::Model::Order'; }
sub creatable { return undef; }
sub updatable { return undef; }
sub deletable { return undef; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1;
