#!/usr/bin/perl

use strict;
use warnings;
use utf8; 

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
sub embed_metafields { if (defined $_[1]) { $_[0]->{embed_metafields} = $_[1]; $_[0]->update_x_shopify_api_features; } return $_[0]->{embed_metafields}; }
sub include_image_token {  if (defined $_[1]) { $_[0]->{include_image_token} = $_[1]; $_[0]->update_x_shopify_api_features; } return $_[0]->{include_image_token}; }
sub pagination_headers { if (defined $_[1]) { $_[0]->{pagination_headers} = $_[1]; $_[0]->update_x_shopify_api_features; } return $_[0]->{pagination_headers}; }
sub include_variant_summary { if (defined $_[1]) { $_[0]->{include_variant_summary} = $_[1]; $_[0]->update_x_shopify_api_features; } return $_[0]->{include_variant_summary}; }
sub include_gift_cards { if (defined $_[1]) { $_[0]->{include_gift_cards} = $_[1]; $_[0]->update_x_shopify_api_features; } return $_[0]->{include_gift_cards}; }
sub future_publishables { if (defined $_[1]) { $_[0]->{future_publishables} = $_[1]; $_[0]->update_x_shopify_api_features; } return $_[0]->{future_publishables}; }

sub x_shopify_api_headers {
	$_[0]->embed_metafields($_[1]);
	$_[0]->include_image_token($_[1]);
	$_[0]->pagination_headers($_[1]);
	$_[0]->include_variant_summary($_[1]);
	$_[0]->include_gift_cards($_[1]);
	$_[0]->future_publishables($_[1]);
}

sub update_x_shopify_api_features {
	my ($self) = @_;
	my @list = (
		($_[0]->embed_metafields ? ('embed-metafields') : ()),
		($_[0]->pagination_headers ? ('pagination-headers') : ()),
		($_[0]->include_image_token ? ('include-image-token') : ()),
		($_[0]->include_variant_summary ? ('include-variant-summary') : ()),
		($_[0]->include_gift_cards ? ('include-gift-cards') : ()),
		($_[0]->future_publishables ? ('future-publishables') : ()),
	);
	if (int(@list) == 0 && $self->url_handler->{_default_headers}->{'X-Shopify-Api-Features'}) {
		delete $self->url_handler->{_default_headers}->{'X-Shopify-Api-Features'};
		delete $self->url_handler->{_default_headers}->{'X-Requested-With'};
	} elsif (int(@list) > 0) {
		$self->url_handler->{_default_headers}->{'X-Shopify-Api-Features'} = join(", ", @list);
		$self->url_handler->{_default_headers}->{'X-Requested-With'} = "XMLHttpRequest";
	}
}
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
	my ($decoded, $response) = $self->use_url('put', "/admin/locales/$locale_id.json", { s => \%mapping });
	my $package = "WWW::Shopify::Model::Locale";
	my $object = $package->from_json($decoded->{$package->singular}, $self);
	return $object;
}

sub get_english_translation {
	my ($self) = @_;
	my $package = "WWW::Shopify::Model::LocaleTranslation";
	my ($decoded, $response) = $self->use_url('get', "/admin/locale_translations/english_translations.json");
	return map { my $object = $package->from_json($_, $self); $object; } @{$decoded->{$package->plural}};
}

sub create {
	my ($self, $item, $hash) = @_;
	return shift->SUPER::create(@_) unless ref($item) =~ m/LocaleTranslation/;
}

sub send_activation_links {
	my ($self, @customers) = @_;
	my ($decoded, $response) = $self->use_url('put', "/admin/customers/set", { operation => "invite", 'customer_ids[]' => [map { $_->id } @customers] }, 1, "application/x-www-form-urlencoded");
	die  new WWW::Shopify::Exception("Unexpected Response.") unless $decoded->{message} =~ m/Invited (\d+) customer/;
	return $1;
}

sub get_activation_link {
	my ($self, $customer) = @_;
	my ($decoded, $reponse) = $self->use_url('get', "/admin/customers/" . $customer->id, { }, "text/html");
	die new WWW::Shopify::Exception("Unable to find activation link for " . $customer->id . ".") unless $decoded =~ m/http:\/\/[\w\.]+\/account\/activate\/\w+/;
	return $&;
}

sub get_reset_token {
	my ($self, $customer) = @_;
	my ($decoded, $reponse) = $self->use_url('get', "/admin/customers/" . $customer->id, { }, "text/html");
	die new WWW::Shopify::Exception("Unable to find activation link for " . $customer->id . ".") unless $decoded =~ m/http:\/\/[\w\.]+\/account\/activate\/(\w+)/;
	return $1;
}

sub send_activation_link {
	my ($self, $customer, $from, $subject, $body, $reset_token) = @_;
	my ($decoded, $response) = $self->use_url('post', "/admin/customers/" . $customer->id . "/invite", {
		utf => '✓',
		source => 'adminnext',
		'customer_invite_message[from]' => $from,
		'customer_invite_message[subject]' => $subject,
		'customer_invite_message[body]' => $body,
		'customer_invite_message[reset_token]' => $reset_token
	}, "application/x-www-form-urlencoded");
}

1;