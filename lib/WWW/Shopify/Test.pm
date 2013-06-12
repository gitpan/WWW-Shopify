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

package WWW::Shopify::Test;
use parent 'WWW::Shopify';
use String::Random qw(random_regex random_string);
use Data::Random;
use List::Util qw(shuffle first);

use Module::Find;
# Make sure we include all our models so that when people call the model, we actually know what they're talking about.
BEGIN {	eval(join("\n", map { "require $_;" } findallmod WWW::Shopify::Model)); die $@ if $@; }


sub new($$) {
	my ($package, $dbschema, $shop) = @_;
	my $self = bless {
		_db => $dbschema,
		_associatedShop => undef,
		_mapper => new WWW::Shopify::Common::DBIx(),
		_callback => undef
	}, $package;
	$self->associate($shop) if $shop;
	return $self;
}

sub callback { $_[0]->{_callback} = $_[1] if defined $_[1]; return $_[0]->{_callback}; }

=head2 ASSOCIATION METHODS

=head3 associate

Takes in a Model::DBIx::Model::Shop. Associate this object with the shop, meaning that every call you make on this object will target that particular shop.

This must be called (directly or indirectly) before any calls can be made to the shop.

=cut

sub associate($$) {
	my $self = $_[0];
	if (defined $_[1]) {
		my $shop = $_[1];
		if (ref($shop)) {
			die ref($shop) unless ref($shop) =~ m/Model::.*Shop$/;
			$self->{_associatedShop} = $shop;
		}
		else {
			$self->associate($self->{_db}->resultset('Model::Shop')->find({myshopify_domain => $shop}));
			die new WWW::Shopify::Exception("Can't find shop $shop to associate with.") unless $self->associate;
		}
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

	$SA->associate_unlinked('hostname1', 'hostname2');

=cut

sub associate_unlinked {
	my ($self, @ids) = @_;
	my @shops = $self->{_db}->resultset('Model::Shop')->search( { myshopify_domain => { 'NOT IN' => [@ids] } } )->all();
	die new WWW::Shopify::Exception("Unable to associate unlinked; no unlinked shops.") unless int(@shops) > 0;
	return $self->associate($shops[rand(int(@shops))]);
}

=head3 associate_linked

Calls associate with a shop that is in the list of urls that you pass in to this function.

	$SA->associate_linked('hostname1', 'hostname2');

=cut

# Associates with a paricular shop that IS part of the app.
sub associate_linked {
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

sub get_class {
	my ($self, $parent, $package, $ids) = @_;
	
}

use List::Util qw(shuffle);
sub generate_class {
	my ($self, $package, $ids, $parent, $restrictions) = @_;
	$ids = {} unless defined $ids;

	print STDERR "Generating $package...\n";
	my $fields = $package->fields;
	my $object = $self->{_db}->resultset(transform_name($package))->new({});
	# Simple fields.
	foreach my $field (grep { !$_->is_relation } values(%$fields)) {
		my $name = $field->name;
		$object->$name($field->generate());
	}
	$ids->{$package} = [] unless defined $ids->{$package};

	my $identifier = $package->identifier;
	if ($identifier eq "id" && $restrictions) {
		my $tentative;
		my %present = map { $_ => 1 } @{$ids->{$package}};
		do {
			$tentative = int(rand($restrictions->[1] - $restrictions->[0])) + $restrictions->[0];
		} while (exists $present{$tentative});
		$object->$identifier($tentative);
	}
	my $id = $object->$identifier;
	push(@{$ids->{$package}}, $id);
	# Set parent ID.
	my $parent_variable = $object->parent_variable;
	$object->$parent_variable($parent->id) if $parent_variable && ref($parent) !~ m/Shop$/;

	# If we're not a shop and we don't have a parent, we have a shop_id field.
	if ($package->has_shop_field) {
		die new WWW::Shopify::Exception("Everything not a shop requires a parent.") unless $parent;
		$object->shop_id((ref($parent) !~ m/Shop$/) ? $parent->shop_id : $parent->id);
	}

	# Simpler relationships.
	foreach my $field (grep { $_->is_relation && !$_->is_parent } values(%$fields)) {
		my $relation = $field->relation;
		if ($field->is_db_belongs_to && $field->db_rand_count > 0) {
			my $belongs_to;
			$self->generate_class($relation, $ids, $parent, $restrictions) unless ($ids->{$relation});
			$belongs_to = $ids->{$relation}->[rand(int(@{$ids->{$relation}}))];
			my $field_name = $field->name;
			$field_name .= "_id" unless $field_name =~ m/_id$/;
			$object->$field_name($belongs_to);
		}
		elsif ($field->is_db_has_one && $field->db_rand_count > 0) {
			$self->generate_class($relation, $ids, $object, $restrictions);
		}
		elsif ($field->is_db_has_many) {
			my $many_count = $field->db_rand_count;
			for (my $c = 0; $c < $many_count; ++$c) {
				$self->generate_class($relation, $ids, $object, $restrictions);
			}
		}
	}
	$object = $object->insert;
	# Many-Many
	foreach my $field (grep { $_->is_relation && $_->is_db_many_many } values(%$fields)) {
		my $relation = $field->relation;
		next if $relation =~ m/Metafield/i;
		my $accessor = "add_to_" . $field->name . "_hasmany";
		if (defined $ids->{$relation}) {
			my $many_count = $field->db_rand_count;
			for (my $c = 0; $c < $many_count; ++$c) {
				$self->generate_class($relation, $ids, $parent, $restrictions);
			}
		}
		my @shuffled = shuffle(@{$ids->{$relation}});

		$object->$accessor({
			$package->singular . "_id" => $id,
			$relation->singular . "_id" => $_
		}) for (grep { defined $_ } @shuffled[0..rand(5)]);
	}
	return $object;
}

use Sys::CPU;
use threads;
my $internal_range = 1000000;
use List::Util qw(min);
use List::MoreUtils qw(part);
sub generate {
	my ($self, %items) = @_;
	# 0 is auto-pick. Each is on a per-item basis.
	# Take at least 5 shops.
	my $shop_count = $items{'WWW::Shopify::Model::Shop'};
	$shop_count = 5 unless defined $shop_count;
	my $cpu_count = min(Sys::CPU::cpu_count(), $shop_count);
	$cpu_count = min($ENV{'CPU'}, $cpu_count) if $ENV{'CPU'};
	$cpu_count = 1 unless $ENV{'CPU'};
	print STDERR "Beginning generation of $shop_count shops on $cpu_count threads...\n";
	my $i = 0;
	my @partitions = part { $i++ % $cpu_count } 1..$shop_count;
	sub generate_thread {
		my ($self, $partitions, $items) = @_;
		foreach my $initial_range (@$partitions) {
			my $min_range = $initial_range * $internal_range;
			my $max_range = ($initial_range+1) * $internal_range;

			print STDERR "====== GENERATING SHOP =======\n";
			my %ids = ();
			my $shop = $self->generate_class('WWW::Shopify::Model::Shop', \%ids);
			%ids = ();
			my %counts = map { $_ => $items->{$_} } grep { $_ !~ m/Shop$/ } keys(%$items);

			while (int(keys(%counts)) > 0) {
				foreach my $item (keys(%counts)) {
					$self->generate_class($item, \%ids, $shop, [$min_range, $max_range]);
					delete $counts{$item} if (--$counts{$item} == 0);
				}
			}
			print STDERR "====== SHOP FINISHED =======\n";
		}
	}
	if ($cpu_count > 1) {
		my @threads = map { threads->create('generate_thread', $self, $partitions[$_], \%items) } (1..$cpu_count);
		$_->join() for (@threads);
	}
	else {
		generate_thread($self, $partitions[0], \%items);
	}
}

sub transform_name($) {
	die "Improperly formatted package: " . $_[0] unless $_[0] =~ /WWW::Shopify::(.+)/;
	return $1;
}

use WWW::Shopify::Query;
use List::Util qw(first);
sub generate_conditions {
	my ($self, $package, $specs, $rs) = @_;
	my %conditions = ();
	my $queries = $package->queries;
	foreach my $query (values(%$queries)) {
		next unless exists $specs->{$query->name};
		$conditions{$query->field_name} = {} unless exists $conditions{$query->field_name};
		my $value = $specs->{$query->name};
		$value = $self->{_db}->storage->datetime_parser->format_datetime($value) if ref($value) eq "DateTime";
		if (ref($query) =~ m/LowerBound$/) {
			$conditions{$query->field_name}->{'>='} = $value;
		}
		elsif (ref($query) =~ m/UpperBound$/) {
			$conditions{$query->field_name}->{'<='} = $value;
		}
		elsif (ref($query) =~ m/Enum$/) {
			$conditions{$query->field_name} = $value;
			die new WWW::Shopify::Exception("Can't specify $value for enum " . $query->name . ", must be one of the following: " .  join(", ", $query->enums)) unless
				first { $_ eq $value } $query->enums;
			delete $conditions{$query->field_name} if $value eq "any";
		}
		elsif (ref($query) =~ m/Match$/) {
			$conditions{$query->field_name} = $value;
		}
		elsif (ref($query) =~ m/Custom$/) {
			$rs = $query->routine->($rs, $value);
		}
		# We keep the conditions hash because of legacy reasons.
		$rs = $rs->search({%conditions});
	}
	return $rs;
}

sub filter_gettable {
	my ($self, $obj) = @_;
	my %fields = map { $_ => 1 } $obj->get_fields;
	my @keys = keys(%{$obj->fields});
	foreach my $key (@keys) {
		if (!$fields{$key}) {
			delete $obj->{$key};
		}
		elsif ($obj->{$key}) {
			if (ref($obj->{$key}) =~ m/WWW::Shopify::Model/) {
				$self->filter_gettable($obj->{$key});
			}
			elsif (ref($obj->{$key}) eq "ARRAY") {
				for (grep { $_ && ref($_) =~ m/WWW::Shopify::Model/ } @{$obj->{$key}}) {
					$self->filter_gettable($_);
				}
			}
			elsif (ref($obj->{$key}) eq "HASH") {
				for (grep { $_ && ref($_) =~ m/WWW::Shopify::Model/ } values(%{$obj->{$key}})) {
					$self->filter_gettable($_);
				}
			}
		}
	}
	return $obj;
}

sub get_all_limit {
	my ($self, $package, $specs) = @_;
	die new WWW::Shopify::Exception("WWW::Shopify::Test object not associated with shop. Call associate.") unless $self->associate();
	die new WWW::Shopify::Exception("Limit should always exist in here.") unless $specs->{limit};
	$package = $self->translate_model($package);
	$self->validate_item($package);	
	
	my @return;
	my $rs = undef;
	if ($package =~ m/Metafield/ && $specs->{parent}) {
		my $parent = $self->{_mapper}->from_shopify($self->{_db}, $specs->{parent}, $self->associate->id);
		$parent = $parent->contents;
		$rs = $parent->metafields->search({ 'me.shop_id' => $self->associate()->id() });
	}
	else {
		$rs = $self->{_db}->resultset(transform_name($package))->search({ 'me.shop_id' => $self->associate()->id() });
	}
	$rs = $self->generate_conditions($package, $specs, $rs);
	@return = $rs->all;
	splice(@return, $specs->{limit}) if (int(@return) > $specs->{limit});
	return map { my $obj = $self->{_mapper}->to_shopify($_); $obj->associate($self); $self->filter_gettable($obj) } @return;
}

sub get_all {
	my ($self, $package, $specs) = @_;
	die new WWW::Shopify::Exception("WWW::Shopify::Test object not associated with shop. Call associate.") unless $self->associate();
	$package = $self->translate_model($package);
	return $self->get_shop if $package eq "WWW::Shopify::Model::Shop";
	$self->validate_item($package);
	$specs->{"limit"} = WWW::Shopify->PULLING_ITEM_LIMIT unless exists $specs->{"limit"};
	return $self->get_all_limit($package, $specs) if ($specs->{"limit"} <= WWW::Shopify->PULLING_ITEM_LIMIT);
	if ($package->countable()) {
		my $itemCount = $self->get_count($package, $specs);
		return $self->get_all_limit($package, $specs) if ($itemCount <= WWW::Shopify->PULLING_ITEM_LIMIT);
		die new WWW::Shopify::Exception("OVER LIMIT GET; NOT IMPLEMENTED.") if $itemCount > WWW::Shopify->PULLING_ITEM_LIMIT;
	}
	else {
		return $self->get_all_limit($package, $specs);
	}
}

sub search {
	my ($self, $package, $specs) = @_;
	die new WWW::Shopify::Exception("WWW::Shopify::Test object not associated with shop. Call associate.") unless $self->associate();
	$package = $self->translate_model($package);
	die new WWW::Shopify::Exception("Unable to search $package; it is not marked as searchable in Shopify's API.") unless $package->searchable;
	die new WWW::Shopify::Exception("Must have a query to search.") unless $specs && $specs->{query};
	$self->validate_item($package);
	my @criteria = split(/\s+/, $specs->{query});
	my %values = map { my @inner = split(/:/, $_); $inner[0] => $inner[1] } @criteria;
	my @return = $self->{_db}->resultset(transform_name($package))->search({ 'me.shop_id' => $self->associate()->id(), map { $_ => { like => '%' . $values{$_} . '%' } } keys(%values) })->all();
	@return = map { my $obj = $self->{_mapper}->to_shopify($_); $obj->associate($self); $self->filter_gettable($obj) } @return;
	return @return if wantarray;
	return $return[0] if int(@return) > 0;
	return undef;
}

sub get_shop($) {
	my ($self) = @_;
	die new WWW::Shopify::Exception("WWW::Shopify::Test object not associated with shop. Call associate.") unless $self->associate();
	my $obj = $self->{_mapper}->to_shopify($self->associate());
	$obj->associate($self);
	return $self->filter_gettable($obj);
}

sub get_count {
	my ($self, $package, $specs) = @_;
	die new WWW::Shopify::Exception("WWW::Shopify::Test object not associated with shop. Call associate.") unless $self->associate();
	$package = $self->translate_model($package);
	$self->validate_item($package);

	my $rs = $self->{_db}->resultset(transform_name($package))->search({ 'me.shop_id' => $self->associate()->id() });
	return $self->generate_conditions($package, $specs, $rs)->count;
}

sub get {
	my ($self, $package, $id, $specs) = @_;
	die new WWW::Shopify::Exception("WWW::Shopify::Test object not associated with shop. Call associate.") unless $self->associate();
	$package = $self->translate_model($package);
	$self->validate_item($package);
	my $row = $self->{_db}->resultset(transform_name($package))->search({ 'me.shop_id' => $self->associate()->id() })->find($id);
	return undef unless $row;
	my $obj = $self->{_mapper}->to_shopify($row);
	$obj->associate($self) if $obj;
	return $self->filter_gettable($obj);
}

# Fields that should be filled in by 'shopify'.
sub post_creation_fields {
	my ($self, $item) = @_;
	if (ref($item) =~ m/ApplicationCharge/) {
		$item->status("pending");
		$item->confirmation_url("/mock/charge_activation/" . $item->id);
	}
	elsif (ref($item) =~ m/Discount/) {
		$item->status("enabled");
	}
}

sub create {
	my ($self, $item, $options) = @_;
	die new WWW::Shopify::Exception("WWW::Shopify::Test object not associated with shop. Call associate.") unless $self->associate();

	$self->validate_item(ref($item));
	my $package = ref($item);
	my @missing = grep { !defined $item->{$_} } $item->creation_minimal;
	die "Missing minimal creation member(s) " . join(", ", @missing) . "." if @missing;
	die new WWW::Shopify::Exception(ref($item) . " requires you to login with an admin account.") if $item->needs_login && !$self->logged_in_admin;

	my $dbixgroup = $self->{_mapper}->from_shopify($self->{_db}, $item);

	sub fill_creation {
		my $self = shift;
		my %chosen_ids = ();
		foreach my $item (@_) {
			my $fields = $item->represents->fields;
			my @fillable_on_creation = $item->represents->creation_filled;
			for (@fillable_on_creation) {
				# This will automatically be filled by add_to_ accessors.
				die new WWW::Shopify::Exception("Unable to generate field $_ in $item; doens't exist in fields.")  unless exists $fields->{$_};
				next if $fields->{$_}->is_relation() && $fields->{$_}->is_parent();
				die new WWW::Shopify::Exception("Unable to generate field $_ in $item; can't generate relations.") if $fields->{$_}->is_relation();
				$item->$_($fields->{$_}->generate());
			}
			if (exists $fields->{id}) {
				while (1) {
					my $id = int(rand(10000000));
					$item->id($id);
					my $test = $self->{_db}->resultset(transform_name($item->represents))->find($id);
					last unless defined $test && !exists $chosen_ids{$id};
				}
				$chosen_ids{$item->id} = 1;
			}
			$item->shop_id($self->associate->id);
			$self->post_creation_fields($item);
		}
	}
	fill_creation($self, $dbixgroup->nested);

	my $return;
	eval {
		if ($item->associated_parent && ref($item) =~ m/Metafield/) {
			my $dbname = ref($item->associated_parent);
			$dbname =~ s/WWW::Shopify:://;
			my $accessor = "add_to_" . $item->plural;
	
			my $parent = $self->{_db}->resultset($dbname)->find($item->associated_parent->id);
			die "Requires parent in database." unless $parent;
			my $json = $item->to_json;
			$json->{shop_id} = $self->associate->id;
			$parent->$accessor($json);
		}
		else {
			$dbixgroup->insert;
		}
		$return = $self->{_mapper}->to_shopify($dbixgroup->contents);
		$return->associate($self);
	};
	if ($@) {
		die new WWW::Shopify::Exception(new HTTP::Response(422, "$@"))
	}
	$self->callback->webhook($self->associate, $item, "create") if $self->callback && $item->throws_create_webhooks;
	return $return;
}

sub update {
	my ($self, $item) = @_;
	die new WWW::Shopify::Exception("WWW::Shopify::Test object not associated with shop. Call associate.") unless $self->associate();
	die new WWW::Shopify::Exception(ref($item) . " requires you to login with an admin account.") if $item->needs_login && !$self->logged_in_admin;
	$self->validate_item(ref($item));
	my $dbixgroup = $self->{_mapper}->from_shopify($self->{_db}, $item);
	$dbixgroup->update;
	my $obj = $self->{_mapper}->to_shopify($dbixgroup->contents);
	$obj->associate($self);
	$self->callback->webhook($self->associate, $item, "update") if $self->callback && $item->throws_update_webhooks;
	return $obj;
}

sub delete {
	my ($self, $item) = @_;
	die new WWW::Shopify::Exception("WWW::Shopify::Test object not associated with shop. Call associate.") unless $self->associate;
	die new WWW::Shopify::Exception(ref($item) . " requires you to login with an admin account.") if $item->needs_login && !$self->logged_in_admin;
	$self->validate_item(ref($item));
	die new WWW::Shopify::Exception("Class in deletion must be not null, and must be a blessed reference to a model object: " . ref($item)) unless ref($item) =~ m/Model/;

	my $dbixgroup = $self->{_mapper}->from_shopify($self->{_db}, $item);
	die new WWW::Shopify::Exception($item->singular . " with id " . $item->id . " does not exist.") unless $dbixgroup->contents->in_storage;

	if (ref($item) =~ m/ApplicationCharge/) {
		$dbixgroup->contents->status('cancelled');
		$dbixgroup->contents->update;
	}
	else {	
		$dbixgroup->delete;
	}
	$self->callback->webhook($self->associate, $item, "delete") if $self->callback && $item->throws_delete_webhooks;

	return 1;
}

# This function is solely for charges.
sub activate {
	my ($self, $class) = @_;
	die new WWW::Shopify::Exception("Only charges can be activated.") unless defined $class && $class->can_activate;
	$self->validate_item(ref($class));

	my $object = $self->{_db}->resultset(transform_name(ref($class)))->find({ id => $class->id() });
	die new WWW::Shopify::Exception("Unable to find charge with id: " . $object->id()) unless defined $object;
	$object->status("active");
	$object->update;

	my $obj = $self->{_mapper}->to_shopify($object);
	$obj->associate($self);
	return $obj;
}

sub disable {
	my ($self, $class) = @_;
	die new WWW::Shopify::Exception("You can only disable discount codes.") unless defined $class && $class->can_disable;
	die new WWW::Shopify::Exception(ref($class) . " requires you to login with an admin account.") if $class->needs_login && !$self->logged_in_admin;
	$self->validate_item(ref($class));

	my $object = $self->{_db}->resultset(transform_name(ref($class)))->find({ id => $class->id });
	die new WWW::Shopify::Exception("Unable to find discount code with id: " . $object->id) unless defined $object;
	$object->status("disabled");
	$object->update;

	my $obj = $self->{_mapper}->to_shopify($object);
	$obj->associate($self);
	return $obj;
}

sub enable {
	my ($self, $class) = @_;
	die new WWW::Shopify::Exception("You can only enable discount codes.") unless defined $class && $class->can_enable;
	die new WWW::Shopify::Exception(ref($class) . " requires you to login with an admin account.") if $class->needs_login && !$self->logged_in_admin;
	$self->validate_item(ref($class));

	my $object = $self->{_db}->resultset(transform_name(ref($class)))->find({ id => $class->id });
	die new WWW::Shopify::Exception("Unable to find discount code with id: " . $object->id) unless defined $object;
	$object->status("enabled");
	$object->update;

	my $obj = $self->{_mapper}->to_shopify($object);
	$obj->associate($self);
	return $obj;
}

use Digest::MD5 qw(md5_hex);
sub login_admin {
	my ($self, $username, $password) = @_;
	return 1 if $self->{last_login_check} && (time - $self->{last_login_check}) < 1000;
	$self->{last_login_check} = time;
	$self->{authenticity_token} = md5_hex(rand());
	return 1;
}

sub logged_in_admin {
	my ($self) = @_;
	return 1 if $self->{last_login_check} && (time - $self->{last_login_check}) < 1000;
	$self->{last_login_check} = time;
	return 1;
}

=head2 authorize_url([scope], redirect)

When the shop doesn't have an access_token, this is what you should be redirecting your client to. Inputs should be your scope, as an array, and the url you want to redirect to.

=cut

sub authorize_url {
	my ($self, $scope, $redirect) = (@_);
	return "$redirect?shop=" . $self->associate->myshopify_domain;
}

=head2 exchange_token(shared_secret, code)

When you have a temporary code, which you should get from authorize_url's redirect and you want to exchange it for a token, you call this.

=cut

sub exchange_token {
	my ($self, $shared_secret, $code) = (@_);
	
	die new WWW::Shopify::Exception("Unable to exchange tokens when shop is not associated.") unless $self->associate;

	my $req = HTTP::Request->new(POST => "https://" . $self->shop_url . "/admin/oauth/access_token");
  	$req->content_type('application/x-www-form-urlencoded');
	my %parameters = (
		'client_id' => $self->api_key,
		'client_secret' => $shared_secret,
		'code' => $code
	);
	return md5_hex($self->api_key . $self->shop_url);
}

sub shop_url {
	die new WWW::Shopify::Exception("Can't get a url, unless we're associated.") unless $_[0]->associate;
	return $_[0]->associate->myshopify_domain;
}
sub api_key { return md5_hex(''); }

=head1 SEE ALSO

L<WWW::Shopify>

=head1 AUTHOR

Adam Harrison

=head1 LICENSE

See LICENSE in the main directory.

=cut


1;
