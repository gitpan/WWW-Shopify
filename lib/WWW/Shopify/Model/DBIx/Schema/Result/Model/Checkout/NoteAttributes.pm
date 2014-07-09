
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Checkout::NoteAttributes;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_checkouts_note_attributes');
__PACKAGE__->add_columns(
	"checkout_id", { data_type => 'bigint' },
	"name", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"value", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"id", { data_type => 'BIGINT', is_nullable => 0, is_auto_increment => 1 }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::Checkout::NoteAttributes'; }
sub parent_variable { return 'checkout_id'; }

1;