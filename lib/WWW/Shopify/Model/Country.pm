#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Country;
use parent "WWW::Shopify::Model::Item";

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	# Not described in detail enough.
	#"carrier_shipping_rate_proiders" => new WWW::Shopify::Field::Relation::Many()
	#"price_based_Shipping_rates" => new WWW::Shopify::Field::Relation::Many()
	# "weight_based_shipping_rates" => new WWW::Shopify::Field::Relation::Many()
	"code" => new WWW::Shopify::Field::String::CountryCode(),
	"id" => new WWW::Shopify::Field::Identifier(),
	"name" => new WWW::Shopify::Field::String::Country(),
	"provinces" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Country::Province"),
	"tax" => new WWW::Shopify::Field::Float()
	
}; }
my $queries; sub queries { return $queries; }
BEGIN { $queries = {
	since_id => new WWW::Shopify::Query::LowerBound('id')
}; }

sub plural { return "countries"; }

sub creation_minimal { return qw(code); }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1
