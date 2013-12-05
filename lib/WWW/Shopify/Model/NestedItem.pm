#!/usr/bin/perl

use strict;
use warnings;

package WWW::Shopify::Model::NestedItem;
use parent 'WWW::Shopify::Model::Item';

sub is_nested { return 1; }
# Has a parent object; default is the above package nest.
sub parent { my $package = $_[0]; $package = ref($package) if ref($package); die new WWW::Shopify::Exception($package) unless $package =~ m/(.*?)\:\:\w+$/; return $1; }

1
