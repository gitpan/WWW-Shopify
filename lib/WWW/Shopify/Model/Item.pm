#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

package WWW::Shopify::Model::Item;
use DateTime;

=head1 NAME

Item - Main superclass for all the shopify objects.

=cut

=head1 DESCRIPTION

Class that basically holds a bunch of convenience methods that provide. All items, with the exception of L<WWW::Shopify::Model::Shop> work pretty much in the same way,as detailed below.

=cut

=head1 METHODS

=over 1

=item stats()

Returns a hash of all variables and their types that are given by shopify, and should not be modified. Stuff like created_at, etc..

=cut

=item mods()

Returns a hash of all variables and their types that are given by shopify, that can be modified, and will be passed in any update request.

=cut

=item minimal()

Returns an array of variables that must be passed in during the creation of the object.

=cut

=back

=cut

=head1 USAGE

When you have a top level class (see the list in the SEE ALSO section below), you can perform the following operations on it, via a WWW::Shopify object.

getAll - Gets all objects of this type in the store.

	my @Variants = $WWW::Shopify->getAll('WWW::Shopify::Model::Variant', {});

get - Gets an object with the specified ID.

	my $Product = $WWW::Shopify->get('WWW::Shopify::Model::Product', 324234);

create - Creates the object that's passed in, on the Shopify store. Note that we pass in the hash all the necessary fields as required by L<WWW::Shopify::Model::Product>'s minimal() method.

	my $Product = new WWW::Shopify::Model::Product({title => "My new Product", product_type => "Nice Product", vendor => "Our Shopify Store"});

delete - Deletes the shopify object that's passed in.

	my $Product = ....
	$WWW::Shopify->delete($Product);

update - Updates the shopify object that's pass in.

	my $Product = $WWW::Shopify->get('WWW::Shopify::Model::Product', 312443);
	$Product->vendor("A new vendor");
	$WWW::Shopify->update($Product);

=cut

sub new { my $self = (defined $_[1]) ? $_[1] : {}; return bless $self, $_[0]; }
sub parent { return undef; }
sub is_item { return 1; }
# Returns the singular form of the object. Usually the name of the file.
# Is like this, because we want to be able to call this on the package as well as an object in it.
sub singular {
	# If we have a package instead of an instantiated object.
	if (!ref($_[0])) {
		die $_[0] unless $_[0] =~ m/(\:\:)?(\w+)$/;
		my $name = $2;
		$name =~ s/([a-z])([A-Z])/$1_$2/g;
		return (lc $name);
	}
	# Here, we have an object, so run this function again with the package name.
	return singular(ref($_[0]));
}
# Specifies in a text-friendly manner the FULL specific name of this package.
sub singular_fully_qualified { 
	if (!ref($_[0])) {
		die $_[0] unless $_[0] =~ m/Model::([:\w]+)$/;
		my $name = lc($1);
		$name =~ s/\:\:/-/g;
		return $name;
	}
	# Here, we have an object, so run this function again with the package name.
	return singular_fully_qualified(ref($_[0]));
}
sub plural { return $_[0]->singular() . "s"; }
sub container { return $_[0]->parent; }

# I cannot fucking believe I'm doing this. Everything can be counted.
# Oh, except themes. We don't count those. For some arbitrary reason.
sub countable { return 1; }
sub needs_login { return undef; }

sub stats() { return {}; }
sub mods() { return {}; }
sub is_nested() { return undef; }

sub identifier($) { return "id"; }

sub creatable($) { return 1; }
sub updatable($) { return 1; }
sub deletable($) { return 1; }
sub activatable($) { return undef; }

sub get_all { my $package = shift; my $SA = shift; my $specs = shift; return $SA->getAll($package, $specs); }
sub get_count { my $package = shift; my $SA = shift; return $SA->typicalGetCount($package, shift); }
sub fields { my $package = shift; my $returnHash = {}; %$returnHash = (%{$package->mods()}, %{$package->stats()}); return $returnHash; }

