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
	"kind" => new WWW::Shopify::Field::String::Enum(["capture", "authorization", "sale", "void", "refund"]),
	"id" => new WWW::Shopify::Field::Identifier(),
	"status" => new WWW::Shopify::Field::String::Enum(["success", "failure", "error"]),
	"receipt" => new WWW::Shopify::Field::Relation::OwnOne("WWW::Shopify::Model::Transaction::Receipt"),
	"created_at" => new WWW::Shopify::Field::Date(),
	"authorization" => new WWW::Shopify::Field::String(),
	"gateway" => new WWW::Shopify::Field::String::Enum(["bogus", "real"]),
	"order_id" => new WWW::Shopify::Field::Relation::Parent('WWW::Shopify::Model::Order'),
	"test" => new WWW::Shopify::Field::Boolean(),
	"user_id" => new WWW::Shopify::Field::String(), 
	"device_id" => new WWW::Shopify::Field::String() };
}
sub creation_minimal { return qw(path target); }
sub creation_filled { return qw(id created_at); }
sub update_fields { return qw(amount kind); }

sub read_scope { return "read_orders"; }
sub write_scope { return "write_orders"; }

sub included_in_parent { return 0; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1
