#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Transaction;
use parent 'WWW::Shopify::Model::Item';

sub parent { return "WWW::Shopify::Model::Order"; }
my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"amount" => new WWW::Shopify::Field::Money(),
	"kind" => new WWW::Shopify::Field::String("(capture|no-capture)"),
	"id" => new WWW::Shopify::Field::Identifier(),
	"status" => new WWW::Shopify::Field::String("(success|failure)"),
	"receipt" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Transaction::Receipt"),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"authorization" => new WWW::Shopify::Field::String(),
	"gateway" => new WWW::Shopify::Field::String(),
	"order_id" => new WWW::Shopify::Field::Relation::Parent('WWW::Shopify::Model::Order')};
}
sub creation_minimal { return qw(path target); }
sub creation_filled { return qw(id created_at); }
sub update_fields { return qw(amount kind); }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1
