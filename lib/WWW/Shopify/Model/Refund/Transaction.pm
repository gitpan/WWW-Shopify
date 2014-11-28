package WWW::Shopify::Model::Refund::Transaction;
use parent 'WWW::Shopify::Model::Transaction';


sub parent { return 'WWW::Shopify::Model::Refund'; }
sub included_in_parent { return 1; }
sub is_nested { return 1; }

1;