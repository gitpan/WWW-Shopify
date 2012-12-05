#!/usr/bin/perl

use strict;
use warnings;


use String::Random qw(random_regex random_string);
use Data::Random;

package WWW::Shopify::Field::Text;
use parent 'WWW::Shopify::Field';
sub sql_type { return "text"; }
sub generate($) {
	return join(" ", ::rand_words( size => int(rand(1000))+1 ));
}

package WWW::Shopify::Field::Text::HTML;
use parent 'WWW::Shopify::Field::Text';
sub generate($) {
	return "<html>" . WWW::Shopify::Field::Text::generate($_[0]) . "</html>";
}

1;
