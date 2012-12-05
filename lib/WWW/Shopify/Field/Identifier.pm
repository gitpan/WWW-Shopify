#!/usr/bin/perl

use strict;
use warnings;

package WWW::Shopify::Field::Identifier;
use parent 'WWW::Shopify::Field';
sub sql_type { return "int"; }

sub generate($) {
	return int(rand(100000000))+1;
}

package WWW::Shopify::Field::Identifier::String;
use parent 'WWW::Shopify::Field';
sub sql_type { return "varchar(255)"; }

1;
