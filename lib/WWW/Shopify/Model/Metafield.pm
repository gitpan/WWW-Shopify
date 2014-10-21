#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Metafield;
use parent "WWW::Shopify::Model::Item";

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
		"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
		"id" => new WWW::Shopify::Field::Identifier(),
		"owner_id" => new WWW::Shopify::Field::Relation::ReferenceOne('WWW::Shopify::Model::Shop'),
		"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
		"owner_resource" => new WWW::Shopify::Field::String::Enum(["shop"]),
		"description" => new WWW::Shopify::Field::String(),
		"key" => new WWW::Shopify::Field::String(),
		"namespace" => new WWW::Shopify::Field::String(),
		"value_type" => new WWW::Shopify::Field::String::Enum(["integer", "float", "string"]),
		"value" => new WWW::Shopify::Field::String()
	};
}

sub creation_minimal { return qw(key namespace value_type value); }
sub creation_filled { return qw(created_at id owner_resource); }
sub update_filled { return qw(updated_at); }
sub update_fields { return qw(description key namespace value_type value); }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1;
