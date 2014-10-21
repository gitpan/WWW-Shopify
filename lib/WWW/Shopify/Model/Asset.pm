#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Asset;
use parent "WWW::Shopify::Model::Item";

sub parent { return "WWW::Shopify::Model::Theme"; }
sub countable { return undef; }
sub identifier { return "key"; }

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"key" => new WWW::Shopify::Field::Identifier::String(),
	"value" => new WWW::Shopify::Field::Text::HTML(),
	"attachment" => new WWW::Shopify::Field::Text(),
	"public_url" => new WWW::Shopify::Field::String::URL(),
	"created_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"updated_at" => new WWW::Shopify::Field::Date(min => '2010-01-01 00:00:00', max => 'now'),
	"content_type" => new WWW::Shopify::Field::String("image/(gif|jpg|png)"),
	"size" => new WWW::Shopify::Field::Int(1, 5000)
}; }

# Look into finding some way to validate whether it's value OR attachment.
sub creation_minimal { return qw(key); }
sub creation_filled { return qw(public_url created_at); }
sub update_filled { return qw(updated_at); }
sub create_method { return "PUT"; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1
