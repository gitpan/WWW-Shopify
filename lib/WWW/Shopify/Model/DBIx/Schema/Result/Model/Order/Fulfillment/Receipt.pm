
#!/usr/bin/perl
use strict;
use warnings;
# This class is generated from DBIx.pm. Do not modify.
package WWW::Shopify::Model::DBIx::Schema::Result::Model::Order::Fulfillment::Receipt;
use base qw/DBIx::Class::Core/;


__PACKAGE__->table('shopify_fulfillments_receipts');
__PACKAGE__->add_columns(
	"authorization", { data_type => 'VARCHAR(255)', is_nullable => '1' },
	"testcase", { data_type => 'BOOL', is_nullable => '1' },
	"fulfillment_id", { data_type => 'INT' },
	"id", { data_type => 'INT' }
);
__PACKAGE__->set_primary_key('id');




sub represents { return 'WWW::Shopify::Model::Order::Fulfillment::Receipt'; }
sub parent_variable { return 'fulfillment_id'; }

1;