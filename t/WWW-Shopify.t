use strict;
use Test::More;

BEGIN { 
	use_ok('WWW::Shopify');
	use_ok('WWW::Shopify::Test');
	use_ok('WWW::Shopify::Model::DBIx::Schema');
	use_ok('File::Temp');
}

my $dbname = tmpnam();
my $db = WWW::Shopify::Model::DBIx::Schema->connect('dbi:SQLite:dbname=' . $dbname, { RaiseError => 1, AutoCommit => 1 });
ok($db);
print STDERR "Setup db at $dbname.\n";

my $sa = new WWW::Shopify::Test($db);

$db->deploy({ add_drop_table => 1 });
$sa->generate(['WWW::Shopify::Model::Shop', 'WWW::Shopify::Model::Product']);

$sa->associate_randomly;

my @products = $sa->get_all('Product');
cmp_ok(int(@products), '>', 0);

my $product1 = $products[int(rand(@products))];
my $product2 = $sa->get('WWW::Shopify::Model::Product', $product1->id);
is($product1->id, $product2->id);
is($product1->handle, $product2->handle);
is($sa->associate->id, $sa->get_shop->id);

my $product = $sa->create(new WWW::Shopify::Model::Product({
	title => "TestName",
	body_html => "<p>Description</p>",
	vendor => "Shopify",
	product_type => "TestType",
	variants => [
		new WWW::Shopify::Model::Product::Variant({
			"option1" => "var1",
			"price" => 20.0
		}),
		new WWW::Shopify::Model::Product::Variant({
			"option1" => "var2",
			"price" => 30.0
		})
	]
}));
#ok($product);
#is($product->title, "TestName");
#is(int(@{$product->variants}), 2);

done_testing;

1;
