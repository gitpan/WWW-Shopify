
#!/usr/bin/perl
# NOTE - THIS FILE GENERATED BY DBIxGenerate.pl.
# To regenerate this file, simply call the script, and it'll dump the DBIx files into the working directory.

=head1 NAME

WWW::Shopify::Model::DBIx::Schema::Result::Model::ScriptTag - Database Object for WWW::Shopify::Model::ScriptTag.

=cut

=head1 NOTICE

This is a generated class, made by WWW::Shopify/Utils/DBIxGenerate.pl. Do not modify.

=cut

use strict;
use warnings;


		package WWW::Shopify::Model::DBIx::Schema::Result::Model::ScriptTag;
		use base qw/DBIx::Class::Core/;
		
		__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
		__PACKAGE__->table('shopify_script_tags');	
		__PACKAGE__->add_columns('created_at', { data_type => 'datetime', is_nullable => 1 },
			'src', { data_type => 'varchar(255)', is_nullable => 1 },
			'updated_at', { data_type => 'datetime', is_nullable => 1 },
			'id', { data_type => 'int',  },
			'event', { data_type => 'varchar(255)', is_nullable => 1 },
			'shop_id', { data_type => 'int', is_nullable => 1 });
		__PACKAGE__->belongs_to(shop => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Shop', 'shop_id');
		__PACKAGE__->set_primary_key('id');
		
		
		sub represents($) { return 'WWW::Shopify::Model::ScriptTag'; }
		
		
	

1;