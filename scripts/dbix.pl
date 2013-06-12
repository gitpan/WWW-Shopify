#!/usr/bin/perl

use strict;
use warnings;

use File::Basename;
use WWW::Shopify::Common::DBIx;
use Module::Find;
use Data::Dumper;
use WWW::Shopify::Field::String;
use Cwd 'abs_path';
use File::Basename;

chdir abs_path(__FILE__) . "/..";

my @classes;

BEGIN {
	@classes = grep { $_ !~ m/DBIx/ && $_ !~ m/NestedItem/ && $_ !~ m/::Item/ } findallmod WWW::Shopify::Model;
	for (@classes) { eval "require $_"; }
}

my $dbix = new WWW::Shopify::Common::DBIx(@classes);
$dbix->generate_dbix_all;

for (keys(%{$dbix->{classes}})) {
	die unless $_ =~ m/WWW::Shopify::Model::/;
	my $path = $';
	$path =~ s/::/\//g;
	$path .= ".pm";
	my $out_path = "lib/WWW/Shopify/Model/$path";
	print STDERR "Generating $out_path... ";
	mkdir dirname($out_path) unless -d dirname($out_path);
	open(my $OUTFILE, ">$out_path") or die $!;
	print $OUTFILE $dbix->class($_);
	close($OUTFILE);
	print "Done.\n";
}
