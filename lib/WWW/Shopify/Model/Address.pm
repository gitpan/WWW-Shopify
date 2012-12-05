#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Address;
use parent "WWW::Shopify::Model::Item";

sub stats($) { return {
	"address1" => new WWW::Shopify::Field::String::Address(),
	"address2" => new WWW::Shopify::Field::String::Address(),
	"city" => new WWW::Shopify::Field::String::City(),
	"company" => new WWW::Shopify::Field::String::Words(1, 3),
	"country" => new WWW::Shopify::Field::String::Country(),
	"first_name" => new WWW::Shopify::Field::String::FirstName(),
	"last_name" => new WWW::Shopify::Field::String::LastName(),
	"latitude" => new WWW::Shopify::Field::Float(-90, 90),
	"longitude" => new WWW::Shopify::Field::Float(-180, 180),
	"phone" => new WWW::Shopify::Field::String::Phone(),
	"province" => new WWW::Shopify::Field::String::Words(1),
	"zip" => new WWW::Shopify::Field::String("[A-Z][0-9][A-Z] [0-9][A-Z][0-9]"),
	"name" => new WWW::Shopify::Field::String::Words(1, 3),
	"country_code" => new WWW::Shopify::Field::String("[A-Z]{3}"),
	"province_code" => new WWW::Shopify::Field::String("[A-Z]{2}")};
}
sub plural() { return 'addresses'; }

eval(WWW::Shopify::Model::Item::generate_accessors(__PACKAGE__)); die $@ if $@;

1;
