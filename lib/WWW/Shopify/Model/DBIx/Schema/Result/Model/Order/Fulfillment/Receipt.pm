
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Fulfillment::Receipt;
use base qw/DBIx::Class::Core/;

__PACKAGE__->load_components(qw/InflateColumn::DateTime/);

__PACKAGE__->table('shopify_fulfillments_receipts');
__PACKAGE__->add_columns(
	"fulfillment_id", { data_type => 'bigint' },
	"testcase", { is_nullable => '1', data_type => 'BOOL' },
	"authorization", { is_nullable => '1', data_type => 'VARCHAR(255)' },
	"id", { data_type => 'BIGINT', is_nullable => 0, is_auto_increment => 1 }
);
__PACKAGE__->set_primary_key('id');






sub represents { return 'WWW::Shopify::Model::Order::Fulfillment::Receipt'; }
sub parent_variable { return 'fulfillment_id'; }

1;