#!/usr/bin/perl

use strict;
use warnings;

package WWW::Shopify::Model::NestedItem;
use parent 'WWW::Shopify::Model::Item';

sub is_nested { return 1; }
# Has a parent object; default is the above package nest.
sub parent { die new WWW::Shopify::Exception() unless $_[0] =~ m/(.*?)\:\:\w+$/; return $1; }

1
