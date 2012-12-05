use strict;
use Test::More tests => 9;

BEGIN { 
	use_ok('WWW::Shopify');
	use_ok('WWW::Shopify::Test');
	use_ok('WWW::Shopify::Model::DBIx::Schema');
	use_ok('File::Temp');
}

my $db = WWW::Shopify::Model::DBIx::Schema->connect('dbi:SQLite:dbname=' . tmpnam(), { RaiseError => 1, AutoCommit => 1 });
ok($db);

my $sa = new WWW::Shopify::Test($db);

$db->deploy({ add_drop_table => 1 });
$sa->generate(['WWW::Shopify::Model::Shop', 'WWW::Shopify::Model::Product']);

$sa->associate_randomly;

my @products = $sa->get_all('WWW::Shopify::Model::Product');
cmp_ok(int(@products), '>', 0);

my $product1 = $products[int(rand(@products))];
my $product2 = $sa->get('WWW::Shopify::Model::Product', $product1->id);
is($product1->id, $product2->id);
is($product1->description, $product2->description);
is($sa->associate->id, $sa->get_shop->id);

done_testing;

1;
