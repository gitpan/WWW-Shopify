#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::CustomCollection;
use parent "WWW::Shopify::Model::Item";

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"body_html" => new WWW::Shopify::Field::String::HTML(),
	"handle" => new WWW::Shopify::Field::String::Handle(),
	"updated_at" => new WWW::Shopify::Field::Date(),
	"published" => new WWW::Shopify::Field::Boolean(),
	"published_scope" => new WWW::Shopify::Field::String::Enum(["global"]),
	"published_at" => new WWW::Shopify::Field::Date(),
	"id" => new WWW::Shopify::Field::Identifier(),
	"sort_order" => new WWW::Shopify::Field::String::Enum(["manual", "best-selling",  "alpha-asc", "alpha-desc", "price-asc", "price-desc", "created", "created-desc"]),
	"template_suffix" => new WWW::Shopify::Field::String(),
	"metafields" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Metafield"),
	"image" => new WWW::Shopify::Field::Relation::OwnOne('WWW::Shopify::Model::CustomCollection::Image'),
	"title" => new WWW::Shopify::Field::String::Words(1, 2),
#	"collects" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::CustomCollection::Collect")
}; }

sub creation_minimal { return qw(collects); }
sub creation_filled { return qw(public_url created_at); }
sub update_filled { return qw(updated_at); }
sub throws_webhooks { return 1; }

sub has_metafields { return 1; }

sub read_scope { return "read_products"; }
sub write_scope { return "write_products"; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1;
