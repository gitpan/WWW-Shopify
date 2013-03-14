#!/usr/bin/perl


=head1 NAME

DBIx - Main interface to the object-relational mapper; maps shopify objects to database objects, and back again.

=cut

=head1 DESCRIPTION

DBIx represents a way to grab and upload data to the database.

=cut

=head1 EXAMPLES

To give an idea of how you're supposed to use this object, look at the following example, which builds off the example in L<WWW::Shopify>: here we get all the products, and then insert them into the database.

	my $SA = new WWW::Shopify::Public($ShopURL, $APIKey, $AccessToken);
	my $DBIX = new WWW::Shopify::Common::DBIx();
	my @Products = $SA->getAll('WWW::Shopify::Product');
	for (@Products) {
		my $Product = $DBIX->from_shopify($_);
		$Product->insert;
	}

This doesn't check for duplicates or anything else, but it's easy enough to check for that; see the DBIx documentation.

=cut

use strict;
use warnings;

use WWW::Shopify;
use Data::Dumper;

package WWW::Shopify::Common::DBIx;

use constant {
	IDENTIFIER_TYPE => "int",
	PACKAGE_PREFIX => 'WWW::Shopify::Model::DBIx::Schema::Result'
};

sub new {
	my $package = shift;
	bless {intermediateClasses => {}}, $package;
};

# Determines whether or not the field is pointing to something that has a belong relation.
# If it is, we don't need a column for it.
sub is_belonging_field($$) {
	return $_[1]->is_relation() && (($_[1]->relation()->parent() && $_[1]->relation()->parent() eq $_[0]) || $_[1]->relation() =~ "Metafield");
}

