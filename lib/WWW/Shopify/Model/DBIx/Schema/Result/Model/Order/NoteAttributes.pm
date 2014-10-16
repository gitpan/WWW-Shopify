
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::NoteAttributes;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_orders_note_attributes');
__PACKAGE__->add_columns(
	"order_id", { data_type => 'bigint' },
	"name", { data_type => 'TEXT', is_nullable => '1' },
	"value", { is_nullable => '1', data_type => 'TEXT' },
	"id", { data_type => 'BIGINT', is_nullable => 0, is_auto_increment => 1 }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::Order::NoteAttributes'; }
sub parent_variable { return 'order_id'; }

1;