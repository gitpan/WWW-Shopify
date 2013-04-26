
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.

package WWW::Shopify::Model::DBIx::Schema::Result::Model::OrderNoteAttributes;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('shopify_ordersnote_attributes');
__PACKAGE__->add_columns(
	'order_id', { data_type => 'INT', is_nullable => 0 },
	'note_attribute_id', { data_type => 'INT', is_nullable => 0 }
);
__PACKAGE__->belongs_to(order => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order', 'order_id');
__PACKAGE__->belongs_to(note_attribute => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::NoteAttributes', 'note_attribute_id');

1;