sub from_json($$) {
	my ($package, $json) = @_;

	my $mods = $package->mods();
	my $stats = $package->stats();

	sub decodeForRef { 
		my ($self, $json, $ref) = @_;
		for (keys(%{$ref})) {
			if ($ref->{$_}->is_relation()) {
				my $package = $ref->{$_}->relation();
				if ($ref->{$_}->is_many()) {
					$self->{$_} = [];
					foreach my $object (@{$json->{$package->plural()}}) {
						my $child = $package->from_json($object);
						$child->{"parent"} = $self;
						push(@{$self->{$_}}, $child);
					}
				}
				elsif ($ref->{$_}->is_one()) {
					$self->{$_} = $json->{$_};
				}
				else {
					die "Relationship specified must be either RELATION_REF_ONE, RELATION_OWN_ONE or RELATION_MANY in $package.";
				}
			}
			else {
				if (ref($ref->{$_}) eq "WWW::Shopify::Field::Date" && $json->{$_}) {
					if ($json->{$_} =~ m/(\d+)-(\d+)-(\d+)T(\d+):(\d+):(\d+)([+-]\d+):(\d+)/) {
						$self->{$_} = DateTime->new(
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
						die new WWW::Shopify::Exception("Unable to parse date " . $json->{$_}) unless $json->{$_} =~ m/(\d+)-(\d+)-(\d+)/;
						$self->{$_} = DateTime->new(
							year      => $1,
							month     => $2,
							day       => $3
						);
					}
				}
				else {
					$self->{$_} = $json->{$_};
				}
			}
		}
	}

	my $self = $package->new();

	$self->decodeForRef($json, $mods);
	$self->decodeForRef($json, $stats);
	return $self;
}

sub to_json($) {
	my ($self) = @_;
	my $fields = $self->fields();
	my $final = {};
	foreach my $key (keys(%$fields)) {
		if ($fields->{$key}->is_relation()) {
			if ($fields->{$key}->is_many()) {
				if (defined $self->$key()) {
					$final->{$key} = [map { $_->to_json() } (@{$self->$key()})];
				}
				else {
					$final->{$key} = [];
				}
			}
			if ($fields->{$key}->is_one() && $fields->{$key}->is_reference()) {
				if (defined $self->$key()) {
					# This is inconsistent; this if is a stop-gap measure.
					# Getting directly from teh database seems to make this automatically an id.
					if (ref($self->$key())) {
						$final->{$key} = $self->$key()->id();
					}
					else {
						$final->{$key} = $self->$key();
					}
				}
				else {
					$final->{$key} = undef;
				}
			}
			$final->{$key} = $self->$key()->to_json() if ($fields->{$key}->is_one() && $fields->{$key}->is_own());
		}
		else {
			$final->{$key} = $self->$key();
			if ($final->{$key} && ref($final->{$key}) eq "DateTime") {
				$final->{$key} = $final->{$key}->strftime('%Y-%m-%dT%H-%M-%S%z');
				$final->{$key} =~ s/(\d\d)$/:$1/;
			}
		}
	}
	return $final;
}

sub generate_accessors($) {
	my $eval = "";
	for (keys(%{$_[0]->stats()})) {
		$eval .= "sub $_ {return \$_[0]->{$_};} ";
	}
	for (keys(%{$_[0]->mods()})) {
		$eval .= "sub $_ { \$_[0]->{$_} = \$_[1] if defined \$_[1]; return \$_[0]->{$_};} ";
	}
	return $eval;
}


=head1 SEE ALSO

L<WWW::Shopify::Model::Product>, L<WWW::Shopify::Model::Webhook>, L<WWW::Shopify::Model::Variant>

=head1 AUTHOR

Adam Harrison

=head1 LICENSE

See LICENSE in the main directory.

=cut

1
