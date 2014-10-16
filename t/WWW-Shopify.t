use strict;
use Test::More;

BEGIN { 
	use_ok('WWW::Shopify');
	use_ok('WWW::Shopify::Test');
	use_ok('WWW::Shopify::Model::DBIx::Schema');
	use_ok('WWW::Shopify::Public', 'scope_compare');
}


is(scope_compare(["read_products"], ["write_products"]), 1);
is(scope_compare(["write_products"], ["read_products"]), -1);
is(scope_compare(["write_products"], ["write_products", "write_orders"]), 1);
is(scope_compare(["read_products"], ["write_products", "write_orders"]), 1);
is(scope_compare(["write_products", "write_script_tag"], ["write_products", "write_orders"]), undef);

# Never mind. I'll fix this up when I have time.

# my $dbname = "shopify_test.db";
# my $db = WWW::Shopify::Model::DBIx::Schema->connect('dbi:SQLite:dbname=' . $dbname, { RaiseError => 1, AutoCommit => 1 });
# ok($db);
# print STDERR "Setup db at $dbname.\n";

# my $sa = new WWW::Shopify::Test($db);

# $db->deploy({ add_drop_table => 1 });
# $sa->generate('WWW::Shopify::Model::Shop' => 1, 'WWW::Shopify::Model::Product' => 5);

# $sa->associate_randomly;
# $sa->access_token("asdkjfhslkjdghlk");

# my @products = $sa->get_all('Product');
# cmp_ok(int(@products), '>', 0);

# my $product1 = $products[int(rand(@products))];
# my $product2 = $sa->get('WWW::Shopify::Model::Product', $product1->id);
# is($product1->id, $product2->id);
# is($product1->handle, $product2->handle);
# is($sa->associate->id, $sa->get_shop->id);

# my $product = $sa->create(new WWW::Shopify::Model::Product({
	# title => "TestName",
	# body_html => "<p>Description</p>",
	# vendor => "Shopify",
	# product_type => "TestType",
	# variants => [
		# new WWW::Shopify::Model::Product::Variant({
			# "option1" => "var1",
			# "price" => 20.0
		# }),
		# new WWW::Shopify::Model::Product::Variant({
			# "option1" => "var2",
			# "price" => 30.0
		# })
	# ]
# }));
#ok($product);
#is($product->title, "TestName");
#is(int(@{$product->variants}), 2);

done_testing;

1;
