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

	my @Products = $SA->getAll('Product');

get - Gets an object with the specified ID.

	my $Product = $SA->get('Product', 324234);

create - Creates the object that's passed in, on the Shopify store. Note that we pass in the hash all the necessary fields as required by L<WWW::Shopify::Model::Product>'s minimal() method.

	my $Product = $SA->create(new WWW::Shopify::Model::Product({title => "My new Product", product_type => "Nice Product", vendor => "Our Shopify Store"}));

delete - Deletes the shopify object that's passed in.

	my $Product = $SA->get('Product', 312443);
	$SA->delete($Product);

update - Updates the shopify object that's pass in.

	my $Product = $SA->get('Product', 312443);
	$Product->vendor("A new vendor");
	$SA->update($Product);

=cut

use Exporter 'import';
our @EXPORT = qw(generate_accessor);

sub new { my $self = (defined $_[1]) ? $_[1] : {}; return bless $self, $_[0]; }
sub parent { return undef; }
sub is_item { return 1; }
sub is_shop { return undef; }
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

# I cannot fucking believe I'm doing this. Everything can be counted.
# Oh, except themes. We don't count those. For some arbitrary reason.
sub countable { return 1; }
sub needs_login { return undef; }

# List of fields that should be filled automatically on creation.
sub is_nested { return undef; }
sub identifier { return "id"; }

sub creatable { return 1; }
sub updatable { return int($_[0]->update_fields) > 0; }
sub deletable { return 1; }
sub activatable { return undef; }
sub searchable { return undef; }
sub cancellable { return undef; }

# I CANNOT FUCKING BELIEVE I AM DOING THIS; WHAT THE FUCK SHOPIFY. WHY!? WHY MAKE IT DIFFERENT ARBITRARILY!?
sub create_method { return "POST"; }
sub update_method { return "PUT"; }
sub delete_method { return "DELETE"; }

sub creation_minimal { return (); }
sub creation_filled { return qw(id); }
sub update_fields { return qw(); }
sub update_filled { return qw(); }

# Oh fucking WOW. WHAT THE FUCK. Variants, of course, delete directly with their id, and modify with it.
# Metafields delete with their id, but modify through their parent. They also get through their parents.
# Variants of course, get through their id directly. I'm at a loss for words. Why!? Article are different, yet again.
sub get_through_parent { return defined $_[0]->parent; }
sub create_through_parent { return defined $_[0]->parent; }
sub update_through_parent { return defined $_[0]->parent; } 
sub delete_through_parent { return defined $_[0]->parent; }

sub associate { $_[0]->{associated_sa} = $_[1] if $_[1]; return $_[0]->{associated_sa}; }
sub associated_parent { $_[0]->{associated_parent} = $_[1] if $_[1]; return $_[0]->{assocated_parent}; }

sub create { 
	my $sa = $_[0]->associate;
	die new WWW::Shopify::Exception("You cannot call create on an unassociated item.") unless $sa;
	return $sa->create($_[0]);
}
sub update { 
	my $sa = $_[0]->associate;
	die new WWW::Shopify::Exception("You cannot call update on an unassociated item.") unless $sa;
	return $sa->update($_[0]);
}
sub delete { 
	my $sa = $_[0]->associate;
	die new WWW::Shopify::Exception("You cannot call delete on an unassociated item.") unless $sa;
	return $sa->delete($_[0]);
}
sub activate {
	my $sa = $_[0]->associate;
	die new WWW::Shopify::Exception("You cannot call activate on an unassociated item.") unless $sa;
	return $sa->activate($_[0]);
}

sub metafields {
	my $sa = $_[0]->associate;
	die new WWW::Shopify::Exception("You cannot call metafields on an unassociated item.") unless $sa;
	if (!defined $_[0]->{metafields}) {
		$_[0]->{metafields} = [$sa->get_all('Metafield', { parent => $_[0]->id, parent_container => $_[0] })];
	}
	return $_[0]->{metafields} unless wantarray;
	return @{$_[0]->{metafields}};
}

sub add_metafield {
	my ($self, $metafield) = @_; 
	my $sa = $_[0]->associate;
	die new WWW::Shopify::Exception("You cannot add metafields on an unassociated item.") unless $sa;
	$metafield->associated_parent($self);
	return $sa->create($metafield);
}

sub get_all { my $package = shift; my $SA = shift; my $specs = shift; return $SA->getAll($package, $specs); }
sub get_count { my $package = shift; my $SA = shift; return $SA->typicalGetCount($package, shift); }
sub field { my ($package, $name) = @_; return $package->fields->{$name}; }

# Should modify these to use the date methods in Field.
sub from_json($$) {
	my ($package, $json) = @_;
	
	sub decodeForRef { 
		my ($self, $json, $ref) = @_;
		for (keys(%{$ref})) {
			if ($ref->{$_}->is_relation()) {
				my $package = $ref->{$_}->relation();
				if ($ref->{$_}->is_many()) {
					next unless exists $json->{$package->plural()};
					$self->{$_} = [map { my $o = $package->from_json($_); $o->associate_parent($self); $o } @{$json->{$package->plural()}}];
				}
				elsif ($ref->{$_}->is_one()) {
					$self->{$_} = $json->{$_};
				}
				else {
					die "Relationship specified must be either many, or one in $package.";
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

	$self->decodeForRef($json, $self->fields);
	return $self;
}

sub to_json($) {
	my ($self) = @_;
	my $fields = $self->fields();
	my $final = {};
	foreach my $key (keys(%$self)) {
		next unless exists $fields->{$key};
		if ($fields->{$key}->is_relation()) {
			if ($fields->{$key}->is_many()) {
				# Since metafields don't come prepackaged.
				next unless ref($fields->{$key}) =~ m/Metafield/;
				my $result = $self->$key();
				if (defined $result) {
					$final->{$key} = [map { $_->to_json() } (@$result)];
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
				$final->{$key} = $final->{$key}->strftime('%Y-%m-%dT%H:%M:%S%z');
				$final->{$key} =~ s/(\d\d)$/:$1/;
			}
		}
	}
	return $final;
}

sub generate_accessors {
	return join("\n", 
		(map { "__PACKAGE__->fields->{$_}->name('$_');" } keys(%{$_[0]->fields})),
		(map { "sub $_ { \$_[0]->{$_} = \$_[1] if defined \$_[1]; return \$_[0]->{$_};}" } grep { $_ ne "metafields" } keys(%{$_[0]->fields}))
	); 
}

=head1 SEE ALSO

L<WWW::Shopify::Model::Product>, L<WWW::Shopify::Model::Webhook>, L<WWW::Shopify::Model::Product::Variant>

=head1 AUTHOR

Adam Harrison

=head1 LICENSE

See LICENSE in the main directory.

=cut

1
