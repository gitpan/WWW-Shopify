
#!/usr/bin/perl
# NOTE - THIS FILE GENERATED BY DBIxGenerate.pl.
# To regenerate this file, simply call the script, and it'll dump the DBIx files into the working directory.

=head1 NAME

WWW::Shopify::Model::DBIx::Schema::Result::Model::Cart::LineItem - Database Object for WWW::Shopify::Model::Cart::LineItem.

=cut

=head1 NOTICE

This is a generated class, made by WWW::Shopify/Utils/DBIxGenerate.pl. Do not modify.

=cut

use strict;
use warnings;


		package WWW::Shopify::Model::DBIx::Schema::Result::Model::Cart::LineItem;
		use base qw/DBIx::Class::Core/;
		
		__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
		__PACKAGE__->table('shopify_cartline_items');	
		__PACKAGE__->add_columns('line_price', { data_type => 'decimal', is_nullable => 1 },
			'sku', { data_type => 'varchar(255)', is_nullable => 1 },
			'grams', { data_type => 'int', is_nullable => 1 },
			'quantity', { data_type => 'int', is_nullable => 1 },
			'variant_id', { data_type => 'int', is_nullable => 1 },
			'id', { data_type => 'int',  },
			'price', { data_type => 'decimal', is_nullable => 1 },
			'title', { data_type => 'varchar(255)', is_nullable => 1 },
			'vendor', { data_type => 'varchar(255)', is_nullable => 1 },
			'shop_id', { data_type => 'int', is_nullable => 1 },
			'parent_id', { data_type => 'int', is_nullable => 0 });
		__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');
		__PACKAGE__->set_primary_key('id');
		__PACKAGE__->belongs_to(cart => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Cart', 'parent_id');
		__PACKAGE__->belongs_to(variant => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Product::Variant', 'variant_id');
		sub represents($) { return 'WWW::Shopify::Model::Cart::LineItem'; }
		sub parent_variable($) { return 'parent_id'; }
	

1;