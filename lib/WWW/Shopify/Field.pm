#!/usr/bin/perl

use strict;
use warnings;

use WWW::Shopify::Field::Text;
use WWW::Shopify::Field::Relation;
use WWW::Shopify::Field::String;
use WWW::Shopify::Field::Identifier;

package main;
use String::Random qw(random_regex random_string);
use Data::Random qw(rand_datetime rand_words);

package WWW::Shopify::Field;
sub new($) { my $package = shift; return bless { arguments => [@_] }, $package; }
sub sql_type($) { die ref($_[0]); }
sub is_relation { return undef; }
sub is_qualifier { return undef; }
sub qualifier { return undef; }
sub to_shopify($$) { return $_[1]; }
sub from_shopify($$) { return $_[1]; }
sub generate($) { die; }

package WWW::Shopify::Field::Hook;
use parent 'WWW::Shopify::Field';
sub new($) { return bless { internal => $_[1], qualifier => $_[2] }, $_[0]; }
sub sql_type($) { return shift->{internal}->sql_type(@_); }
sub is_relation {  return shift->{internal}->is_relation(@_); }
sub to_shopify($$) { return shift->{internal}->to_shopify(@_); }
sub from_shopify($$) { return shift->{internal}->from_shopify(@_); }
sub generate($) { return shift->{internal}->generate(@_); }
sub relation($) { return shift->{internal}->relation(@_); }
sub is_many { return shift->{internal}->is_many(@_); }
sub is_one { return shift->{internal}->is_one(@_); }
sub is_own { return shift->{internal}->is_own(@_); }
sub is_reference { return shift->{internal}->is_reference(@_); } 

package WWW::Shopify::Field::Int;
use parent 'WWW::Shopify::Field';
sub sql_type { return "int"; }
sub generate($) { 
	return int(rand(10000)) if (int(@{$_[0]->{arguments}}) == 0);
	return $_[0]->{arguments}->[0] if (int(@{$_[0]->{arguments}}) == 1);
	return int(rand($_[0]->{arguments}->[1] - $_[0]->{arguments}->[0] + 1) + $_[0]->{arguments}->[0]);
}

package WWW::Shopify::Field::Boolean;
use parent 'WWW::Shopify::Field';
sub sql_type { return "bool"; }
sub generate($) {
	return (rand() < 0.5);
}

package WWW::Shopify::Field::Float;
use parent 'WWW::Shopify::Field';
sub sql_type { return "float"; }
sub generate($) {
	return rand() * 10000.0 if (int(@{$_[0]->{arguments}}) == 0); 
	return $_[0]->{arguments}->[0] if (int(@{$_[0]->{arguments}}) == 1);
	return rand($_[0]->{arguments}->[1] - $_[0]->{arguments}->[0] + 1) + $_[0]->{arguments}->[0];
}

package WWW::Shopify::Field::Timezone;
use parent 'WWW::Shopify::Field';
sub sql_type { return "varchar(255)"; }
sub generate($) {
	return "(GMT-05:00) Eastern Time (US & Canada)";
}

package WWW::Shopify::Field::Currency;
use parent 'WWW::Shopify::Field';
sub sql_type { return "varchar(255)"; }
sub generate($) {
	return rand() < 0.5 ? "USD" : "CAD";
}

package WWW::Shopify::Field::Money;
use parent 'WWW::Shopify::Field';
sub sql_type { return "decimal"; }
sub generate($) {
	return sprintf("%.2f", rand(10000));
}

package WWW::Shopify::Field::Date;
use parent 'WWW::Shopify::Field';
sub sql_type { return 'datetime'; }
sub to_shopify { die new WWW::Shopify::Exception($_[1]) unless $_[1] =~ m/(\d+-\d+-\d+) (\d+:\d+:\d+)/; return "$1T$2"; }
sub from_shopify { die new WWW::Shopify::Exception($_[1]) unless $_[1] =~ m/(\d+-\d+-\d+)T(\d+:\d+:\d+)/; return "$1 $2"; }

sub generate($) {
	my %hash = @{$_[0]->{arguments}};
	return ::rand_datetime(%hash);
}

1;
