
#!/usr/bin/perl
# NOTE - THIS FILE GENERATED BY DBIxGenerate.pl.
# To regenerate this file, simply call the script, and it'll dump the DBIx files into the working directory.

=head1 NAME

WWW::Shopify::Model::DBIx::Schema::Result::Model::DBIx::Schema::Result::Model::MetafieldOrder - Database Object for WWW::Shopify::Model::DBIx::Schema::Result::Model::MetafieldOrder.

=cut

=head1 NOTICE

This is a generated class, made by WWW::Shopify/Utils/DBIxGenerate.pl. Do not modify.

=cut

use strict;
use warnings;


			package WWW::Shopify::Model::DBIx::Schema::Result::Model::MetafieldOrder;
			use base qw/DBIx::Class::Core/;

			__PACKAGE__->table('shopify_metafieldorder');
			__PACKAGE__->add_columns(
				'order_id', { data_type => 'int', is_nullable => 0 },
				'metafield_id', { data_type => 'int', is_nullable => 0 });
			__PACKAGE__->belongs_to(order => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order', 'order_id');
			__PACKAGE__->belongs_to(metafield => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Metafield', 'metafield_id');

1;