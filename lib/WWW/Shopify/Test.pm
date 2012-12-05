#!/usr/bin/perl

use strict;
use warnings;

=head1 NAME

WWW::Shopify::Test - A subclass of WWW::Shopify which represents a testing environment.

=cut

=head1 DESCRIPTION

A WWW::Shopify object that instead of making calls to a particular URL uses a database to represent an instance of a shopify store.

In addition to providing a method to access the database, the test subclass also provides a method to generate entries in the database for testing purposes using the generate method.

=cut

=head1 EXAMPLES

Should be used as L<WWW::Shopify> as a normal store. Prior to doing this, the object must be 'associated' with a particular store on our fake database.

It can be done like the following:

	my $db = WWW::Shopify::Model::DBIx::Schema->connect('dbi:SQLite:dbname=' . tmpnam(), { RaiseError => 1, AutoCommit => 1 });
	$db->generate([WWW::Shopify::Model::Shop]);
	my $sa = new WWW::Shopify::Test($db);
	$sa->associate_randomly();

=cut

=head1 METHODS

A bunch of methods are unique to the WWW::Shopify::Test, and not part of the normal WWW::Shopify, namely the associate methods and the generate method; they are listed here.

=cut

use WWW::Shopify;
use WWW::Shopify::Common::DBIx;
use DateTime;
use WWW::Shopify::Model::Product;

package WWW::Shopify::Test;
use parent 'WWW::Shopify';
use String::Random qw(random_regex random_string);
use Data::Random;
use List::Util qw(shuffle first);

sub new($$) {
	my ($package, $dbschema) = @_;
	return bless {
		_db => $dbschema,
		_associatedShop => undef,
		_mapper => new WWW::Shopify::Common::DBIx()
	}, $package;
}

=head2 ASSOCIATION METHODS

=head3 associate

Takes in a Model::DBIx::Model::Shop. Associate this object with the shop, meaning that every call you make on this object will target that particular shop.

This must be called (directly or indirectly) before any calls can be made to the shop.

=cut

sub associate($$) {
	my $self = $_[0];
	if (defined $_[1]) {
		my $shop = $_[1];
		die ref($shop) unless ref($shop) =~ m/Model::.*Shop$/;
		$self->{_associatedShop} = $shop;
	}
	return $self->{_associatedShop};
}

=head3 associate_randomly

Calls associate with a random shop from the database.

=cut

sub associate_randomly {
	my $self = $_[0];
	my @shops = $self->{_db}->resultset('Model::Shop')->all();
	die new WWW::Shopify::Exception("Unable to associate randomly; no shops present.") unless int(@shops) > 0;
	return $self->associate($shops[rand(int(@shops))]);
}

=head3 associate_unlinked

Calls associate with a shop that is NOT in the list of urls that you pass into this function.

	$SA->associateUnlinked(['hostname1', 'hostname2']);

=cut

sub associate_unlinked($$) {
	my ($self, $ids) = @_;
	my @shops = $self->{_db}->resultset('Model::Shop')->search( { myshopify_domain => { 'NOT IN' => $ids } } )->all();
	die new WWW::Shopify::Exception("Unable to associate unlinked; no unlinked shops.") unless int(@shops) > 0;
	return $self->associate($shops[rand(int(@shops))]);
}

=head3 associate_unlinked

Calls associate with a shop that is in the list of urls that you pass in to this function.

	$SA->associateLinked(['hostname1', 'hostname2']);

=cut

# Associates with a paricular shop that IS part of the app.
sub associate_linked($$$) {
	my ($self, $ids) = @_;
	my $condition = map { { myshopify_domain => $_ } }  @$ids;
	my @shops = $self->{_db}->resultset('Model::Shop')->search( { myshopify_domain => { 'IN' => $ids } } )->all();
	die new WWW::Shopify::Exception("Unable to associate linked; no linked shops.") unless int(@shops) > 0;
	return $self->associate($shops[rand(int(@shops))]);
}

