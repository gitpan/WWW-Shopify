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
sub new($) { 
	my $package = shift; 
	my $calling_package = caller(1);
	return bless {
		arguments => [@_],
		name => undef
	}, $package;
}
sub name { $_[0]->{name} = $_[1] if defined $_[1]; return $_[0]->{name}; }
sub sql_type($) { die ref($_[0]); }
sub is_relation { return undef; }
sub is_qualifier { return undef; }
sub qualifier { return undef; }
sub to_shopify($$) { return $_[1]; }
sub from_shopify($$) { return $_[1]; }
sub generate($) { die "Can't generate $_[0]"; }
sub validate($) { die "Can't validate $_[0]"; }

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
use String::Numeric qw(is_int);
sub sql_type { return "int"; }
sub generate($) { 
	return int(rand(10000)) if (int(@{$_[0]->{arguments}}) == 0);
	return $_[0]->{arguments}->[0] if (int(@{$_[0]->{arguments}}) == 1);
	return int(rand($_[0]->{arguments}->[1] - $_[0]->{arguments}->[0] + 1) + $_[0]->{arguments}->[0]);
}
sub validate($$) { return is_int($_[1]); }

package WWW::Shopify::Field::Boolean;
use Scalar::Util qw(looks_like_number);
use parent 'WWW::Shopify::Field';
sub sql_type { return "bool"; }
sub generate($) { return (rand() < 0.5); }
sub validate($$) { return looks_like_number($_[1]) ? ($_[1] == 0 || $_[1] == 1) : (lc($_[1]) == 'true' || lc($_[1]) == 'false'); }

package WWW::Shopify::Field::Float;
use parent 'WWW::Shopify::Field';
use String::Numeric qw(is_float);
sub sql_type { return "float"; }
sub generate($) {
	return rand() * 10000.0 if (int(@{$_[0]->{arguments}}) == 0); 
	return $_[0]->{arguments}->[0] if (int(@{$_[0]->{arguments}}) == 1);
	return rand($_[0]->{arguments}->[1] - $_[0]->{arguments}->[0] + 1) + $_[0]->{arguments}->[0];
}
sub validate($$) { return is_float($_[1]); }

package WWW::Shopify::Field::Timezone;
use parent 'WWW::Shopify::Field';
sub sql_type { return "varchar(255)"; }
sub generate($) { return "(GMT-05:00) Eastern Time (US & Canada)"; }


package WWW::Shopify::Field::Currency;
use parent 'WWW::Shopify::Field';
sub sql_type { return "varchar(255)"; }
sub generate($) { return rand() < 0.5 ? "USD" : "CAD"; }

package WWW::Shopify::Field::Money;
use parent 'WWW::Shopify::Field';
use String::Numeric qw(is_float);
sub sql_type { return "decimal"; }
sub generate($) { return sprintf("%.2f", rand(10000)); }
sub validate($) { return undef unless $_[1] =~ m/\s*\$?\s*$/; return is_float($`); }

package WWW::Shopify::Field::Date;
use parent 'WWW::Shopify::Field';
use DateTime;
sub sql_type { return 'datetime'; }
sub to_shopify {
	my $dt = $_[1];
	if (ref($dt) eq "DateTime") {
		my $t = $dt->strftime('%Y-%m-%dT%H:%M:%S%z');
		$t =~ s/(\d\d)$/:$1/;
		return $t;
	}
	die new WWW::Shopify::Exception($dt) unless $dt =~ m/([\d-]+)\s*T?\s*([\d:]+)/;
	return "$1T$2";
}
sub from_shopify {
	my $dt; 
	if ($_[1] =~ m/(\d+)-(\d+)-(\d+)T(\d+):(\d+):(\d+)([+-]\d+):(\d+)/) {
		$dt = DateTime->new(
			year      => $1,
			month     => $2,
			day       => $3,
			hour      => $4,
			minute    => $5,
			second    => $6,
			time_zone => $7 . $8,
		);
	}
	else {
		die new WWW::Shopify::Exception("Unable to parse date " . $_[1]) unless $_[1] =~ m/(\d+)-(\d+)-(\d+)/;
		$dt = DateTime->new(
			year      => $1,
			month     => $2,
			day       => $3
		);
	}
	return $dt;
}
sub validate($) { return scalar($_[1] =~ m/(\d+-\d+-\d+)T?(\d+:\d+:\d+)/); }

sub generate($) {
	my %hash = @{$_[0]->{arguments}};
	return ::rand_datetime(%hash);
}

1;
