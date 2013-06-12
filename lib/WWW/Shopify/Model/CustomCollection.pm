#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::CustomCollection;
use parent "WWW::Shopify::Model::Item";

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"body_html" => new WWW::Shopify::Field::String::HTML(),
	"handle" => new WWW::Shopify::Field::String(),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"published_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"id" => new WWW::Shopify::Field::Identifier(),
	"sort_order" => new WWW::Shopify::Field::String::Enum(["manual", "automatic"]),
	"template_suffix" => new WWW::Shopify::Field::String(),
	"metafields" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Metafield"),
	"title" => new WWW::Shopify::Field::String::Words(1, 2),
	"collects" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::CustomCollection::Collect")
}; }

sub creation_minimal { return qw(collects); }
sub creation_filled { return qw(public_url created_at); }
sub update_filled { return qw(updated_at); }
sub throws_webhooks { return 1; }

sub has_metafields { return 1; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1;
