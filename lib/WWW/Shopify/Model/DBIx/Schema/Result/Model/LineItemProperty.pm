
#!/usr/bin/perl
# NOTE - THIS FILE GENERATED BY DBIxGenerate.pl.
# To regenerate this file, simply call the script, and it'll dump the DBIx files into the working directory.

=head1 NAME

WWW::Shopify::Model::DBIx::Schema::Result::Model::DBIx::Schema::Result::Model::LineItemProperty - Database Object for WWW::Shopify::Model::DBIx::Schema::Result::Model::LineItemProperty.

=cut

=head1 NOTICE

This is a generated class, made by WWW::Shopify/Utils/DBIxGenerate.pl. Do not modify.

=cut

use strict;
use warnings;


			package WWW::Shopify::Model::DBIx::Schema::Result::Model::LineItemProperty;
			use base qw/DBIx::Class::Core/;

			__PACKAGE__->table('shopify_lineitemproperty');
			__PACKAGE__->add_columns(
				'line_item_id', { data_type => 'int', is_nullable => 0 },
				'property_id', { data_type => 'int', is_nullable => 0 });
			__PACKAGE__->belongs_to(line_item => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem', 'line_item_id');
			__PACKAGE__->belongs_to(property => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem::Property', 'property_id');

1;