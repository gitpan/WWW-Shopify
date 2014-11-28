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
	my @products = $SA->get_all('Product');
	for (@products) {
		my $product = $DBIX->from_shopify($_);
		$product->insert;
	}

This doesn't check for duplicates or anything else, but it's easy enough to check for that; see the DBIx documentation.

=cut

use strict;
use warnings;

use WWW::Shopify;

package WWW::Shopify::Common::DBIx;

use Exporter 'import';
our @EXPORT_OK = qw(transform_package strip_head);

sub new {
	my $package = shift; 
	return bless {
		namespace => int(@_) > 0 ? [@_] : undef,
		classes => {},
		package_prefix => 'WWW::Shopify::Model::DBIx::Schema::Result',
		table_prefix => 'shopify_'
	}, $package;
};
sub package_prefix { $_[0]->{package_prefix} = $_[1] if defined $_[1]; return $_[0]->{package_prefix}; } 
sub table_prefix { $_[0]->{table_prefix} = $_[1] if defined $_[1]; return $_[0]->{table_prefix}; } 
use List::Util qw(first);
sub in_namespace { return 1 unless defined $_[0]->{namespace}; return defined first { $_ eq $_[1] } @{$_[0]->{namespace}} }

use Module::Find;


my %arbitrary_sql = (
	"WWW::Shopify::Model::Product" => sub {
		my ($self) = @_;
		return "__PACKAGE__->has_many('collects', '" . $self->package_prefix . "::Model::CustomCollection::Collect', 'product_id');\n";
	}
);

sub arbitrary_sql {
	my ($self, $package) = @_;
	return "" unless exists $arbitrary_sql{$package};
	$arbitrary_sql{$package}->($self);
}

sub all_classes {
	return grep { $_ !~ m/DBIx/ } findallmod WWW::Shopify::Model;
}

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
	'id', { data_type => 'INT', is_nullable => '0', is_auto_increment => 1 },
	'" . $join1->singular . "_id', { data_type => '" . WWW::Shopify::Field::Identifier->sql_type . "', is_nullable => 0 },
	'" . $join2->singular . "_id', { data_type => '" . WWW::Shopify::Field::Identifier->sql_type . "', is_nullable => 0 }
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

sub get_parent_column_name {
	my ($self, $package) = @_;

	my $fields = $package->fields;
	my $parent_variable;
	if (my $field = first { $_->is_relation && $_->is_parent } values(%$fields)) {
		return $field->name;
	}
	elsif ($fields->{parent_id}) {
		return 'parent_id';
	}
	else {
		return ($package->parent->singular . '_id', !exists $fields->{$package->parent->singular . "_id"});
	}
	return undef;
}

sub has_shop_field { 
	my $package = ref($_[0]) ? ref($_[0]) : $_[0];
	$package = $package->represents if $package =~ m/DBIx/;
	return !$package->is_shop && (!$package->is_nested || $package =~ m/Address/);
}

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
	# If we're a nested item, and we don't have something called either parent_id or <parent->singular>_id, or somethign marked a relation parent, create one, 'cause we're expecting it.
	if ($package->parent) {
		my $needs_adding;
		($parent_variable, $needs_adding) = $self->get_parent_column_name($package);
		push(@columns, "\"$parent_variable\", { data_type => '" . WWW::Shopify::Field::Identifier->sql_type . "' }") if $needs_adding;
		push(@ids, $parent_variable) if $needs_adding && !$fields->{id};
	}
	# All simple columns.
	foreach my $field_name (grep { !$fields->{$_}->is_relation } keys(%$fields)) {
		my $field = $fields->{$field_name};
		my %attributes = ();
		$attributes{'data_type'} = $field->sql_type;
		$attributes{'is_nullable'} = ((!first { $field_name eq $_ } $package->identifier) && (!$package->is_nested || !$package->parent || $parent_variable ne $field_name)) ? 1 : 0;
		push(@columns, "\"$field_name\", { " . join(", ", map { "$_ => '" . uc($attributes{$_}) . "'" } keys(%attributes)) . " }");
		
	}
	# If we don't have an ID give us one, so that all DB stuff can have primary keys.
	if (!$fields->{'id'}) {
		push(@columns, "\"id\", { data_type => 'BIGINT', is_nullable => 0, is_auto_increment => 1 }");
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
		push(@relationships, "__PACKAGE__->belongs_to($accessor_name => '" . $self->transform_package($field->relation) . "', '$mod_field_name'" . ($attributes{'is_nullable'} ? ", { join_type => 'left' }" : "") . ");");
	}
	# Many / Nested / Interior : Has Many
	foreach my $field_name (grep { $fields->{$_}->is_db_has_many } @field_relations) {
		my $field = $fields->{$field_name};
		my ($parent_var) = $self->get_parent_column_name($field->relation);
		push(@relationships, "__PACKAGE__->has_many($field_name => '" . $self->transform_package($field->relation) . "', '" . $parent_var . "');");
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
	elsif (has_shop_field($package)) {
		push(@columns, "\"shop_id\", { data_type => \"BIGINT\" }");
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

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
" . ($has_date ? "__PACKAGE__->load_components(qw/InflateColumn::DateTime/);" : "") . "
__PACKAGE__->table('" . $self->table_prefix . $table_name . "');
__PACKAGE__->add_columns(
	" . join(",\n\t", @columns) . "
);
__PACKAGE__->set_primary_key(" . join(", ", map { "'$_'" } (0 ? @ids : "id")) . ");

" . ((int(@unique_keys) > 0) ? "__PACKAGE__->add_unique_constraint(constraint_name => [ " . join(" ", map { "\"$_\"" } @unique_keys) . " ]);" : "") . "

" . join("\n", @shop_relations)  . "

" . join("\n", @relationships) . "
sub represents { return '" . $package . "'; }
sub parent_variable { return " . ($parent_variable ? "'$parent_variable'" : "undef") . "; }
" . $self->arbitrary_sql($package) . "
1;";
}


