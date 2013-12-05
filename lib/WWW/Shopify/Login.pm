#!/usr/bin/perl

use strict;
use warnings;

# All the extra functionality relating to the admin panel should go in here.
package WWW::Shopify::Login;
use parent 'WWW::Shopify';

sub get_all {
	my ($self, $package, $hash) = @_;
	if ($package =~ m/LocaleTranslation/) {
		$hash->{locale_id} = $hash->{parent}->id if $hash->{parent};
	}
	return shift->SUPER::get_all(@_);
}


# Used for the login version.
# X-Shopify-Api-Features:pagination-headers, embed-metafields, include-image-token.
sub embed_metafields { $_[0]->{embed_metafields} = $_[1] if defined $_[1]; return $_[0]->{embed_metafields}; }
sub include_image_token { $_[0]->{include_image_token} = $_[1] if defined $_[1]; return $_[0]->{include_image_token}; }
sub pagination_headers { $_[0]->{pagination_headers} = $_[1] if defined $_[1]; return $_[0]->{pagination_headers}; }

# Takes in a list of locales.
sub create_update_locale_translation {
	my ($self, @locales) = @_;
	my @english_translation = $self->get_english_translation;
	my %hash = map { $_->english => $_->text } @locales;
	my %mapping = ();
	foreach my $english (@english_translation) {
		$mapping{$english->id} = exists $hash{$english->english} ? $hash{$english->english} : "";
	}
	my $locale_id = $locales[0]->locale_id;
	my ($decoded, $response) = $self->put_url("/admin/locales/$locale_id.json", { s => \%mapping });
	my $package = "WWW::Shopify::Model::Locale";
	my $object = $package->from_json($decoded->{$package->singular}, $self);
	return $object;
}

sub get_english_translation {
	my ($self) = @_;
	my $package = "WWW::Shopify::Model::LocaleTranslation";
	my ($decoded, $response) = $self->get_url("/admin/locale_translations/english_translations.json");
	return map { my $object = $package->from_json($_, $self); $object; } @{$decoded->{$package->plural}};
}

sub create {
	my ($self, $item, $hash) = @_;
	return shift->SUPER::create(@_) unless ref($item) =~ m/LocaleTranslation/;
}

1;