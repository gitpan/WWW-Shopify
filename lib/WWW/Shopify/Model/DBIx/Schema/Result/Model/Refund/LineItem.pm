
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Refund::LineItem;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_refunds_line_items');
__PACKAGE__->add_columns(
	"refund_id", { data_type => 'bigint' },
	"quantity", { data_type => 'INT', is_nullable => '1' },
	"id", { is_nullable => '0', data_type => 'BIGINT' },
	"line_item_id", { data_type => 'BIGINT', is_nullable => '1' },
	"line_item_id", { data_type => 'BIGINT', is_nullable => '1' }
);
__PACKAGE__->set_primary_key('id');





__PACKAGE__->belongs_to(line_item => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem', 'line_item_id');
__PACKAGE__->belongs_to(line_item => 'WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::LineItem', 'line_item_id');
sub represents { return 'WWW::Shopify::Model::Refund::LineItem'; }
sub parent_variable { return 'refund_id'; }

1;