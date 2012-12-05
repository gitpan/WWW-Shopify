
#!/usr/bin/perl
# NOTE - THIS FILE GENERATED BY DBIxGenerate.pl.
# To regenerate this file, simply call the script, and it'll dump the DBIx files into the working directory.

=head1 NAME

WWW::Shopify::Model::DBIx::Schema::Result::Model::DBIx::Schema::Result::Model::FulfillmentLineItem - Database Object for WWW::Shopify::Model::DBIx::Schema::Result::Model::FulfillmentLineItem.

=cut

=head1 NOTICE

This is a generated class, made by WWW::Shopify/Utils/DBIxGenerate.pl. Do not modify.

=cut

use strict;
use warnings;


			package WWW::Shopify::Model::DBIx::Schema::Result::Model::FulfillmentLineItem;
			use base qw/DBIx::Class::Core/;

			__PACKAGE__->table('shopify_fulfillmentlineitem');
			__PACKAGE__->add_columns(
				'fulfillment_id', { data_type => 'int', is_nullable => 0 },
				'line_item_id', { data_type => 'int', is_nullable => 0 });
			__PACKAGE__->belongs_to(fulfillment => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Fulfillment', 'fulfillment_id');
			__PACKAGE__->belongs_to(line_item => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem', 'line_item_id');

1;