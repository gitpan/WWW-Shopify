#!/usr/bin/perl
use strict;
use warnings;

package WWW::Shopify::Tooltips;
use WWW::Shopify;

use Exporter qw(import);

my $tooltips = {
          'WWW::Shopify::Model::Shop' => {
                                           'source' => '',
                                           'google_apps_domain' => 'Feature is present when a shop has a google app domain. It will be returned as a URL. If the shop does not have this feature enabled it will default to "null."',
                                           'country_code' => 'The two-letter country code corresponding to the shop\'s country.',
                                           'taxes_included' => 'The setting for whether applicable taxes are included in product prices. Valid values are: "true" or "null."',
                                           'money_format' => 'A string representing the way currency is formatted when the currency isn\'t specified.',
                                           'tax_shipping' => 'The setting for whether applicable taxes are included in product prices: Valid values are: "true" or "null."',
                                           'email' => 'The contact email address for the shop.',
                                           'currency' => 'The three-letter code for the currency that the shop accepts.',
                                           'domain' => 'The shop\'s domain.',
                                           'city' => 'The city in which the shop is located.',
                                           'created_at' => 'The date and time when the shop was created. The API returns this value in ISO 8601 format.',
                                           'latitude' => 'Geographic coordinate specifying the north/south location of a shop.',
                                           'public' => '',
                                           'myshopify_domain' => 'The shop\'s \'myshopify.com\' domain.',
                                           'google_apps_login_enabled' => 'Feature is present if a shop has google apps enabled. Those shops with this feature will be able to login to the google apps login. Shops without this feature enabled will default to "null."',
                                           'shop_owner' => 'The username of the shop owner.',
                                           'province_code' => 'The two-letter code for the shop\'s province or state.',
                                           'province' => 'The shop\'s normalized province or state name.',
                                           'id' => 'A unique numeric identifier for the shop.',
                                           'country' => 'The shop\'s country (by default equal to the two-letter country code).',
                                           'country_name' => 'The shop\'s normalized country name.',
                                           'longitude' => 'Geographic coordinate specifying the east/west location of a shop.',
                                           'timezone' => 'The name of the timezone the shop is in.',
                                           'customer_email' => 'The customer\'s email.',
                                           'name' => 'The name of the shop.',
                                           'display_plan_name' => 'The display name of the Shopify plan the shop is on.',
                                           'phone' => 'The contact phone number for the shop.',
                                           'money_with_currency_format' => 'A string representing the way currency is formatted when the currency is specified.',
                                           'zip' => 'The zip or postal code of the shop\'s address.',
                                           'plan_name' => 'The name of the Shopify plan the shop is on.',
                                           'address1' => 'The shop\'s street address.'
                                         },
          'WWW::Shopify::Model::ProductSearchEngine' => {
                                                          'created_at' => 'The date and time when the product search engine was created. The API returns this value in ISO 8601 format.',
                                                          'name' => 'The name of the product search engine.'
                                                        },
          'WWW::Shopify::Model::Order::LineItem' => {
                                                      'sku' => 'A unique identifier of the item in the fulfillment.',
                                                      'grams' => 'The weight of the item in grams.',
                                                      'fulfillment_service' => 'Service provider who is doing the fulfillment. Valid values are: manual, ',
                                                      'name' => 'The name of the product variant.',
                                                      'quantity' => 'The number of products that were purchased.',
                                                      'variant_title' => 'The title of the product variant.',
                                                      'product_id' => 'The unique numeric identifier for the product in the fulfillment.',
                                                      'fulfillment_status' => 'How far along an order is in terms line items fulfilled. Valid values are: fulfilled, null or partial.',
                                                      'variant_id' => 'The id of the product variant.',
                                                      'title' => 'The title of the product.',
                                                      'id' => 'The id of the line item.',
                                                      'price' => 'The price of the item.',
                                                      'vendor' => 'The name of the supplier of the item.',
                                                      'requires_shipping' => 'States whether or not the fulfillment requires shipping. Values are: true or false.'
                                                    },
          'WWW::Shopify::Model::Page' => {
                                           'published_at' => 'This can have two different types of values, depending on whether the page has been published (i.e., made visible to the blog\'s readers).<ul>',
                                           'shop_id' => 'The id of the shop to which the page belongs.',
                                           'metafields' => '',
                                           'author' => 'The name of the person who created the page.',
                                           'template_suffix' => 'The suffix of the liquid template being used. By default, the original template is called product.liquid, without any suffix. Any additional templates will be: product.suffix.liquid.',
                                           'created_at' => 'The date and time when the page was created. The API returns this value in ISO 8601 format.',
                                           'handle' => 'A human-friendly unique string for the page automatically generated from its title. This is used in shop themes by the Liquid templating language to refer to the page.',
                                           'updated_at' => 'The date and time when the page was last updated. The API returns this value in ISO 8601 format.',
                                           'title' => 'The title of the page.',
                                           'body_html' => 'Text content of the page, complete with HTML markup.',
                                           'id' => 'The unique numeric identifier for the page.'
                                         },
          'WWW::Shopify::Model::Product::Variant' => {
                                                       'sku' => 'A unique identifier for the product in the shop.',
                                                       'grams' => 'The weight of the product variant in grams.',
                                                       'position' => 'The order of the product variant in the list of product variants. 1 is the first position.',
                                                       'metafields' => 'Attaches additional information to a shop\'s resources.',
                                                       'taxable' => 'Specifies whether or not a tax is charged when the product variant is sole.',
                                                       'inventory_quantity' => 'The number of items in stock for this product variant.',
                                                       'compare_at_price' => 'The competitors price for the same item.',
                                                       'created_at' => 'The date and time when the product variant was created. The API returns this value in ISO 8601 format.',
                                                       'product_id' => 'The unique numeric identifier for the product.',
                                                       'updated_at' => 'The date and time when the product variant was last modified. The API returns this value in ISO 8601 format.',
                                                       'title' => 'The title of the product variant.',
                                                       'price' => 'The price of the product variant.',
                                                       'id' => 'The unique numeric identifier for the product variant.',
                                                       'inventory_policy' => 'Specifies whether or not customers are allowed to place an order for a product variant when it\'s out of stock.',
                                                       'requires_shipping' => 'Specifies whether or not a customer needs to provide a shipping address when placing an order for this product variant.'
                                                     },
          'WWW::Shopify::Model::SmartCollection' => {
                                                      'published_at' => 'This can have two different types of values, depending on whether the smart collection has been published (i.e., made visible to customers):<ul>',
                                                      'rules' => '',
                                                      'published_scope' => 'The sales channels in which the smart collection is visible.',
                                                      'template_suffix' => 'The suffix of the template you are using. By default, the original template is called product.liquid, without any suffix. Any additional templates will be: product.suffix.liquid.',
                                                      'handle' => 'A human-friendly unique string for the smart collection automatically generated from its title. This is used in shop themes by the Liquid templating language to refer to the smart collection.',
                                                      'updated_at' => 'The date and time when the smart collection was last modified. The API returns this value in ISO 8601 format.',
                                                      'body_html' => 'The best selling ipod ever',
                                                      'id' => 'The unique numeric identifier for the smart collection.',
                                                      'title' => 'The name of the smart collection.'
                                                    },
          'WWW::Shopify::Model::CustomerGroup' => {
                                                    'created_at' => 'The date and time when the customer group was created. The API returns this value in ISO 8601 format.',
                                                    'updated_at' => 'The date and time when the customer group was last modified. The API returns this value in ISO 8601 format.',
                                                    'query' => 'The set of conditions that determines which customers will go into the customer group. Queries are covered in more detail in Customer group queries, below.',
                                                    'name' => 'The name given by the shop owner to the customer group.',
                                                    'id' => 'A unique numeric identifier for the customer group.'
                                                  },
          'WWW::Shopify::Model::Order::ShippingLine' => {
                                                          'source' => '',
                                                          'title' => '',
                                                          'price' => 'The price of this shipping method.',
                                                          'code' => 'A reference to the shipping method.'
                                                        },
          'WWW::Shopify::Model::Item' => {},
          'WWW::Shopify::Model::Order::PaymentDetails' => {
                                                            'credit_card_company' => 'The name of the company who issued the customer\'s credit card.',
                                                            'avs_result_code' => 'The Response code from  AVS the address verification system. The code is a single letter; see  this chart for the codes and their definitions.',
                                                            'credit_card_bin' => 'The  issuer identification number (IIN), formerly known as bank identification number (BIN) ] of the customer\'s credit card. This is made up of the first few digits of the credit card number.',
                                                            'cvv_result_code' => 'The Response code from the credit card company indicating whether the customer entered the  card security code, a.k.a. card verification value, correctly. The code is a single letter or empty string; see  this chart for the codes and their definitions.'
                                                          },
          'WWW::Shopify::Model::Transaction' => {},
          'WWW::Shopify::Model::Article' => {
                                              'summary_html' => 'The text of the summary of the article, complete with HTML markup.',
                                              'published_at' => 'The date and time when the article was published. The API returns this value in ISO 8601 format.',
                                              'metafields' => 'Attaches additional metadata to a shop\'s resources:<ul>      ',
                                              'author' => 'The name of the author of this article',
                                              'tags' => 'Tags are additional short descriptors. Tags are formatted as a string of comma-separated values. For example, if an article has three tags: tag1, tag2, tag3.',
                                              'published' => 'States whether or not the article is visible. Valid values are: "true" for published or "false" for hidden.',
                                              'created_at' => '',
                                              'updated_at' => 'The date and time when the article was last updated. The API returns this value in ISO 8601 format.',
                                              'user_id' => 'A unique numeric identifier for the author of the article.',
                                              'title' => 'The title of the article.',
                                              'blog_id' => 'A unique numeric identifier for the blog containing the article.',
                                              'body_html' => 'The text of the body of the article, complete with HTML markup.',
                                              'id' => ''
                                            },
          'WWW::Shopify::Model::Checkout' => {},
          'WWW::Shopify::Model::Blog' => {
                                           'feedburner_location' => 'URL to the feedburner location for blogs that have enabled feedburner through their shop admin.',
                                           'metafields' => 'metafield description',
                                           'feedburner' => 'Feedburner is a web feed management provider and can be enabled to provide custom RSS feeds for Shopify bloggers. This property will default to blank or "null" unless feedburner is enabled through the shop admin.',
                                           'tags' => 'Tags are additional short descriptors. Tags are formatted as a string of comma-separated values. For example, if an article has three tags: tag1, tag2, tag3.',
                                           'template_suffix' => 'The suffix of the liquid template being used. By default, the original template is called product.liquid, without any suffix. Any additional templates will be: product.suffix.liquid.',
                                           'created_at' => 'The date and time when the blog was created. The API returns this value in ISO 8601 format.',
                                           'handle' => 'A human-friendly unique string for a blog automatically generated from its title. This handle is used by the Liquid templating language to refer to the blog.',
                                           'updated_at' => 'The date and time when changes were last made to the blog\'s properties. Note that this is not updated when creating, modifying or deleting articles in the blog. The API returns this value in ISO 8601 format.',
                                           'title' => 'The title of the blog.',
                                           'id' => 'A unique numeric identifier for the blog.',
                                           'commentable' => 'Indicates whether readers can post comments to the blog and if comments are moderated or not. Possible values are:'
                                         },
          'WWW::Shopify::Model::Customer' => {
                                               'last_order_name' => 'The name of the customer\'s last order. This is directly related to the Order\'s name field.',
                                               'orders_count' => 'The number of orders associated with this customer.',
                                               'state' => 'The state of the customer in a shop.  Customers start out as "disabled."  They are invited by email to setup an account with a shop.  The customer can then:',
                                               'last_name' => 'The customer\'s last name.',
                                               'email' => 'The name of the author of this article',
                                               'created_at' => 'The name of the author of this article',
                                               'multipass_identifier' => 'The customer\'s identifier used with Multipass login',
                                               'id' => 'The name of the author of this article',
                                               'last_order_id' => 'The id of the customer\'s last order.',
                                               'metafields' => '',
                                               'accepts_marketing' => 'Indicates whether the customer has consented to be sent marketing material via email. Valid values are "true" and "false."',
                                               'note' => 'A note about the customer.',
                                               'tags' => 'Tags are additional short descriptors. Tags are formatted as a string of comma-separated values. For example, if an article has three tags: tag1, tag2, tag3.',
                                               'addresses' => '',
                                               'updated_at' => 'The date and time when the customer information was updated. The API returns this value in ISO 8601 format.',
                                               'first_name' => 'The name of the author of this article',
                                               'total_spent' => 'The total amount of money that the customer has spent at the shop.'
                                             },
          'WWW::Shopify::Model::ApplicationCharge' => {
                                                        'price' => 'The price of the thing'
                                                      },
          'WWW::Shopify::Model::Order::Fulfillment' => {
                                                         'line_items' => 'A historical record of each item in the fulfillment.',
                                                         'status' => 'The status of the fulfillment.',
                                                         'order_id' => 'The unique numeric identifier for the order.',
                                                         'tracking_number' => 'The shipping number, provided by the shipping company.',
                                                         'created_at' => 'The date and time when the fulfillment was created. The API returns this value in ISO 8601 format.',
                                                         'updated_at' => 'The date and time when the fulfillment was last modified. The API returns this value in ISO 8601 format.',
                                                         'id' => 'The unique numeric identifier for the fulfillment.',
                                                         'tracking_company' => 'The name of the shipping company.',
                                                         'receipt' => ''
                                                       },
          'WWW::Shopify::Model::Order' => {
                                            'total_price' => 'The sum of all the prices of all the items in the order, taxes and discounts included.',
                                            'line_items' => '',
                                            'closed_at' => 'The date and time when the order was closed. If the order was closed, the API returns this value in ISO 8601 format. If the order was not closed, this value is null.',
                                            'billing_address' => '',
                                            'taxes_included' => '',
                                            'email' => 'The customer\'s email address.',
                                            'id' => 'The unique numeric identifier for the order. This one is used for API purposes. This is different from the order_number property (see below), which is also a unique numeric identifier for the order, but used by the shopowner and customer.',
                                            'payment_details' => '',
                                            'total_discounts' => 'The total amount of the discounts to be applied to the price of the order.',
                                            'order_number' => 'A unique numeric identifier for the order. This one is used by the shop owner and customer. This is different from the id property, which is also a unique numeric identifier for the order, but used for API purposes.',
                                            'financial_status' => '<ul>',
                                            'landing_site' => 'The URL for the page where the buyer landed when entering the shop.',
                                            'name' => 'The customer\'s order name as represented by a number.',
                                            'cart_token' => 'Unique identifier for a particular cart that is attached to a particular order.',
                                            'total_line_items_price' => 'The sum of all the prices of all the items in the order.',
                                            'note_attributes' => 'Extra information that is added to the order.',
                                            'updated_at' => 'The date and time when the order was last modified. The API returns this value in ISO 8601 format.',
                                            'shipping_address' => '',
                                            'fulfillment_status' => '<ul>',
                                            'subtotal_price' => 'Price of the order before shipping and taxes',
                                            'total_tax' => 'The sum of all the taxes applied to the line items in the order.',
                                            'number' => 'Numerical idetnifier unique to the shop. A number is sequential and starts at 1000.',
                                            'discount_codes' => 'Applicable discount codes that can be applied to the order. If no codes exist the value will default to blank.',
                                            'gateway' => 'The payment gateway used.',
                                            'shipping_lines' => '',
                                            'buyer_accepts_marketing' => 'Indicates whether or not the person who placed the order would like to receive email updates from the shop. This is set when checking the "I want to receive occasional emails about new products, promotions and other news" checkbox during checkout. Valid values are "true" and "false."',
                                            'cancel_reason' => 'The reason why the order was cancelled. If the order was not cancelled, this value is "null." If the order was cancelled, the value will be one of the following:',
                                            'currency' => 'The three letter code (ISO 4217) for the currency used for the payment.',
                                            'created_at' => 'The date and time when the order was created. The API returns this value in ISO 8601 format.',
                                            'token' => 'Unique identifier for a particular order.',
                                            'total_weight' => 'The sum of all the weights of the line items in the order, in grams.',
                                            'cancelled_at' => 'The date and time when the order was cancelled. If the order was cancelled, the API returns this value in ISO 8601 format. If the order was not cancelled, this value is "null."',
                                            'tax_lines' => '',
                                            'processing_method' => '',
                                            'referring_site' => 'The website that the customer clicked on to come to the shop.',
                                            'note' => 'The text of an optional note that a shopowner can attach to the order.',
                                            'browser_ip' => 'The IP address of the browser used by the customer when placing the order.',
                                            'customer' => '',
                                            'fulfillments' => ''
                                          },
          'WWW::Shopify::Model::CustomCollection::Collect' => {
                                                                'position' => 'A number specifying the order in which the product appears in the custom collection, with 1 denoting the first item in the collection. This value applies only when the custom collection\'s sort-order property is set to manual.',
                                                                'sort_value' => 'The name of the product.',
                                                                'created_at' => 'The date and time when the collect was created. The API returns this value in ISO 8601 format.',
                                                                'featured' => '',
                                                                'product_id' => 'The unique numeric identifier for the product in the custom collection.',
                                                                'updated_at' => 'The date and time when the collect was last updated. The API returns this value in ISO 8601 format.',
                                                                'collection_id' => 'The id of the custom collection containing the product.',
                                                                'id' => 'A unique numeric identifier for the collect.'
                                                              },
          'WWW::Shopify::Model::RecurringApplicationCharge' => {},
          'WWW::Shopify::Model::SmartCollection::Rule' => {
                                                            'relation' => ' The relation between the identifier for the condition and the numeric amount.',
                                                            'column' => '',
                                                            'condition' => ' Select products for a collection using a condition.'
                                                          },
          'WWW::Shopify::Model::Order::Risk' => {},
          'WWW::Shopify::Model::Address' => {
                                              'country_code' => 'The two-letter country code corresponding to the customer\'s country.',
                                              'last_name' => 'The customer\'s last name.',
                                              'city' => 'The customer\'s city.',
                                              'latitude' => 'The latitude of the billing address.',
                                              'id' => 'A unique numeric identifier for the address.',
                                              'province_code' => 'The two-letter pcode for the customer\'s province or state.',
                                              'province' => 'The customer\'s province or state name.',
                                              'company' => 'The customer\'s company.',
                                              'country' => 'The customer\'s country.',
                                              'longitude' => 'The longitude of the billing address.',
                                              'name' => 'The customer\'s name.',
                                              'phone' => 'The customer\'s phone number.',
                                              'address2' => 'An additional field for the customer\'s mailing address.',
                                              'zip' => 'The customer\'s zip or postal code.',
                                              'address1' => 'The customer\'s mailing address.',
                                              'first_name' => 'The customer\'s first name.'
                                            },
          'WWW::Shopify::Model::Asset' => {
                                            'attachment' => 'An asset attached to a shop\'s theme.',
                                            'value' => 'The asset that you are adding.',
                                            'src' => 'Specifies the location of an asset.',
                                            'source_key' => 'The source key copies an asset.',
                                            'public_url' => 'The public facing URL of the asset.',
                                            'size' => 'The asset size in bytes.',
                                            'key' => 'The path to the asset within a shop. For example, the asset bg-body-green.gif is located in the assets folder.',
                                            'created_at' => 'The date and time when the asset was created. The API returns this value in ISO 8601 format.',
                                            'content_type' => 'MIME representation of the content, consisting of the type and subtype of the asset.',
                                            'updated_at' => 'The date and time when an asset was last updated. The API returns this value in ISO 8601 format.'
                                          },
          'WWW::Shopify::Model::CustomCollection' => {
                                                       'published_at' => 'This can have two different types of values, depending on whether the custom collection has been published (i.e., made visible to customers):<ul>',
                                                       'sort_order' => 'The order in which products in the custom collection appear. Valid values are:<ul>',
                                                       'metafields' => '',
                                                       'published_scope' => 'The sales channels in which the custom collection is visible.',
                                                       'image' => 'Image associated with the custom collection. Valid values are:',
                                                       'template_suffix' => 'The suffix of the liquid template being used. By default, the original template is called product.liquid, without any suffix. Any additional templates will be: product.suffix.liquid.',
                                                       'published' => 'States whether the custom collection is visible. Valid values are "true" for visible and "false" for hidden.',
                                                       'handle' => 'A human-friendly unique string for the custom collection automatically generated from its title. This is used in shop themes by the Liquid templating language to refer to the custom collection.',
                                                       'updated_at' => 'The date and time when the custom collection was last modified. The API returns this value in ISO 8601 format.',
                                                       'title' => 'The name of the custom collection.',
                                                       'body_html' => 'The description of the custom collection, complete with HTML markup. Many templates display this on their custom collection pages.',
                                                       'id' => 'The unique numeric identifier for the custom collection.'
                                                     },
          'WWW::Shopify::Model::Order::TaxLine' => {
                                                     'rate' => 'The rate of tax to be applied.',
                                                     'title' => 'The name of the tax.',
                                                     'price' => 'The amount of tax to be charged.'
                                                   },
          'WWW::Shopify::Model::Metafield' => {
                                                'namespace' => 'Container for a set of metadata. Namespaces help distinguish between metadata you created against metadata created by another individual with a similar namespace (maximum of 20 characters).',
                                                'value' => 'Information to be stored as metadata.',
                                                'description' => 'Additional information about the metafield. This property is optional.',
                                                'key' => 'Identifier for the metafield (maximum of 30 characters).',
                                                'value_type' => 'States whether the information in the value is stored as a \'string\' or \'integer.\'',
                                                'created_at' => 'The date and time when the metafield was created. The API returns this value in ISO 8601 format.',
                                                'updated_at' => 'The date and time when the metafield was published. The API returns this value in ISO 8601 format.',
                                                'id' => 'Unique numeric identifier for the metafield.',
                                                'owner_id' => 'A unique numeric identifier for the metafield\'s owner.',
                                                'owner_resource' => 'Unique id for that particular resource.'
                                              },
          'WWW::Shopify::Model::Cart' => {},
          'WWW::Shopify::Model::Theme' => {
                                            'created_at' => 'The date and time when the theme was created. The API returns this value in ISO 8601 format.',
                                            'updated_at' => 'The date and time when the theme was last updated. The API returns this value in ISO 8601 format.',
                                            'name' => 'The name of the theme.',
                                            'id' => 'A unique numeric identifier for the theme.',
                                            'role' => 'Specifies how the theme is being used within the shop. Valid values are:'
                                          },
          'WWW::Shopify::Model::Redirect' => {
                                               'target' => 'The "after" path or URL to be redirected to. When the user visits the path specified by path, s/he will be redirected to this path or URL. This property can be set to any path on the shop\'s site, or any URL, even one on a completely different domain.',
                                               'path' => 'The "before" path to be redirected. When the user this path, s/he will be redirected to the path specified by target.',
                                               'id' => 'The unique numeric identifier for the redirect.'
                                             },
          'WWW::Shopify::Model::Product' => {
                                              'published_at' => 'The date and time when the product was published. The API returns this value in ISO 8601 format.',
                                              'images' => 'A list of image objects, each one representing an image associated with the product.',
                                              'options' => 'Custom product property names like "Size", "Color", and "Material". products are based on permutations of these options. A product may have a maximum of 3 options.',
                                              'tags' => 'A categorization that a product can be tagged with, commonly used for filtering and searching.',
                                              'published_scope' => 'The sales channels in which the product is visible.',
                                              'variants' => '',
                                              'template_suffix' => 'The suffix of the liquid template being used. By default, the original template is called product.liquid, without any suffix. Any additional templates will be: product.suffix.liquid.',
                                              'product_type' => 'A categorization that a product can be tagged with, commonly used for filtering and searching.',
                                              'created_at' => 'The date and time when the product was created. The API returns this value in ISO 8601 format.',
                                              'handle' => 'A human-friendly unique string for the Product automatically generated from its title. They are used by the Liquid templating language to refer to objects.',
                                              'updated_at' => 'The date and time when the product was last modified. The API returns this value in ISO 8601 format.',
                                              'title' => 'The name of the product. In a shop\'s catalog, clicking on a product\'s title takes you to that product\'s page. On a product\'s page, the product\'s title typically appears in a large font.',
                                              'body_html' => 'The description of the product, complete with HTML formatting.',
                                              'id' => 'The unique numeric identifier for the product. Product ids are unique across the entire Shopify system; no two products will have the same id, even if they\'re from different shops.',
                                              'vendor' => 'The name of the vendor of the product.'
                                            },
          'WWW::Shopify::Model::ScriptTag' => {
                                                'created_at' => 'The date and time when the ScriptTag was created. The API returns this value in ISO 8601 format.',
                                                'updated_at' => 'The date and time when the ScriptTag was last updated. The API returns this value in ISO 8601 format.',
                                                'src' => 'Specifies the location of the ScriptTag.',
                                                'id' => 'The unique numeric identifier for the ScriptTag.',
                                                'event' => 'DOM event which triggers the loading of the script. Valid values are: "onload."'
                                              },
          'WWW::Shopify::Model::Webhook' => {
                                              'topic' => 'The event that will trigger the webhook. Valid values are: orders/create, orders/delete, orders/updated, orders/paid, orders/cancelled, orders/fulfilled, orders/partially_fulfilled, carts/create, carts/update, checkouts/create, checkouts/update, checkouts/delete, products/create, products/update, products/delete, collections/create, collections/update, collections/delete, customer_groups/create, customer_groups/update, customer_groups/delete, customers/create, customers/enable, customers/disable, customers/update, customers/delete, fulfillments/create, fulfillments/update, shop/update, app/uninstalled',
                                              'created_at' => 'The date and time when the webhook was created. The API returns this value in ISO 8601 format.',
                                              'format' => 'The format in which the webhook should send the data. Valid values are json and xml.',
                                              'updated_at' => 'The date and time when the webhook was updated. The API returns this value in ISO 8601 format.',
                                              'id' => 'The unique numeric identifier for the webhook.',
                                              'address' => 'The URI where the webhook should send the POST request when the event occurs.'
                                            }
        };


our @EXPORT_OK = qw(get_tooltip);

sub get_tooltip {
	my ($package, $field_name) = @_;
	$package = WWW::Shopify->translate_model($package);
	return undef unless exists $tooltips->{$package} && $tooltips->{$package}->{$field_name};
	return $tooltips->{$package}->{$field_name};
}


1;