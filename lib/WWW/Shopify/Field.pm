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

=head2 WWW::Shopify::Model::Field

The main object representing a field on a Shopify object. Contains mainly a name, and a type. Can also contain more data when the need arises to represent something more specifically.

There are a lot of these, so I'm not going to list them; most of the distinctions are made so that databases with reasonable data can be generated.

=cut


package WWW::Shopify::Field;
sub new($) { 
	my $package = shift; 
	my $calling_package = caller(0);
	return bless {
		arguments => [@_],
		name => undef,
		owner => $calling_package
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
sub owner { $_[0]->{owner} = $_[1] if defined $_[1]; return $_[0]->{owner}; }

sub is_db_belongs_to { return undef; }
sub is_db_has_many { return undef; }
sub is_db_many_many { return undef; }
sub is_db_has_one { return undef; }

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

my %from_shopify_timezones = (
	"(GMT-05:00) Eastern Time (US & Canada)" => "America/New_York" ,
	"(GMT-11:00) International Date Line West" => "-1100",
	"(GMT-11:00) Midway Island" => "Pacific/Midway",
	"(GMT-11:00) American Samoa" => "Pacific/Pago_Pago",
	"(GMT-10:00) Hawaii" => "Pacific/Honolulu",
	"(GMT-09:00) Alaska" => "America/Anchorage", 
	"(GMT-08:00) Pacific Time (US & Canada)" => "PST8PDT",
	"(GMT-08:00) Tijuana" => "America/Tijuana",
	"(GMT-07:00) Mountain Time (US & Canada)" => "MST7MDT",
	"(GMT-07:00) Arizona" => "MST",
	"(GMT-07:00) Chihuahua" => "America/Chihuahua",
	"(GMT-07:00) Mazatlan" => "MST",
	"(GMT-06:00) Central Time (US & Canada)" => "CST6CDT",
	"(GMT-06:00) Saskatchewan" => "-0600",
	"(GMT-06:00) Guadalajara" => "CST6CDT",
	"(GMT-06:00) Mexico City" => "CST6CDT",
	"(GMT-06:00) Monterrey" => "America/Monterrey",
	"(GMT-06:00) Central America" => "CST6CDT",
	"(GMT-05:00) Indiana (East)" => "EST5EDT",
	"(GMT-05:00) Bogota" => "America/Bogota",
	"(GMT-05:00) Lima" => "America/Lima",
	"(GMT-05:00) Quito" => "-0500",
	"(GMT-04:00) Atlantic Time (Canada)" => "America/Halifax",
	"(GMT-04:30) Caracas" => "America/Caracas",
	"(GMT-04:00) La Paz" => "-04:00",
	"(GMT-04:00) Santiago" => "America/Santiago",
	"(GMT-03:30) Newfoundland" => "America/La_Paz",
	"(GMT-03:00) Brasilia" => "America/Sao_Paulo",
	"(GMT-03:00) Buenos Aires" => "America/Argentina/Buenos_Aires",
	"(GMT-04:00) Georgetown" => "America/Guyana",
	"(GMT-03:00) Greenland" => "-0300",
	"(GMT-02:00) Mid-Atlantic" => "-0200",
	"(GMT-01:00) Azores" => "Atlantic/Azores",
	"(GMT-01:00) Cape Verde Is." => "Atlantic/Cape_Verde",
	"(GMT+00:00) Dublin" => "Europe/Dublin",
	"(GMT+00:00) Edinburgh" => "Europe/London",
	"(GMT+00:00) Lisbon" => "Europe/Lisbon",
	"(GMT+00:00) London" => "Europe/London",
	"(GMT+00:00) Casablanca" => "Africa/Casablanca",
	"(GMT+00:00) Monrovia" => "Africa/Monrovia",
	"(GMT+00:00) UTC" => "UTC",
	"(GMT+01:00) Belgrade" => "Europe/Belgrade",
	"(GMT+01:00) Bratislava" => "Europe/Bratislava",
	"(GMT+01:00) Budapest" => "Europe/Budapest",
	"(GMT+01:00) Ljubljana" => "Europe/Ljubljana",
	"(GMT+01:00) Prague" => "Europe/Prague",
	"(GMT+01:00) Sarajevo" => "Europe/Sarajevo",
	"(GMT+01:00) Skopje" => "Europe/Skopje",
	"(GMT+01:00) Warsaw" => "Europe/Warsaw",
	"(GMT+01:00) Zagreb" => "Europe/Zagreb",
	"(GMT+01:00) Brussels" => "Europe/Brussels",
	"(GMT+01:00) Copenhagen" => "Europe/Copenhagen",
	"(GMT+01:00) Madrid" => "Europe/Madrid",
	"(GMT+01:00) Paris" => "Europe/Paris",
	"(GMT+01:00) Amsterdam" => "Europe/Amsterdam",
	"(GMT+01:00) Berlin" => "Europe/Berlin",
	"(GMT+01:00) Bern" => "Europe/Zurich",
	"(GMT+01:00) Rome" => "Europe/Rome",
	"(GMT+01:00) Stockholm" => "Europe/Stockholm",
	"(GMT+01:00) Vienna" => "Europe/Vienna",
	"(GMT+01:00) West Central Africa" => "+0100",
	"(GMT+02:00) Bucharest" => "Europe/Bucharest",
	"(GMT+02:00) Cairo" => "Africa/Cairo",
	"(GMT+02:00) Helsinki" => "Europe/Helsinki",
	"(GMT+02:00) Kyiv" => "Europe/Kiev",
	"(GMT+02:00) Riga" => "Europe/Riga",
	"(GMT+02:00) Sofia" => "Europe/Sofia",
	"(GMT+02:00) Tallinn" => "Europe/Tallinn",
	"(GMT+02:00) Vilnius" => "Europe/Vilnius",
	"(GMT+02:00) Athens" => "Europe/Athens",
	"(GMT+02:00) Istanbul" => "Europe/Istanbul",
	"(GMT+03:00) Minsk" => "Europe/Minsk",
	"(GMT+02:00) Jerusalem" => "Asia/Jerusalem",
	"(GMT+02:00) Harare" => "Africa/Harare",
	"(GMT+02:00) Pretoria" => "Africa/Maseru",
	"(GMT+04:00) Moscow" => "Europe/Moscow",
	"(GMT+04:00) St. Petersburg" => "Europe/Moscow",
	"(GMT+04:00) Volgograd" => "Europe/Volgograd",
	"(GMT+03:00) Kuwait" => "Asia/Kuwait",
	"(GMT+03:00) Riyadh" => "Asia/Riyadh",
	"(GMT+03:00) Nairobi" => "Africa/Nairobi",
	"(GMT+03:00) Baghdad" => "Asia/Baghdad",
	"(GMT+03:30) Tehran" => "Asia/Tehran",
	"(GMT+04:00) Abu Dhabi" => "+0400",
	"(GMT+04:00) Muscat" => "Asia/Muscat",
	"(GMT+04:00) Baku" => "Asia/Baku",
	"(GMT+04:00) Tbilisi" => "Asia/Tbilisi",
	"(GMT+04:00) Yerevan" => "Asia/Yerevan",
	"(GMT+04:30) Kabul" => "Asia/Kabul",
	"(GMT+06:00) Ekaterinburg" => "Asia/Yekaterinburg",
	"(GMT+05:00) Islamabad" => "+05:00",
	"(GMT+05:00) Karachi" => "Asia/Karachi",
	"(GMT+05:00) Tashkent" => "Asia/Tashkent",
	"(GMT+05:30) Chennai" => "+05:30",
	"(GMT+05:30) Kolkata" => "Asia/Kolkata",
	"(GMT+05:30) Mumbai" => "+05:30",
	"(GMT+05:30) New Delhi" => "+05:30",
	"(GMT+05:45) Kathmandu" => "Asia/Kathmandu",
	"(GMT+06:00) Astana" => "Asia/Thimphu",
	"(GMT+06:00) Dhaka" => "Asia/Dhaka",
	"(GMT+05:30) Sri Jayawardenepura" => "+0530",
	"(GMT+06:00) Almaty" => "Asia/Almaty",
	"(GMT+07:00) Novosibirsk" => "Asia/Novosibirsk",
	"(GMT+06:30) Rangoon" => "Asia/Rangoon",
	"(GMT+07:00) Bangkok" => "Asia/Bangkok",
	"(GMT+07:00) Hanoi" => "+0700",
	"(GMT+07:00) Jakarta" => "Asia/Jakarta",
	"(GMT+08:00) Krasnoyarsk" => "Asia/Krasnoyarsk",
	"(GMT+08:00) Beijing" => "Asia/Shanghai",
	"(GMT+08:00) Chongqing" => "Asia/Chongqing",
	"(GMT+08:00) Hong Kong" => "Asia/Hong_Kong",
	"(GMT+08:00) Urumqi" => "Asia/Urumqi",
	"(GMT+08:00) Kuala Lumpur" => "Asia/Kuala_Lumpur",
	"(GMT+08:00) Singapore" => "Asia/Singapore",
	"(GMT+08:00) Taipei" => "Asia/Taipei",
	"(GMT+08:00) Perth" => "Australia/Perth",
	"(GMT+09:00) Irkutsk" => "Asia/Irkutsk",
	"(GMT+08:00) Ulaan Bataar" => "Asia/Ulaanbaatar",
	"(GMT+09:00) Seoul" => "Asia/Seoul",
	"(GMT+09:00) Osaka" => "Asia/Tokyo",
	"(GMT+09:00) Sapporo" => "Asia/Tokyo",
	"(GMT+09:00) Tokyo" => "Asia/Tokyo",
	"(GMT+10:00) Yakutsk" => "Asia/Yakutsk",
	"(GMT+09:30) Darwin" => "Australia/Darwin",
	"(GMT+09:30) Adelaide" => "Australia/Adelaide",
	"(GMT+10:00) Canberra" => "Australia/Canberra",
	"(GMT+10:00) Melbourne" => "Australia/Melbourne",
	"(GMT+10:00) Sydney" => "Australia/Sydney",
	"(GMT+10:00) Brisbane" => "Australia/Brisbane",
	"(GMT+10:00) Hobart" => "Australia/Hobart",
	"(GMT+11:00) Vladivostok" => "Asia/Vladivostok",
	"(GMT+10:00) Guam" => "Pacific/Guam",
	"(GMT+10:00) Port Moresby" => "Pacific/Port_Moresby",
	"(GMT+12:00) Magadan" => "Asia/Magadan",
	"(GMT+12:00) Solomon Is." => "+1100",
	"(GMT+11:00) New Caledonia" => "+1100",
	"(GMT+12:00) Fiji" => "Pacific/Fiji",
	"(GMT+12:00) Kamchatka" => "Asia/Kamchatka",
	"(GMT+12:00) Marshall Is." => "Pacific/Majuro",
	"(GMT+12:00) Auckland" => "Pacific/Auckland",
	"(GMT+12:00) Wellington" => "Pacific/Auckland",
	"(GMT+13:00) Nuku'alofa" => "Pacific/Tongatapu",
	"(GMT+13:00) Tokelau Is." => "Pacific/Fakaofo",
	"(GMT+13:00) Samoa" => "Pacific/Apia"
);
my %to_shopify_timezones = reverse(%from_shopify_timezones);

sub timezone_mapping { return \%to_shopify_timezones; }
sub shopify_timezones { return keys(%from_shopify_timezones); }

sub to_shopify {
	my $dttz = $_[1];
	my $mapping = $to_shopify_timezones{$dttz->name};
	$mapping = "(GMT+00:00) UTC" unless $mapping;
	return $mapping;
}

sub from_shopify {
	my $dttz = $_[1];
	my $mapping = $from_shopify_timezones{$dttz};
	$mapping = "UTC" unless $mapping;
	return DateTime::TimeZone->new(name => $mapping);
}

sub generate {
	my @timezones = keys(%from_shopify_timezones);
	return $timezones[int(rand(@timezones))];
}


package WWW::Shopify::Field::Currency;
use parent 'WWW::Shopify::Field';
sub sql_type { return "varchar(255)"; }
sub generate($) { return rand() < 0.5 ? "USD" : "CAD"; }

package WWW::Shopify::Field::Money;
use parent 'WWW::Shopify::Field';
use String::Numeric qw(is_float);
sub sql_type { return "decimal(10,2)"; }
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
	return undef unless $_[1];
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
