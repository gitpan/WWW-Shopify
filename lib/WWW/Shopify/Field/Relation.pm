#!/usr/bin/perl

use strict;
use warnings;

package WWW::Shopify::Field::Relation;
use parent 'WWW::Shopify::Field';
sub new($$) { return bless { relation => $_[1] }, $_[0]; }
sub relation($) { return $_[0]->{relation}; }
sub is_relation { return 1; }
sub is_many { return undef; }
sub is_one { return undef; }
sub is_own { return undef; }
sub is_reference { return undef; } 
sub sql_type { return WWW::Shopify::Field::Identifier->sql_type(); }

package WWW::Shopify::Field::Relation::Many;
use parent 'WWW::Shopify::Field::Relation';
sub is_many { return 1; }

package WWW::Shopify::Field::Relation::ReferenceOne;
use parent 'WWW::Shopify::Field::Relation';
sub is_one { return 1; }
sub is_reference { return 1; }

package WWW::Shopify::Field::Relation::OwnOne;
use parent 'WWW::Shopify::Field::Relation';
sub is_one { return 1; }
sub is_own { return 1; }

1;
