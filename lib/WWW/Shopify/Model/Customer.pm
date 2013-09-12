#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Customer;
use parent "WWW::Shopify::Model::Item";

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
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
	"addresses" => new WWW::Shopify::Field::Relation::Many('WWW::Shopify::Model::Address', 0, 3),
	"metafields" => new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Metafield"),
	"image_url" => new WWW::Shopify::Field::String::URL(),
	"send_email_invite" => new WWW::Shopify::Field::Boolean(),
	"password" => new WWW::Shopify::Field::String::Password(),
	"multipass_identifier" => new WWW::Shopify::Field::String(),
	"password_confirmation" => new WWW::Shopify::Field::String::Password()
}; }

sub unique_fields { return qw(email); }

sub get_fields { return grep { $_ ne "password" && $_ ne "password_confirmation" && $_ ne "send_email_invite" } keys(%{$_[0]->fields}); }
sub creation_minimal { return qw(email); }
sub creation_filled { return qw(created_at); }
sub update_filled { return qw(updated_at); }
sub update_fields { return qw(password password_confirmation); }
sub throws_webhooks { return 1; }

sub searchable($) { return 1; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1;