sub get_url($$@) { die new WWW::Shopify::Exception("Can't use URL methods on the test object."); }
sub post_url($$@) { die new WWW::Shopify::Exception("Can't use URL methods on the test object."); }
sub put_url($$@) {  die new WWW::Shopify::Exception("Can't use URL methods on the test object."); }
sub delete_url($$@) {  die new WWW::Shopify::Exception("Can't use URL methods on the test object."); }

=head2 GENERATION METHODS

As of now, there's only one generation function. These functions generate objects for the underlying database.

=cut

=head3 generate

The generate method. Generates a whole ton of stuff for your database. Doesn't have to be associate with a shop; generates shops as well.

Essentially, what you want to do when you call this is pass in a list of class names (WWW::Shopify::Model:: style, not the DBIx ones) in an array, and this funciton will generate them, and if necessary their dependencies.

It'll generate 50*(:: count - 2)^2 of the class (so WWW::Shopify::Model::Product'll get 50, but there'll be 200 WWW::Shopify::Model::Product::Variants)

WWW::Shopify::Model::Shop is a special case, that's set to 6, basically for lulz.

Calls go like so:

	$SA->generate(['WWW::Shopify::Model::Shop', 'WWW::Shopify::Model::Product']);

Note, this can take a while, depending on the speed of your computer/virtual machine. Once it's finished, you should have a nice little database full of bogus data of the proper type.

=cut

sub generate($$) {
	my ($self, $generatables, $parameters) = @_;

	my $generatedIds = {};
	my $shopMap = {};
	for (@$generatables) { $generatedIds->{$_} = []; }

	my $shops = [];

	foreach my $class (@$generatables) {
		$self->generate_class($class, $generatedIds, $parameters, $shops, $shopMap);
	}

	sub generate_class {
		my ($self, $class, $generatedIds, $parameters, $shops, $shopMap) = @_;
		print "Generating $class...\n";
		# If we've already generated some, don't generate more; this way we avoid dependency stuff.
		return if int(@{$generatedIds->{$class}}) > 0;

		my $fields = $class->fields();
		sub square { return $_[0]*$_[0]; }
		my $amount = 50 * square(int(split(/::/, $class))-3);
		my @parentIds = ();
		@parentIds = @{$generatedIds->{$class->parent()}} if (defined $class->parent());
		if (defined $parameters->{$class}) {
			$amount = $parameters->{$class};
		}
		elsif ($class =~ m/Model::.*Shop$/) {
			# Why not?
			$amount = 6;
		}
		for (my $c = 0; $c < $amount; ++$c) {
			my $creation = {};
			my $id = undef;
			foreach my $field (keys(%$fields)) {
				if ($fields->{$field}->is_relation()) {
					my $package = $fields->{$field}->relation();
					# We only need to do the RELATION_ONE relaitons, because MANY is taken care of by parent ids when THAT class is generated.
					if ($fields->{$field}->is_own() || $fields->{$field}->is_reference()) {
						# We need to generate the ids for the particular pacakge we're linking to, so recall this function with the new class.
						if (!exists $generatedIds->{$package} || int($generatedIds->{$package}) == 0) {
							$generatedIds->{$package} = [];
							$self->generate_class($package, $generatedIds, $parameters, $shops);
						}
						if ($fields->{$field}->is_own()) {
							my $foreignid = $generatedIds->{$package}->[rand(@{$generatedIds->{$package}})];
							$creation->{$field} = $foreignid;
						}
						elsif ($fields->{$field}->is_reference()) {
							my $foreignid = $generatedIds->{$package}->[rand(@{$generatedIds->{$package}})];
							# We ensure that each container object that has children gets at least one child. For now.
							if ($class->parent() && $fields->{$field}->relation() eq $class->parent() && int(@parentIds) > 0) {
								$foreignid = pop(@parentIds);
							}
							$creation->{$field} = $foreignid;
						}
					}
					
				}
				else {
					my $generated = $fields->{$field}->generate();
					$creation->{$field} = $generated;
				}
				if ($field eq $class->identifier()) {
					$id = $creation->{$field};
					push(@{$generatedIds->{$class}}, $id);
				}
			}
			my $parent = $class->parent();
			if (defined $parent) {
				$creation->{shop_id} = $shopMap->{$parent}->{$id};
				my $parent_variable = WWW::Shopify::Common::DBIx::transform_package($class)->parent_variable();
				die "$parent -> $class: $parent_variable" unless defined $parent_variable;
				# This occurs when we have an auto-generated "parent_id" variable (as it's not part of the fields)
				if (!defined $creation->{$parent_variable}) {
					my $foreignid = $generatedIds->{$parent}->[rand(@{$generatedIds->{$parent}})];
					# We ensure that each container object that has children gets at least one child. For now.
					$foreignid = pop(@parentIds) if (int(@parentIds) > 0);
					$creation->{$parent_variable} = $foreignid;
				}
				$creation->{shop_id} = $shopMap->{$parent}->{$creation->{$parent_variable}};
			}
			elsif ($class !~ m/^WWW::Shopify::.*Shop$/) {
				die "Need to generate shops before $class." unless int(@$shops) > 0;
				$creation->{shop_id} = $shops->[int(rand(int(@$shops)))]->id();
			}
			$shopMap->{$class}->{$id} = $creation->{shop_id};
			die "Unable to properly parse $class." unless $class =~ m/(Model::.*)$/;
			my $dbo = $self->{_db}->resultset($1)->create($creation);
			push(@$shops, $dbo) if ($class =~ m/^WWW::Shopify::.*Shop$/); 
		}
	}

	return $self;
}

