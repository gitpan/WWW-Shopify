
#!/usr/bin/perl
# NOTE - THIS FILE GENERATED BY DBIxGenerate.pl.
# To regenerate this file, simply call the script, and it'll dump the DBIx files into the working directory.

=head1 NAME

WWW::Shopify::Model::DBIx::Schema::Result::Model::RecurringApplicationCharge - Database Object for WWW::Shopify::Model::RecurringApplicationCharge.

=cut

=head1 NOTICE

This is a generated class, made by WWW::Shopify/Utils/DBIxGenerate.pl. Do not modify.

=cut

use strict;
use warnings;


		package WWW::Shopify::Model::DBIx::Schema::Result::Model::RecurringApplicationCharge;
		use base qw/DBIx::Class::Core/;
		
		__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
		__PACKAGE__->table('shopify_recurring_application_charges');	
		__PACKAGE__->add_columns('test', { data_type => 'bool', is_nullable => 1 },
			'trial_days', { data_type => 'int', is_nullable => 1 },
			'status', { data_type => 'varchar(255)', is_nullable => 1 },
			'name', { data_type => 'varchar(255)', is_nullable => 1 },
			'cancelled_on', { data_type => 'datetime', is_nullable => 1 },
			'trial_ends_on', { data_type => 'datetime', is_nullable => 1 },
			'return_url', { data_type => 'varchar(255)', is_nullable => 1 },
			'created_at', { data_type => 'datetime', is_nullable => 1 },
			'confirmation_url', { data_type => 'varchar(255)', is_nullable => 1 },
			'updated_at', { data_type => 'datetime', is_nullable => 1 },
			'id', { data_type => 'int',  },
			'activated_on', { data_type => 'varchar(255)', is_nullable => 1 },
			'price', { data_type => 'decimal', is_nullable => 1 },
			'billing_on', { data_type => 'datetime', is_nullable => 1 },
			'shop_id', { data_type => 'int', is_nullable => 1 });
		__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');
		__PACKAGE__->set_primary_key('id');
		
		
		sub represents($) { return 'WWW::Shopify::Model::RecurringApplicationCharge'; }
		
		
	

1;