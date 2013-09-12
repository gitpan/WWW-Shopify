#!/usr/bin/perl

use strict;
use warnings;

use Module::Find;
use Data::Dumper;
use File::Slurp;

BEGIN {	eval(join("\n", map { "require $_;" } findallmod WWW::Shopify::Model)); }

sub get_html {
	my ($package) = @_;
	my $singular = $package->singular;
	$singular =~ s/_//g;
	return scalar(read_file("/tmp/$singular.html")) if -e "/tmp/$singular.html";
	my $url = "http://docs.shopify.com/api/$singular";
	print STDERR "Getting $url...\n";
	# Have to use Curl; they're rejecting UserAgent, and I don't feel bothered enough to work around it.
	my $content = `curl -s -X GET $url`;
	write_file("/tmp/$singular.html", $content);
	return $content;
}

sub format_name_description {
	my ($name, $description) = @_;
	$name =~ s/^metafield$/metafields/;
	$description =~ s/^(<p>|<\/p>)//g;
	$description =~ s/\s+:\s*$//g;
	$description =~ s/<a.*?>(.*?)<\/a>/$1/g;
	return ($name, $description);
}

my %hashes = ();
sub process_package {
	my ($package) = @_;
	my $html = get_html($package);
	my %hash = ();
	$html =~ s/<div class="api-endpoint-queryparameters">.*?<\/div>//gmis;
	while ($html =~ m/<pre>\s*(\w+)\s*<\/pre>.*?<p>\s*(.*?)\s*<\/p>\s*(<ul>.*?<\/ul>)?/gmis) {
		my ($name, $description) = format_name_description($1, ($3 ? $2 . $3 : $2));
		$hash{$name} = $description if $package->field($name);
	}
	foreach my $field_name (keys(%hash)) {
		my $field = $package->field($field_name);
		if ($hash{$field_name} =~ m/<ul>/) {
			if ($field->is_relation && ($field->is_many || $field->is_own)) {
				$hash{$field_name} =~ s/<div class="api-endpoint-queryparameters">.*?<\/div>//gmis;
				while ($hash{$field_name} =~ m/<(strong|pre)>(\w+).*?<\/(strong|pre)>(:\s*)?(.*?)<\/li>/gmis) {
					my ($name, $description) = format_name_description($2, $5);
					$hashes{$field->relation} = {} unless $hashes{$field->relation};
					$hashes{$field->relation}->{$name} = $description if $field->relation->field($name);
				}
				#print STDERR Dumper($hashes{$field->relation});
				if ($hash{$field_name} =~ m/(<p>)?(.*?)(<\/p>)?.*?<ul>/) {
					$hash{$field_name} = $2;
					$hash{$field_name} =~ s/^\s+//;
					$hash{$field_name} =~ s/\s+$//;
				}
			}
		}
	}
	return \%hash;
}

my @packages = grep { $_ !~ m/DBIx/ && !$_->is_nested && !$_->needs_login && $_ !~ m/Variant/ } findallmod WWW::Shopify::Model;
$hashes{$_} = process_package($_) for (@packages);

sub prune_descriptions {
	my ($hash) = @_;
	foreach my $key (keys(%$hash)) {
		if ($hash->{$key}) {
			if (!ref($hash->{$key})) {
				my @lines = split(/\n/, $hash->{$key});
				$hash->{$key} = $lines[0];
				$hash->{$key} =~ s/<\!--.*?-->//g;
			}
			elsif (ref($hash->{$key})) {
				prune_descriptions($hash->{$key});
			}
		}
	}
}
prune_descriptions(\%hashes);

my $textual = Dumper(\%hashes);
$textual =~ s/\$VAR1/my \$tooltips/;

my $file = "#!/usr/bin/perl
use strict;
use warnings;

package WWW::Shopify::Tooltips;
use WWW::Shopify;

use Exporter qw(import);

$textual

our \@EXPORT_OK = qw(get_tooltip);

sub get_tooltip {
	my (\$package, \$field_name) = \@_;
	\$package = WWW::Shopify->translate_model(\$package);
	return undef unless exists \$tooltips->{\$package} && \$tooltips->{\$package}->{\$field_name};
	return \$tooltips->{\$package}->{\$field_name};
}


1;";

use File::Basename;
use Cwd 'abs_path';
use File::Slurp;

write_file(dirname(__FILE__) . "/../lib/WWW/Shopify/Tooltips.pm", $file);

