#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::CustomCollection::Collect;
use parent "WWW::Shopify::Model::Item";

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"product_id" => new WWW::Shopify::Field::Relation::ReferenceOne("WWW::Shopify::Model::Product"),
	"collection_id" => new WWW::Shopify::Field::Relation::ReferenceOne("WWW::Shopify::Model::CustomCollection"),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"featured" => new WWW::Shopify::Field::Boolean(),
	"position" => new WWW::Shopify::Field::Int(),
	"id" => new WWW::Shopify::Field::Identifier(),
	"sort_value" => new WWW::Shopify::Field::Int(),
}; }


my $queries; sub queries { return $queries; }
BEGIN { $queries = {
	collection_id => new WWW::Shopify::Query::Match('collection_id')
}; }

sub creation_minimal { return qw(product_id collection_id); }
sub creation_filled { return qw(position created_at); }
sub update_filled { return qw(updated_at); }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1;