#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::File;
use parent 'WWW::Shopify::Model::Item';

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"key" => new WWW::Shopify::Field::Identifier::String(),
	"public_url" => new WWW::Shopify::Field::String::URL(),
	"created_at" => new WWW::Shopify::Field::Date(),
	"updated_at" => new WWW::Shopify::Field::Date(),
	"content_type" => new WWW::Shopify::Field::String(),
	"size" => new WWW::Shopify::Field::Int()
}; }

# Use upload_files.
sub countable { return undef; }
sub creatable { return undef; }
sub updatable { return undef; }
sub deletable { return undef; }

sub needs_login { return 1; }


eval(__PACKAGE__->generate_accessors); die $@ if $@;

1;
