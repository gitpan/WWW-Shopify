#!/usr/bin/perl

use strict;
use warnings;

package WWW::Shopify::Query;
sub new { return bless { name => undef }, $_[0]; }
sub name { $_[0]->{name} = $_[1] if defined $_[1]; return $_[0]->{name}; }
sub field_name { $_[0]->{field_name} = $_[1] if defined $_[1]; return $_[0]->{field_name}; }

package WWW::Shopify::Query::LowerBound;
use parent 'WWW::Shopify::Query';
sub new { return bless { 'field_name' => $_[1] }, $_[0]; }

package WWW::Shopify::Query::UpperBound;
use parent 'WWW::Shopify::Query';
sub new { return bless { 'field_name' => $_[1] }, $_[0]; }

package WWW::Shopify::Query::Enum;
use parent 'WWW::Shopify::Query';
sub new { return bless { 'field_name' => $_[1], 'enums' => $_[2] }, $_[0]; }
sub enums { return @{$_[0]->{enums}}; }

package WWW::Shopify::Query::Match;
use parent 'WWW::Shopify::Query';
sub new { return bless { 'field_name' => $_[1] }, $_[0]; }

package WWW::Shopify::Query::Custom;
use parent 'WWW::Shopify::Query';
sub new { return bless { }, $_[0]; }

1;
