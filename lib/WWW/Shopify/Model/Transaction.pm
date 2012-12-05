#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Transaction;
use parent 'WWW::Shopify::Model::Item';

sub parent() { return "WWW::Shopify::Model::Order"; }
sub mods() { return {
	"amount" => new WWW::Shopify::Field::Money(),
	"kind" => new WWW::Shopify::Field::String("(capture|no-capture)")};
}
sub stats() { return {
	"id" => new WWW::Shopify::Field::Identifier(),
	"status" => new WWW::Shopify::Field::String("(success|failure)"),
	"receipt" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Transaction::Receipt"),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"authorization" => new WWW::Shopify::Field::String(),
	"gateway" => new WWW::Shopify::Field::String(),
	"order_id" => new WWW::Shopify::Field::Relation::ReferenceOne('WWW::Shopify::Model::Order')};
}
sub minimal() { return ["path", "target"]; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1