sub transform_name($) {
	die "Improperly formatted package: " . $_[0] unless $_[0] =~ /WWW::Shopify::(.+)/;
	return $1;
}

sub get_all_limit($$@) {
	my ($self, $package, $specs) = @_;
	die new WWW::Shopify::Exception("WWW::Shopify::Test object not associated with shop. Call associate.") unless $self->associate();
	$self->validate_item($package);

	my @return = $self->{_db}->resultset(transform_name($package))->search({ shop_id => $self->associate()->id() })->all();
	splice(@return, WWW::Shopify->PULLING_ITEM_LIMIT) if (int(@return) > WWW::Shopify->PULLING_ITEM_LIMIT);
	return map { $self->{_mapper}->to_shopify($_); } @return;
}

sub get_all($$@) {
	my ($self, $package, $specs) = @_;
	die new WWW::Shopify::Exception("WWW::Shopify::Test object not associated with shop. Call associate.") unless $self->associate();
	$self->validate_item($package);
	return $self->get_all_limit($package, $specs) if (exists $specs->{"limit"} && $specs->{"limit"} <= WWW::Shopify->PULLING_ITEM_LIMIT);
	if ($package->countable()) {
		my $itemCount = $self->get_count($package, $specs);
		return $self->get_all_limit($package, $specs) if ($itemCount <= WWW::Shopify->PULLING_ITEM_LIMIT);
		die new WWW::Shopify::Exception("OVER LIMIT GET; NOT IMPLEMENTED.") if $itemCount > WWW::Shopify->PULLING_ITEM_LIMIT;
	}
	else {
		return $self->get_all_limit($package, $specs);
	}
}

sub get_shop($) {
	my ($self) = @_;
	die new WWW::Shopify::Exception("WWW::Shopify::Test object not associated with shop. Call associate.") unless $self->associate();
	return $self->{_mapper}->to_shopify($self->associate());
}

sub get_count($$@) {
	my ($self, $package, $specs) = @_;
	die new WWW::Shopify::Exception("WWW::Shopify::Test object not associated with shop. Call associate.") unless $self->associate();
	$self->validate_item($package);
	return $self->{_db}->resultset(transform_name($package))->search({ shop_id => $self->associate()->id() })->count();
}