sub strip_head($) {
	die unless $_[0] =~ m/^WWW::Shopify::/;
	return $';
}
sub strip_full($) {
	die unless $_[0] =~ m/::(\w+)$/;
	return $1;
}
sub transform_package($) {
	return PACKAGE_PREFIX . "::" . strip_head($_[0]);
}
sub strip_id($) {
	die unless $_[0] =~ m/_id$/;
	return $`;
}

sub transform_invalid($) {
	return "id" unless $_[0] ne "key";
	return $_[0];
}

# Essentially an internal method.
# Generates a DBIx schema from the spcified package.
sub generateDBIx {
	my ($self, $package) = @_;

	my $fields = $package->fields();
	my $columns = "";
	my @columns = ();
	my @relationships = ();
	# Loop through all the fields (stats, mods) of a package.
	for (keys(%$fields)) {
		# Make sure that only the fields that aren't identifiers are nullable.
		my $attributes = ref($fields->{$_}) ne "WWW::Shopify::Field::Identifier" ? "is_nullable => 1" : "";
		# Add to our columns the proper type and attributes of the field.
		push(@columns, "'" . transform_invalid($_) . "', { data_type => '" . $fields->{$_}->sql_type() . "', $attributes }") unless is_belonging_field($package, $fields->{$_});
		# Add a column for our relationship to a particular shop, unless this class is WWW::Shopify::*::Shop, of course.
		# If our column is not a scalar (meaining we have a reference to another class), add it to the relationships array.
		push(@relationships, $_) if $fields->{$_}->is_relation();
	}
	push(@columns, "'shop_id', { data_type => '" . WWW::Shopify::Field::Identifier->sql_type() . "', is_nullable => 1 }") unless $package =~ m/^WWW::Shopify.*Shop$/ && !defined $package->parent();

	my @relations = ();
	my $parentLine = "";
	my $parentVariable = "";
	# Check all our relationships.
	for (@relationships) {
		my $relation = $fields->{$_};
		if ($relation->is_many()) {
			# If the specified relationship is to our parent.
			if (defined $relation->relation()->parent() && $relation->relation()->parent() eq $package) {
				# Check to see if we have a field named after our parent, if we do, specify it, if not, use the generic parent_id.
				if (defined $relation->relation()->fields()->{$package->singular() . "_id"}) {
					push(@relations, "__PACKAGE__->has_many($_ => '" . transform_package($relation->relation()) . "', '" . $package->singular() . "_id');");
				}
				else {
					push(@relations, "__PACKAGE__->has_many($_ => '" . transform_package($relation->relation()) . "', 'parent_id');");				
				}
			}
			else {
				# If we have a many-to-many relationship, generate the following intermediate class (and associated table).
				my @double = sort($relation->relation(), $package);
				my $intermediateName = strip_full($double[0]) . strip_full($double[1]);
				my $intermediatePackage = PACKAGE_PREFIX . "::Model::" . $intermediateName; 
				my $tableName = lc("shopify_$intermediateName");
				push(@relations, "__PACKAGE__->has_many(" . $package->plural() . $relation->relation()->plural() . " => '" . $intermediatePackage . "', '" . $package->singular() . "_id');");
				push(@relations, "__PACKAGE__->many_to_many(" . $relation->relation()->plural() . " => '" . $package->plural() . $relation->relation()->plural() . "', '" . $relation->relation()->singular() . "');");
				$self->{intermediateClasses}->{$intermediatePackage} = "
			package $intermediatePackage;
			use base qw/DBIx::Class::Core/;

			__PACKAGE__->table('$tableName');
			__PACKAGE__->add_columns(
				'" . $package->singular() . "_id', { data_type => '" . WWW::Shopify::Field::Identifier->sql_type() . "', is_nullable => 0 },
				'" . $relation->relation()->singular() . "_id', { data_type => '" . WWW::Shopify::Field::Identifier->sql_type() . "', is_nullable => 0 });
			__PACKAGE__->belongs_to(" . $package->singular() . " => '" . transform_package($package) . "', '" . $package->singular() . "_id');\
			__PACKAGE__->belongs_to(" . $relation->relation()->singular() . " => '" . transform_package($relation->relation()) . "', '" . $relation->relation()->singular() . "_id');";
			}
		}
		elsif ($relation->is_one()) {
			# Check again to see if this is related to our parent.
			if (defined $fields->{$relation->relation()->singular() . "_id"} && defined $package->parent() && $relation->relation() eq $package->parent()) {
				$parentVariable = "sub parent_variable(\$) { return '" . $relation->relation()->singular() . "_id'; }";
				$parentLine = "__PACKAGE__->belongs_to(" . lc(strip_full($relation->relation())) . " => '" . transform_package($relation->relation()) . "', '" . $relation->relation()->singular() . "_id');";
			}
			elsif ($relation->is_own()) {
				my $stripped = $_;
				$stripped = $1 if ($_ =~ m/^(.+)_id$/);
				my $otherfields = $relation->relation()->fields();
				if ($relation->relation()->is_nested() && $relation->relation()->container() eq $package) {
					push(@relations, "__PACKAGE__->has_one($_ => '" . transform_package($relation->relation()) . "', 'parent_id');")
				}
				else {
					push(@relations, "__PACKAGE__->belongs_to($stripped => '" . transform_package($relation->relation()) . "', '$_');");
				}
			}
			elsif ($relation->is_reference()) {
				if ($relation->relation()->is_nested()) {
					if ($relation->relation()->parent() eq $package) {
						my $otherfields = $relation->relation()->fields();
						if (exists $otherfields->{$relation->relation()->parent()->singular() . '_id'}) {
							push(@relations, "__PACKAGE__->has_one($_ => '" . transform_package($relation->relation()) . "', '" . $relation->relation()->parent()->singular() . "_id');");
						}
						else {
							push(@relations, "__PACKAGE__->has_one($_ => '" . transform_package($relation->relation()) . "', 'parent_id');")
						}
					}
					else {
						push(@relations, "__PACKAGE__->belongs_to(" . strip_id($_) . " => '" . transform_package($relation->relation()) . "', '$_');")
					}
				}
				else {
					push(@relations, "__PACKAGE__->belongs_to(" . strip_id($_) . " => '" . transform_package($relation->relation()) . "', '$_');") unless $relation->relation()->is_nested();
				}
			}
		}
		else {
			die "Invalid Specification.";
		}
	}
	# Lets us set our primary key.
	my $idLine = "";
	if (defined $fields->{$package->identifier()}) {
		$idLine = "__PACKAGE__->set_primary_key('" . transform_invalid($package->identifier()) . "');";
	}
	else {
		push(@columns, "'id', { data_type => 'int', is_auto_increment => 1 }");
		$idLine = "__PACKAGE__->set_primary_key('id');";
	}
	if ($parentLine eq "" && defined $package->parent()) {
		# If we haven't already build ourselves a belongs_to line (i.e., if it's not acutally part of the shopify spec), let's do it now, generically.
		$parentVariable = "sub parent_variable(\$) { return 'parent_id'; }";
		$parentLine = "__PACKAGE__->belongs_to(" . lc(strip_full($package->parent())) . " => '" . transform_package($package->parent()) . "', 'parent_id');";
		push(@columns, "'parent_id', { data_type => '" . WWW::Shopify::Field::Identifier->sql_type() . "', is_nullable => 0 }") if defined $package->parent();
	}
	my $shopLine = "";
	$shopLine = "__PACKAGE__->belongs_to(shop => '" . transform_package("WWW::Shopify::Model::Shop") . "', 'shop_id');" unless $package =~ m/^WWW::Shopify.*Shop$/ && !defined $package->parent();

	my $tableName = $package->plural();
	$tableName = $package->parent()->singular() . $tableName if $package->parent();
	$tableName = lc("shopify_$tableName");

	return "
		package " . transform_package($package) . ";
		use base qw/DBIx::Class::Core/;
		
		__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
		__PACKAGE__->table('$tableName');	
		__PACKAGE__->add_columns(" . join(",\n\t\t\t", @columns) . ");
		$shopLine
		$idLine
		$parentLine
		" . join("\n\t\t", @relations) . "
		sub represents(\$) { return '$package'; }
		$parentVariable
	";
}

use WWW::Shopify::Common::DBIxGroup;
# Takes in a schema and a shopify object and maps it to a DBIx existence.
sub from_shopify($$$@) {
	my $internal_from = sub {
		my ($self, $schema, $type, $data) = @_;
		# If we have a class relationship.
		if ($type->is_relation()) {
			if ($type->is_many()) {
				return [] unless $data;
				use Data::Dumper;
				my $array = [map { $self->from_shopify($schema, $_); } @$data];
				return $array;
			}
			elsif ($type->is_own()) {
				return {} unless $data;
				return $self->from_shopify($data);
			}
			elsif ($type->is_reference() && $type->is_one()) {
				return undef unless $data;
				return $type->from_shopify($data);
			}
		}
		return $type->from_shopify($data);
	};

	my ($self, $schema, $shopifyObject) = @_;
	return undef unless $shopifyObject;
	die new WWW::Shopify::Exception('Invalid object passed into to_shopify: ' . ref($shopifyObject) . '.') unless ref($shopifyObject) =~ m/Model::/;
	my $dbPackage = transform_package(ref($shopifyObject));
	my $dbObject = $schema->resultset($dbPackage)->new({});
	my $fields = $shopifyObject->fields();
	my $group = WWW::Shopify::Common::DBIxGroup->new(contents => $dbObject);

	foreach my $key (keys(%$fields)) {
		my $data = $shopifyObject->$key;
		if ($data) {
			my $db_value = &$internal_from($self, $schema, $fields->{$key}, $data);
			if ($fields->{$key}->is_relation() && $fields->{$key}->is_many()) {
				$group->add_children(grep { defined $_ } @$db_value);
			}
			else {
				$dbObject->$key($db_value);
			}
		}
	}
	return $group;
}

sub to_shopify($$$@) {
	my $internal_to = sub {
		my ($self, $type, $data) = @_;
		# If we have a class relationship.
		if ($type->is_relation()) {
			if ($type->is_many()) {
				return [] unless $data;
				my $array = [map { $self->to_shopify($_); } $data->all()];
				return $array;
			}
			elsif ($type->is_own()) {
				return {} unless $data;
				return $self->to_shopify($data);
			}
			elsif ($type->is_reference() && $type->is_one()) {
				return undef unless $data;
				return $type->to_shopify($data);
			}
		}
		return $type->to_shopify($data);
	};

	my ($self, $dbObject) = @_;
	return undef unless $dbObject;
	die new WWW::Shopify::Exception('Invalid object passed into to_shopify: ' . ref($dbObject) . '.') unless ref($dbObject) =~ m/Model::/;

	my $shopifyObject = $dbObject->represents()->new;
	my $fields = $shopifyObject->fields();
	foreach my $key (keys(%$fields)) {
		my $data = $dbObject->$key();
		$shopifyObject->{$key} = &$internal_to($self, $fields->{$key}, $data) if defined $data;
	}

	return $shopifyObject;
}

=head1 SEE ALSO

L<WWW::Shopify>

=head1 AUTHOR

Adam Harrison

=head1 LICENSE

See LICENSE in the main directory.

=cut

1
