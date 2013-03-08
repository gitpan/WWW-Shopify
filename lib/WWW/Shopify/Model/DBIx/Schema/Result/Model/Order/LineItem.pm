
#!/usr/bin/perl
# NOTE - THIS FILE GENERATED BY DBIxGenerate.pl.
# To regenerate this file, simply call the script, and it'll dump the DBIx files into the working directory.

=head1 NAME

WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem - Database Object for WWW::Shopify::Model::Order::LineItem.

=cut

=head1 NOTICE

This is a generated class, made by WWW::Shopify/Utils/DBIxGenerate.pl. Do not modify.

=cut

use strict;
use warnings;


		package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem;
		use base qw/DBIx::Class::Core/;
		
		__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
		__PACKAGE__->table('shopify_line_items');	
		__PACKAGE__->add_columns('sku', { data_type => 'varchar(255)', is_nullable => 1 },
			'fulfillment_service', { data_type => 'varchar(255)', is_nullable => 1 },
			'product_id', { data_type => 'int', is_nullable => 1 },
			'id', { data_type => 'int',  },
			'grams', { data_type => 'int', is_nullable => 1 },
			'quantity', { data_type => 'int', is_nullable => 1 },
			'name', { data_type => 'varchar(255)', is_nullable => 1 },
			'properties', { data_type => 'int', is_nullable => 1 },
			'variant_title', { data_type => 'varchar(255)', is_nullable => 1 },
			'fulfillment_status', { data_type => 'varchar(255)', is_nullable => 1 },
			'variant_id', { data_type => 'int', is_nullable => 1 },
			'price', { data_type => 'decimal', is_nullable => 1 },
			'title', { data_type => 'varchar(255)', is_nullable => 1 },
			'variant_inventory_management', { data_type => 'varchar(255)', is_nullable => 1 },
			'requires_shipping', { data_type => 'bool', is_nullable => 1 },
			'vendor', { data_type => 'varchar(255)', is_nullable => 1 },
			'shop_id', { data_type => 'int', is_nullable => 1 });
		__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');
		__PACKAGE__->set_primary_key('id');
		
		__PACKAGE__->belongs_to(product => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product', 'product_id');
		__PACKAGE__->has_many(line_itemsproperties => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::LineItemProperty', 'line_item_id');
		__PACKAGE__->many_to_many(properties => 'line_itemsproperties', 'property');
		__PACKAGE__->belongs_to(variant => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Variant', 'variant_id');
		sub represents($) { return 'WWW::Shopify::Model::Order::LineItem'; }
		
	

1;