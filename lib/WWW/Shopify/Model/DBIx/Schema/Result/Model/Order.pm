
#!/usr/bin/perl
# NOTE - THIS FILE GENERATED BY DBIxGenerate.pl.
# To regenerate this file, simply call the script, and it'll dump the DBIx files into the working directory.

=head1 NAME

WWW::Shopify::Model::DBIx::Schema::Result::Model::Order - Database Object for WWW::Shopify::Model::Order.

=cut

=head1 NOTICE

This is a generated class, made by WWW::Shopify/Utils/DBIxGenerate.pl. Do not modify.

=cut

use strict;
use warnings;


		package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order;
		use base qw/DBIx::Class::Core/;
		
		__PACKAGE__->table('shopify_orders');	
		__PACKAGE__->add_columns('closed_at', { data_type => 'datetime', is_nullable => 1 },
			'total_price', { data_type => 'decimal', is_nullable => 1 },
			'line_items', { data_type => 'int', is_nullable => 1 },
			'taxes_included', { data_type => 'bool', is_nullable => 1 },
			'email', { data_type => 'varchar(255)', is_nullable => 1 },
			'total_price_usd', { data_type => 'decimal', is_nullable => 1 },
			'id', { data_type => 'int',  },
			'total_discounts', { data_type => 'decimal', is_nullable => 1 },
			'order_number', { data_type => 'int', is_nullable => 1 },
			'financial_status', { data_type => 'varchar(255)', is_nullable => 1 },
			'landing_site', { data_type => 'varchar(255)', is_nullable => 1 },
			'name', { data_type => 'varchar(255)', is_nullable => 1 },
			'cart_token', { data_type => 'varchar(255)', is_nullable => 1 },
			'total_line_items_price', { data_type => 'decimal', is_nullable => 1 },
			'fulfillment_status', { data_type => 'varchar(255)', is_nullable => 1 },
			'updated_at', { data_type => 'datetime', is_nullable => 1 },
			'subtotal_price', { data_type => 'decimal', is_nullable => 1 },
			'total_tax', { data_type => 'decimal', is_nullable => 1 },
			'number', { data_type => 'int', is_nullable => 1 },
			'gateway', { data_type => 'varchar(255)', is_nullable => 1 },
			'buyer_accepts_marketing', { data_type => 'bool', is_nullable => 1 },
			'cancel_reason', { data_type => 'varchar(255)', is_nullable => 1 },
			'currency', { data_type => 'varchar(255)', is_nullable => 1 },
			'created_at', { data_type => 'datetime', is_nullable => 1 },
			'landing_site_ref', { data_type => 'varchar(255)', is_nullable => 1 },
			'token', { data_type => 'varchar(255)', is_nullable => 1 },
			'total_weight', { data_type => 'float', is_nullable => 1 },
			'cancelled_at', { data_type => 'datetime', is_nullable => 1 },
			'processing_method', { data_type => 'varchar(255)', is_nullable => 1 },
			'referring_site', { data_type => 'varchar(255)', is_nullable => 1 },
			'note', { data_type => 'varchar(255)', is_nullable => 1 },
			'browser_ip', { data_type => 'varchar(255)', is_nullable => 1 },
			'customer', { data_type => 'int', is_nullable => 1 },
			'shop_id', { data_type => 'int', is_nullable => 1 });
		__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');
		__PACKAGE__->set_primary_key('id');
		
		__PACKAGE__->has_many(ordersline_items => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::OrderLineItem', 'order_id');
		__PACKAGE__->many_to_many(line_items => 'ordersline_items', 'line_item');
		__PACKAGE__->has_many(fufillments => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Fulfillment', 'order_id');
		__PACKAGE__->has_many(note_attributes => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::NoteAttributes', 'parent_id');
		__PACKAGE__->has_many(discount_codes => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::DiscountCode', 'parent_id');
		__PACKAGE__->has_many(shipping_lines => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::ShippingLine', 'parent_id');
		__PACKAGE__->has_many(tax_lines => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::TaxLine', 'parent_id');
		__PACKAGE__->belongs_to(customer => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Customer', 'customer');
		sub represents($) { return 'WWW::Shopify::Model::Order'; }
		
	

1;