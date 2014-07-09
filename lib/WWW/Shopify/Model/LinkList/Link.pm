#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::LinkList::Link;
use parent "WWW::Shopify::Model::NestedItem";

my $fields; sub fields { return $fields; } 
BEGIN { $fields = {
	"id" => new WWW::Shopify::Field::Identifier(),
	"position" => new WWW::Shopify::Field::Int(),
	"subject" => new WWW::Shopify::Field::String(),
	"subject_id" => new WWW::Shopify::Field::Int(),
	"subject_params" => new WWW::Shopify::Field::String(),
	"title" => new WWW::Shopify::Field::String(),
	"link_type" => new WWW::Shopify::Field::String::Enum(["collection", "product", "frontpage", "catalog", "page", "blog", "search", "http"])
}; }

sub creation_minimal { return qw(title link_type); }
sub creation_filled { return qw(); }
sub update_filled { return qw(); }

sub link_model_type {
	return ('WWW::Shopify::Model::CustomCollection', 'WWW::Shopify::Model::SmartCollection') if $_[0]->link_type eq 'collection';
	return 'WWW::Shopify::Model::Product' if $_[0]->link_type eq 'product';
	return 'WWW::Shopify::Model::Page' if $_[0]->link_type eq 'page';
	return 'WWW::Shopify::Model::Blog' if $_[0]->link_type eq 'blog';
	return undef;
}

sub needs_login { return 1; }

eval(__PACKAGE__->generate_accessors); die $@ if $@;

1;
