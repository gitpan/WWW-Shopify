#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Customer;
use parent "WWW::Shopify::Model::Item";

sub stats($) { return {
	"accepts_marketing" => new WWW::Shopify::Field::Boolean(),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"email" => new WWW::Shopify::Field::String::Email(),
	"first_name" => new WWW::Shopify::Field::String::FirstName(),
	"id" => new WWW::Shopify::Field::Identifier(),
	"last_name" => new WWW::Shopify::Field::String::LastName(),
	"last_order_id" => new WWW::Shopify::Field::Relation::ReferenceOne('WWW::Shopify::Model::Order'),
	"note" => new WWW::Shopify::Field::String::Words(0, 6),
	"orders_count" => new WWW::Shopify::Field::Int(0, 1000),
	"state" => new WWW::Shopify::Field::String(),
	"total_spent" => new WWW::Shopify::Field::Money(),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"tags" => new WWW::Shopify::Field::String::Words(0, 6),
	"last_order_name" => new WWW::Shopify::Field::String(),
	"addresses" => new WWW::Shopify::Field::Relation::Many('WWW::Shopify::Model::Address'),
	"metafields" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Metafield"),
	"send_email_invite" => new WWW::Shopify::Field::Boolean(),
	
}; }
sub mods {
	return  {
		"password" => new WWW::Shopify::Field::String::Password(),
		"password_confirmation" => new WWW::Shopify::Field::String::Password()
	};
}

sub minimal { return ["first_name", "last_name", "email"]; }
sub on_creation { return ("created_at", "updated_at"); }

sub searchable($) { return 1; }

eval(__PACKAGE__->generate_accessors()); die $@ if $@;

1;