use JSON qw(encode_json from_json);
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
		return encode_json($type) if ($type eq 'WWW::Shopify::Field::Freeform');
		return $type->from_shopify($data);
	};

	my ($self, $schema, $shopifyObject, $shop_id) = @_;
	return undef unless $shopifyObject;
	die new WWW::Shopify::Exception('Invalid object passed into to_shopify: ' . ref($shopifyObject) . '.') unless ref($shopifyObject) =~ m/Model::/;
	my $dbPackage = $self->transform_package(ref($shopifyObject));
	my $dbObject = undef;
	my %identifiers = map { $_ => $shopifyObject->$_ } $shopifyObject->identifier;
	if ($shopifyObject->is_nested && $dbPackage->parent_variable) {
		die new WWW::Shopify::Exception("Invalid nested object passed into to_shopify.") unless $shopifyObject->associated_parent;
		$identifiers{$dbPackage->parent_variable} = $shopifyObject->associated_parent->id if $shopifyObject->associated_parent->can('id');
	}
	$dbObject = $schema->resultset($dbPackage)->find(\%identifiers) if $shopifyObject;
	$dbObject = $schema->resultset($dbPackage)->new({}) unless $dbObject;
	my $fields = $shopifyObject->fields();
	my $group = WWW::Shopify::Common::DBIxGroup->new(contents => $dbObject);
	
	# Anything that's many-many like metafields shouldn't set parent variables on themselves. Or not.
	if ($shopifyObject->associated_parent && ref($shopifyObject) !~ m/Metafield$/ && $dbObject->parent_variable) {
		my $parent_variable = $dbObject->parent_variable;
		$dbObject->$parent_variable($shopifyObject->associated_parent->id) if $shopifyObject->associated_parent->can('id');
	}
	if (has_shop_field($shopifyObject) && $shop_id) {
		$dbObject->shop_id($shop_id);
	}
	if ($shopifyObject->is_shop) {
		$shop_id = $dbObject->id;
	}

	foreach my $key (keys(%$fields)) {
		next if $key =~ m/metafields/;
		my $data = $shopifyObject->$key();
		if ($fields->{$key}->is_relation && $fields->{$key}->is_many()) {
			$_->associated_parent($shopifyObject) for (@$data);
		}
		my $db_value = &$internal_from($self, $schema, $fields->{$key}, $data, $shop_id);
		if ($fields->{$key}->is_relation && $fields->{$key}->is_many()) {
			$group->add_children(grep { defined $_ } @$db_value);
		}
		elsif (!$fields->{$key}->is_relation || ($fields->{$key}->is_reference && !$fields->{$key}->is_parent)) {
			$dbObject->$key($db_value);
		}
	}
	return $group;
}

sub to_shopify {
	my $internal_to = sub {
		my ($self, $type, $data, $shopifyObject, $test) = @_;
		# If we have a class relationship.
		if ($type->is_relation()) {
			if ($type->is_db_has_many || $type->is_db_many_many) {
				return undef if $type->relation =~ m/Metafield/;
				return [] unless $data;
				my $array = [map { my $object = $self->to_shopify($_, $test); $object->associated_parent($shopifyObject); $object } $data->all()];
				return $array;
			}
			elsif ($type->is_own()) {
				return {} unless $data;
				my $object = $self->to_shopify($data, $test);
				$object->associated_parent($shopifyObject); 
				return $object;
			}
			elsif ($type->is_reference()) {
				return undef unless $data;
				return $type->to_shopify($data, $test);
			}
		}
		# This seems confusing, but due to us storing our stuff in the database as Shopify stuff
		# We're transferring TYPE from shopify, but SELF to shopify.
		return $type->from_shopify($data) if ref($type) =~ m/timezone/i;
		return from_json($data) if ($data && ref($type) eq 'WWW::Shopify::Field::Freeform');
		return $data;
	};

	my ($self, $dbObject, $test) = @_;
	return undef unless $dbObject;
	die new WWW::Shopify::Exception('Invalid object passed into to_shopify: ' . ref($dbObject) . '.') unless ref($dbObject) =~ m/Model::/;

	my $shopifyObject = $dbObject->represents()->new;
	my $fields = $shopifyObject->fields();
	foreach my $key (keys(%$fields)) {
		# Easiest way, AFAICT to work around this: http://lists.scsys.co.uk/pipermail/dbix-class/2009-December/008687.html
		# DBIx strangeness.
		my $data;
		if ($dbObject->can($key . "_id")) {
			my $method = $key . "_id";
			$data = $dbObject->$key if ($dbObject->$method);
		} else {
			$data = $dbObject->$key;
		}
		$shopifyObject->{$key} = &$internal_to($self, $fields->{$key}, $data, $shopifyObject, $test) if defined $data;
	}
	$shopifyObject->associate($test);
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
