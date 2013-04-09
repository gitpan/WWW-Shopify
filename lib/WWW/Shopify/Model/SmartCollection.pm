#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

use WWW::Shopify::Model::SmartCollection::Rule;
use WWW::Shopify::Model::SmartCollection::Image;

package WWW::Shopify::Model::SmartCollection;
use parent 'WWW::Shopify::Model::Item';

sub singular { return "smart_collection"; }
my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"body_html" => new WWW::Shopify::Field::Text::HTML(),
	"handle" => new WWW::Shopify::Field::String("[a-z]{2,8}\-[a-z]{2,8}"),
	"sort_order" => new WWW::Shopify::Field::String("(manual|automatic)"),
	"template_suffix" => new WWW::Shopify::Field::String(),
	"title" => new WWW::Shopify::Field::String::Words(1, 2),
	"rules" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::SmartCollection::Rule"),
	"image" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::SmartCollection::Image"),
	"id" => new WWW::Shopify::Field::Identifier(),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"published_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now')
}; }

sub creation_minimal { return qw(topic address); }
sub creation_filled { return qw(id created_at); }
sub update_filled { return qw(updated_at); }
sub update_fields { return qw(body_html handle sort_order template_suffix title rules image); }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1
