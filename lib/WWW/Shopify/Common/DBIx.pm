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

use Exporter 'import';
our @EXPORT_OK = qw(transform_package strip_head);

sub new {
	my $package = shift; 
	return bless {
		namespace => [@_],
		classes => {},
		package_prefix => 'WWW::Shopify::Model::DBIx::Schema::Result',
		table_prefix => 'shopify_'
	}, $package;
};
sub package_prefix { $_[0]->{package_prefix} = $_[1] if defined $_[1]; return $_[0]->{package_prefix}; } 
sub table_prefix { $_[0]->{table_prefix} = $_[1] if defined $_[1]; return $_[0]->{table_prefix}; } 
use List::Util qw(first);
sub in_namespace { return defined first { $_ eq $_[1] } @{$_[0]->{namespace}} }

sub class {
	my ($self, $class) = @_;
	return $self->{classes}->{$class};
}
sub classes {
	my ($self) = @_;
	return values(%{$self->{classes}});
}
sub class_names {
	my ($self) = @_;
	return keys(%{$self->{classes}});
}

sub generate_dbix_all {
	my ($self) = @_;
	$self->generate_dbix($_) for (@{$self->{namespace}});
}
sub strip_head { die unless $_[0] =~ m/^WWW::Shopify::/; return $'; }

sub transform_package { 
	return $_[0]->package_prefix . "::" . strip_head($_[1]) if ref($_[0]) && ref($_[0]) eq __PACKAGE__;
	return "WWW::Shopify::Model::DBIx::Schema::Result::" . strip_head($_[0]);
}

sub joining_table_name { my $self = shift; return join("", map { $_->plural } sort(@_)); }
sub joining_class_name { my $self = shift; return $self->package_prefix . "::Model::" . join("", map { $_ =~ m/\:\:(\w+)$/; $1; } sort(@_)); }

sub generate_dbix_join {
	my ($self, $join1, $join2) = @_;
	my $name = $self->joining_class_name($join1, $join2);
	$self->{classes}->{$name} = "
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package $name;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('" . $self->table_prefix . $self->joining_table_name($join1, $join2) . "');
__PACKAGE__->add_columns(
	'id', { data_type => 'INT', is_nullable => 0, is_auto_increment => 1 },
	'" . $join1->singular . "_id', { data_type => 'INT', is_nullable => 0 },
	'" . $join2->singular . "_id', { data_type => 'INT', is_nullable => 0 }
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(" . $join1->singular . " => '" . $self->transform_package($join1) . "', '" . $join1->singular . "_id');
__PACKAGE__->belongs_to(" . $join2->singular . " => '" . $self->transform_package($join2) . "', '" . $join2->singular . "_id');

1;";
}

use Module::Find;
BEGIN {	foreach my $package (findallmod WWW::Shopify::Model) { $package =~ s/::/\//g; eval { require $package . '.pm' }; print STDERR $@ if $@; } }
# Essentially an internal method.
# Generates a DBIx schema from the specified package.
use List::Util qw(first);
sub generate_dbix {
	my ($self, $package) = @_;

	my $fields = $package->fields;
	my @ids = $package->identifier;
	my $has_date = (defined first { $fields->{$_}->sql_type eq "DATETIME" } keys(%$fields));
	my $parent_variable = undef;
	my $table_name = $package->plural;
	$table_name = $package->parent->plural . "_" . $table_name if $package->parent;

	my @columns = ();
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
	# All simple columns.
	foreach my $field_name (grep { !$fields->{$_}->is_relation } keys(%$fields)) {
		my $field = $fields->{$field_name};
		my %attributes = ();
		$attributes{'data_type'} = $field->sql_type;
		$attributes{'is_nullable'} = ($package->identifier ne $field_name && (!$package->is_nested || !$package->parent || $parent_variable ne $field_name)) ? 1 : 0;
		push(@columns, "\"$field_name\", { " . join(", ", map { "$_ => '" . uc($attributes{$_}) . "'" } keys(%attributes)) . " }");
		
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

	my @field_relations = grep { $fields->{$_}->is_relation && $self->in_namespace($fields->{$_}->relation) } keys(%$fields);

	my @relationships = ();
	foreach my $field_name (grep { $fields->{$_}->is_db_belongs_to } @field_relations) {
		my $field = $fields->{$field_name};
		die $field_name unless $field->relation;
		my %attributes = ();
		my $accessor_name;
		my $mod_field_name = $field_name;
		if ($field_name =~ m/_id$/) {
			$accessor_name = $`;
		}
		else {
			$accessor_name = $field_name;
			$mod_field_name = $field_name . "_id";
		}
		$attributes{'data_type'} = $field->sql_type;
		# Geenrally make non-parent fields nullable.
		$attributes{'is_nullable'} = 1 unless $field->is_parent;
		push(@columns, "\"$mod_field_name\", { " . join(", ", map { "$_ => '" . uc($attributes{$_}) . "'" } keys(%attributes)) . " }");
		push(@relationships, "__PACKAGE__->belongs_to($accessor_name => '" . $self->transform_package($field->relation) . "', '$mod_field_name');");
	}
	# Many / Nested / Interior : Has Many
	foreach my $field_name (grep { $fields->{$_}->is_db_has_many } @field_relations) {
		my $field = $fields->{$field_name};
		push(@relationships, "__PACKAGE__->has_many($field_name => '" . $self->transform_package($field->relation) . "', '" . $package->singular . "_id');");
	}
	# OwnOne / Nested / Interior : Has One
	foreach my $field_name (grep { $fields->{$_}->is_db_has_one } @field_relations) {
		my $field = $fields->{$field_name};
		my $parent_variable = $self->transform_package($field->relation)->parent_variable;
		push(@relationships, "__PACKAGE__->has_one($field_name => '" . $self->transform_package($field->relation) . "', '$parent_variable');");
	}
	# OwnOne / Non-Nested / Exterior : Many-Many
	# Many / Nested : Many-Many
	# Many / Non-Nested : Many-Many
	foreach my $field_name (grep { $fields->{$_}->is_db_many_many } @field_relations) {
		my $field = $fields->{$field_name};
		my $joining_name = $self->joining_class_name($package, $field->relation);
		my $accessor_name = $field_name . "_hasmany";
		$self->generate_dbix_join($package, $field->relation);
		push(@relationships, "__PACKAGE__->has_many($accessor_name => '" . $joining_name . "', '" . $package->singular . "_id');");
		push(@relationships, "__PACKAGE__->many_to_many($field_name => '$accessor_name', '" . $field->relation->singular . "');");
	}

	my @shop_relations = ();
	if ($package->is_shop) {
		# Get a list somewhere of all the top-level stuff.
		@shop_relations = map { "__PACKAGE__->has_many(" . $_->plural . " => '" . $self->transform_package($_)  . "', 'shop_id');" }
			grep { $_ =~ m/Address/i || (!$_->is_nested && !$_->is_shop && $_ !~ m/metafield/i) } @{$self->{namespace}};
	}
	elsif ($package->has_shop_field) {
		push(@columns, "\"shop_id\", { data_type => \"INT\" }");
		push(@shop_relations, "__PACKAGE__->belongs_to(shop => '" . $self->package_prefix . "::Model::Shop', 'shop_id');");
	}

	my @unique_keys = $package->unique_fields;

	$self->{classes}->{$self->transform_package($package)} = "
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package " . $self->transform_package($package) . ";
use base qw/DBIx::Class::Core/;

" . ($has_date ? "__PACKAGE__->load_components(qw/InflateColumn::DateTime/);" : "") . "
__PACKAGE__->table('" . $self->table_prefix . $table_name . "');
__PACKAGE__->add_columns(
	" . join(",\n\t", @columns) . "
);
__PACKAGE__->set_primary_key(" . join(", ", map { "'$_'" } @ids) . ");

" . ((int(@unique_keys) > 0) ? "__PACKAGE__->add_unique_constraint(constraint_name => [ " . join(" ", map { "\"$_\"" } @unique_keys) . " ]);" : "") . "

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
		my ($self, $schema, $type, $data, $shop_id) = @_;
		# If we have a class relationship.
		if ($type->is_relation) {
			return undef if $type->relation && !$self->in_namespace($type->relation);
			if ($type->is_many()) {
				return [] unless $data;
				my $array = [map { $self->from_shopify($schema, $_, $shop_id); } @$data];
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

	my ($self, $schema, $shopifyObject, $shop_id) = @_;
	return undef unless $shopifyObject;
	die new WWW::Shopify::Exception('Invalid object passed into to_shopify: ' . ref($shopifyObject) . '.') unless ref($shopifyObject) =~ m/Model::/;
	my $dbPackage = $self->transform_package(ref($shopifyObject));
	my $identifier = $shopifyObject->identifier;
	my $dbObject = undef;
	$dbObject = $schema->resultset($dbPackage)->find($shopifyObject->$identifier) if $shopifyObject && $shopifyObject->$identifier;
	$dbObject = $schema->resultset($dbPackage)->new({}) unless $dbObject;
	my $fields = $shopifyObject->fields();
	my $group = WWW::Shopify::Common::DBIxGroup->new(contents => $dbObject);
	
	# Anything that's many-many like metafields shouldn't set parent variables on themselves.
	if ($shopifyObject->associated_parent && ref($shopifyObject) !~ m/Metafield$/) {
		my $parent_variable = $dbObject->parent_variable;
		die new WWW::Shopify::Exception("Can't convert " . ref($shopifyObject) . ", has a parent variable set, yet has no parent_variable in it's DBIx class.")
			unless $parent_variable;
		$dbObject->$parent_variable($shopifyObject->associated_parent->id);
	}
	elsif (!$shopifyObject->is_shop && $shop_id && !$shopifyObject->is_nested) {
		$dbObject->shop_id($shop_id);
	}
	else {
		$shop_id = $dbObject->id;
	}

	foreach my $key (keys(%$fields)) {
		next if $key =~ m/metafields/;
		my $data = $shopifyObject->$key();
		if ($data) {
			my $db_value = &$internal_from($self, $schema, $fields->{$key}, $data, $shop_id);
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
			if ($type->is_db_has_many || $type->is_db_many_many) {
				return [] unless $data;
				my $array = [map { $self->to_shopify($_); } $data->all()];
				return $array;
			}
			elsif ($type->is_own()) {
				return {} unless $data;
				return $self->to_shopify($data);
			}
			elsif ($type->is_reference()) {
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
