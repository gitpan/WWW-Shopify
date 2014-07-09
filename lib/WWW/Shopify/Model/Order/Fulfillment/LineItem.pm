#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Model::Order::Fulfillment::LineItem;
use parent 'WWW::Shopify::Model::Order::LineItem';
use Clone qw(clone);
my $fields = undef;
sub fields {
	my $self = shift;
	return $fields if $fields;
	$fields = clone($self->SUPER::fields);
	$fields->{properties} = new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Order::Fulfillment::LineItem::Property");
	$fields->{properties}->name('properties');
	$fields->{tax_lines} = new WWW::Shopify::Field::Relation::Many("WWW::Shopify::Model::Order::Fulfillment::LineItem::TaxLine");
	$fields->{tax_lines}->name('tax_lines');
	return $fields;
}

1;