sub get($$$@) {
	my ($self, $package, $id, $specs) = @_;
	die new WWW::Shopify::Exception("WWW::Shopify::Test object not associated with shop. Call associate.") unless $self->associate();
	$self->validate_item($package);
	my $row = $self->{_db}->resultset(transform_name($package))->search({ shop_id => $self->associate()->id() })->find($id);
	return $self->{_mapper}->to_shopify($row);
}

# Fields that should be filled in by 'shopify'.
sub post_creation_fields($$) {
	my ($self, $item, $specs) = @_;
	my $package = ref($item);
	if ($package eq "WWW::Shopify::Model::RecurringApplicationCharge" || $package eq "WWW::Shopify::Model::ApplicationCharge") {
		$specs->{status} = "pending";
	}
}

sub create($$@) {
	my ($self, $item) = @_;
	die new WWW::Shopify::Exception("WWW::Shopify::Test object not associated with shop. Call associate.") unless $self->associate();
	$self->validate_item(ref($item));
	my $package = ref($item);
	my $specs = {};
	for (@{$item->minimal()}) {
		die "Missing minimal creation member $_." unless defined $item->{$_};
	}
	for (keys(%$item)) {
		$specs->{$_} = $item->{$_};
	}
	
	my $fields = $package->fields();
	# So, if we have a field called id, we generate it.
	if (exists $fields->{id} && !exists $specs->{id}) {
		while (1) {
			$specs->{id} = int(rand(10000000));
			my $item = $self->{_db}->resultset(transform_name($package))->find($specs->{id});
			last unless defined $item;
		}
	}
	for (keys(%$fields)) {
		if ($_ ne "id" && $fields->{$_}->is_qualifier() && $fields->{$_}->qualifier() eq "on_create") {
			$specs->{$_} = $fields->{$_}->generate();
		}
	}
	# We're also going to have to generate a bunch of fields.
	if (exists $fields->{confirmation_url}) {
		$specs->{confirmation_url} = $fields->{confirmation_url}->generate();
	}
	$specs->{shop_id} = $self->associate()->id();
	$self->post_creation_fields($item, $specs);

	my $object = $self->{_db}->resultset(transform_name($package))->create($specs);
	return $self->{_mapper}->to_shopify($object);
}

sub update {
	my ($self, $item) = @_;
	die new WWW::Shopify::Exception("WWW::Shopify::Test object not associated with shop. Call associate.") unless $self->associate();
	$self->validate_item(ref($item));
	$item->update;
	return $self->{_mapper}->to_shopify($item);
}

sub delete {
	my ($self, $class) = @_;
	die new WWW::Shopify::Exception("WWW::Shopify::Test object not associated with shop. Call associate.") unless $self->associate();
	$self->validate_item(ref($class));
	die new WWW::Shopify::Exception("Class in deletion must be not null, and must be a blessed reference to a model object: " . ref($class)) unless ref($class) =~ m/Model/;

	$self->{_db}->resultset(transform_name(ref($class)))->search({ id => $class->id() })->delete;

	return 1;
}

# This function is solely for charges.
sub activate {
	my ($self, $class) = @_;
	die new WWW::Shopify::Exception("Only charges can be activated.") unless defined $class && ref($class) =~ m/WWW::Shopify(.*?)ApplicationCharge/;
	$self->validate_item(ref($class));

	my $object = $self->{_db}->resultset(transform_name(ref($class)))->find({ id => $class->id() });
	die new WWW::Shopify::Exception("Unable to find charge with id: " . $object->id()) unless defined $object;
	$object->status("activated");
	$object->update;

	return $self->{_mapper}->to_shopify($object);
}

=head1 SEE ALSO

L<WWW::Shopify>

=head1 AUTHOR

Adam Harrison

=head1 LICENSE

See LICENSE in the main directory.

=cut


1;
