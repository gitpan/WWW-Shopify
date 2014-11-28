#!/usr/bin/perl

use strict;
use warnings;

package WWW::Shopify::Common::DBIxGroup;

sub new {
	my $package = shift;
	my %hash = @_;
	bless {
		parent => undef,
		contents => $hash{'contents'} ? $hash{'contents'} : undef,
		children => []
	}, $package;
}

sub children { return @{$_[0]->{children}}; }
sub contents { return $_[0]->{contents}; }
sub parent { $_[0]->{parent} = $_[1] if $_[1]; return $_[0]->{parent}; }
sub members { return ($_[0]->contents, $_[0]->children); }
sub add_children {
	my ($self, @children) = @_;

	@children = @{$children[0]} if int(@children) == 1 && ref($children[0]) eq "ARRAY";
	foreach my $child (@children) {
		die new WWW::Shopify::Exception("Must be a DBIxGroup: " . ref($child)) unless $child && ref($child) && ref($child) =~ m/DBIxGroup/;
		$child->parent($self);
		push(@{$self->{children}}, $child);
	}
}
sub update { 
	my ($self) = @_;
	$_->update_or_insert for ($self->children);
	$self->contents->update;
}
sub delete {
	my ($self) = @_;
	$_->delete for ($self->children);
	$self->contents->delete;
}
sub update_or_insert {
	my ($self) = @_;
	if ($self->parent) {
		my $relationship = "add_to_" . $self->contents->represents->plural;
		my $columns = {$self->contents->get_columns};
		if (!$self->contents->in_storage) {
			$self->parent->contents->$relationship($columns);
		}
		else {
			$self->contents->update;
		}
	}
	else {
		$self->contents->update_or_insert;
	}
	$_->update_or_insert for ($self->children);
}
sub insert {
	my ($self) = @_;
	if ($self->parent) {
		my $relationship = "add_to_" . $self->contents->represents->plural;
		my $parent_variable = $self->contents->parent_variable;
		$self->contents->$parent_variable($self->parent->contents->id);
		my $columns = {$self->contents->get_columns};
		$self->parent->contents->$relationship($columns);
	}
	else {
		$self->contents->insert;
	}
	$_->insert for ($self->children);
}

# Ensure that we have no unecessary children present.
sub ensure_synchronicity {
	my ($self) = @_;
	my $package = $self->contents->represents;
	my $fields = $package->fields;
	foreach my $field (grep { $_->is_relation && ($_->is_many || $_->is_own) && $_->relation !~ m/Metafield/ } values(%$fields)) {
		my $name = $field->name;
		my @children = grep { $_->contents->represents eq $field->relation } $self->children;
		# In case we're not actually keeping certain elements in sync.
		eval {
			my @ids = $field->relation->identifier;
			if (int(@ids) == 1 && $ids[0] eq "id") {
				$self->contents->$name->search({ id => { -not_in => [map { $_->contents->id } @children] } })->delete;
			} else {
				my @db_children = $self->contents->$name->all;
				for my $db_child (@db_children) { 
					my $exists = 0;
					for my $pot_child (@children) {
						$exists = 1 if int(grep { $db_child->$_ eq $pot_child->contents->$_ } (@ids)) == int(@ids);
					}
					$db_child->delete if !$exists;
				}
			}
		};
	}
}

sub nested { my ($self) = @_; return ($self->contents, map { $_->nested } $self->children); }

1;
