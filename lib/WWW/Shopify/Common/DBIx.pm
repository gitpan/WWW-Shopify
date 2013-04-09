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
	my @products = $SA->get_all('WWW::Shopify::Product');
	for (@products) {
		my $product = $DBIX->from_shopify($_);
		$product->insert;
	}

This doesn't check for duplicates or anything else, but it's easy enough to check for that; see the DBIx documentation.

=cut

use strict;
use warnings;

use WWW::Shopify;
use Data::Dumper;

package WWW::Shopify::Common::DBIx;

use constant { PACKAGE_PREFIX => 'WWW::Shopify::Model::DBIx::Schema::Result' };
sub new {
	my $package = shift; 
	return bless { namespace => [@_], classes => {} }, $package;
};
sub class {
	my ($self, $class) = @_;
	return $self->{classes}->{$class};
}
sub generate_dbix_all {
	my ($self) = @_;
	$self->generate_dbix($_) for (@{$self->{namespace}});
}
sub strip_head { die unless $_[0] =~ m/^WWW::Shopify::/; return $'; }
sub transform_package { return PACKAGE_PREFIX . "::" . strip_head($_[0]); }

sub table_prefix { return "shopify_"; }
sub joining_table_name { return join("", map { $_->plural } sort(@_)); }
sub joining_class_name { return PACKAGE_PREFIX . "::Model::" . join("", map { $_ =~ m/\:\:(\w+)$/; $1; } sort(@_)); }

sub generate_dbix_join {
	my ($self, $join1, $join2) = @_;
	my $name = joining_class_name($join1, $join2);
	$self->{classes}->{$name} = "
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package $name;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('" . table_prefix() . joining_table_name($join1, $join2) . "');
__PACKAGE__->add_columns(
	'" . $join1->singular . "_id', { data_type => 'INT', is_nullable => 0 },
	'" . $join2->singular . "_id', { data_type => 'INT', is_nullable => 0 }
);
__PACKAGE__->belongs_to(" . $join1->singular . " => '" . transform_package($join1) . "', '" . $join1->singular . "_id');
__PACKAGE__->belongs_to(" . $join2->singular . " => '" . transform_package($join2) . "', '" . $join2->singular . "_id');

1;";
}

use Module::Find;
BEGIN {	foreach my $package (findallmod WWW::Shopify::Model) { $package =~ s/::/\//g; eval { require $package . '.pm' }; print STDERR $@ if $@; } }
# Essentially an internal method.
# Generates a DBIx schema from the specified package.
use List::Util qw(first);
sub generate_dbix {
	my ($self, $package) = @_;

	sub is_belongs_to { return $_[0]->is_relation && $_[0]->is_one; }
	sub is_has_many { return !is_belongs_to(@_) && $_[0]->is_relation && ($_[0]->is_own || $_[0]->is_many) && $_[0]->relation->parent && $_[0]->relation->parent eq $_[1]; }
	sub is_many_many { return !is_belongs_to(@_) && !is_has_many(@_) && $_[0]->is_relation && ($_[0]->is_many || $_[0]->is_own); }

	my $fields = $package->fields;
	my @ids = $package->identifier;
	my $has_date = (defined first { $fields->{$_}->sql_type eq "DATETIME" } keys(%$fields));
	my $parent_variable = undef;
	my $table_name = $package->plural;
	$table_name = $package->parent->plural . "_" . $table_name if $package->parent;
	# All simple columns.
	my @columns = ();
	foreach my $field_name (grep { !$fields->{$_}->is_relation } keys(%$fields)) {
		my $field = $fields->{$field_name};
		my %attributes = ();
		$attributes{'data_type'} = $field->sql_type;
		$attributes{'is_nullable'} = 1;
		push(@columns, "\"$field_name\", { " . join(", ", map { "$_ => '" . uc($attributes{$_}) . "'" } keys(%attributes)) . " }");
		
	}
	# If we're a nested item, and we don't have something called either parent_id or <parent->singular>_id, create one, 'cause we're expecting it.
	if ($package->parent) {
		if (!$fields->{parent_id} && !$fields->{$package->parent->singular . "_id"}) {
			$parent_variable = $package->parent->singular . "_id";
			push(@columns, "\"$parent_variable\", { data_type => 'INT' }");
		}
		elsif ($fields->{parent_id}) {
			$parent_variable = 'parent_id';
		}
		else {
			$parent_variable = $package->parent->singular . '_id';
		}
	}
	# If we don't have an ID give us one, so that all DB stuff can have primary keys.
	if (!$fields->{$ids[0]}) {
		push(@columns, "\"" . $ids[0] . "\", { data_type => 'INT' }");		
	}
	# All relationship columns that are belong to.
	# ReferenceOne / Non-Nested / Interior : Belongs To
	# ReferenceOne / Non-Nested / Exterior : Belongs To
	# Parent : Belongs To
	# OwnOne / Non-Nested / Interior : Belongs To
	# OwnOne / Nested / Exterior : Belong To
	my @relationships = ();
	foreach my $field_name (grep { is_belongs_to($fields->{$_}, $package) } keys(%$fields)) {
		my $field = $fields->{$field_name};
		die $field_name unless $field->relation;
		my %attributes = ();
		my $accessor_name;
		if ($field_name =~ m/_id$/) {
			$accessor_name = $`;
		}
		else {
			$accessor_name = $field_name;
			$field_name = $field_name . "_id";
		}
		$attributes{'data_type'} = $field->sql_type;
		# Geenrally make non-parent fields nullable.
		$attributes{'is_nullable'} = 1 unless $field->is_parent;
		push(@columns, "\"$field_name\", { " . join(", ", map { "$_ => '" . uc($attributes{$_}) . "'" } keys(%attributes)) . " }");
		push(@relationships, "__PACKAGE__->belongs_to($accessor_name => '" . transform_package($field->relation) . "', '$field_name');");
	}
	# OwnOne / Nested / Interior : Has Many
	foreach my $field_name (grep { is_has_many($fields->{$_}, $package) } keys(%$fields)) {
		my $field = $fields->{$field_name};
		push(@relationships, "__PACKAGE__->has_many($field_name => '" . transform_package($field->relation) . "', '" . $package->singular . "_id');");
	}
	# OwnOne / Non-Nested / Exterior : Many-Many
	# Many / Nested : Many-Many
	# Many / Non-Nested : Many-Many
	foreach my $field_name (grep { is_many_many($fields->{$_}, $package) } keys(%$fields)) {
		my $field = $fields->{$field_name};
		my $joining_name = joining_class_name($package, $field->relation);
		my $accessor_name = $field_name . "_hasmany";
		$self->generate_dbix_join($package, $field->relation);
		push(@relationships, "__PACKAGE__->has_many($accessor_name => '" . $joining_name . "', '" . $package->singular . "_id');");
		push(@relationships, "__PACKAGE__->many_to_many($field_name => '$accessor_name', '" . $field->relation->singular . "');");
	}

	my @shop_relations = ();
	if ($package->is_shop) {
		# Get a list somewhere of all the top-level stuff.
		@shop_relations = map { "__PACKAGE__->has_many(" . $_->plural . " => '" . transform_package($_)  . "', 'shop_id');" }
			grep { !$_->is_nested && !$_->is_shop && $_ !~ m/metafield/i } @{$self->{namespace}};
	}
	elsif (!$package->is_nested || !$package->parent) {
		push(@columns, "\"shop_id\", { data_type => \"INT\" }");
		push(@shop_relations, "__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');");
	}

	$self->{classes}->{transform_package($package)} = "
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package " . transform_package($package) . ";
use base qw/DBIx::Class::Core/;

" . ($has_date ? "__PACKAGE__->load_components(qw/InflateColumn::DateTime/);" : "") . "
__PACKAGE__->table('" . table_prefix() . $table_name . "');
__PACKAGE__->add_columns(
	" . join(",\n\t", @columns) . "
);
__PACKAGE__->set_primary_key(" . join(", ", map { "'$_'" } @ids) . ");

" . join("\n", @shop_relations)  . "

" . join("\n", @relationships) . "
sub represents { return '" . $package . "'; }
sub parent_variable { return " . ($parent_variable ? "'$parent_variable'" : "undef") . "; }

1;";
}

use WWW::Shopify::Common::DBIxGroup;
# Takes in a schema and a shopify object and maps it to a DBIx existence.
sub from_shopify {
	my $internal_from = sub {
		my ($self, $schema, $type, $data) = @_;
		# If we have a class relationship.
		if ($type->is_relation()) {
			if ($type->is_many()) {
				return [] unless $data;
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
	my $identifier = $shopifyObject->identifier;
	my $dbObject = undef;
	$dbObject = $schema->resultset($dbPackage)->find($shopifyObject->$identifier) if $shopifyObject && $shopifyObject->$identifier;
	$dbObject = $schema->resultset($dbPackage)->new({}) unless $dbObject;
	my $fields = $shopifyObject->fields();
	my $group = WWW::Shopify::Common::DBIxGroup->new(contents => $dbObject);

	foreach my $key (keys(%$fields)) {
		next if $key =~ m/metafields/;
		my $data = $shopifyObject->$key();
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

sub to_shopify {
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
