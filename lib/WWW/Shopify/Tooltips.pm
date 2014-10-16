#!/usr/bin/perl
use strict;
use warnings;

package WWW::Shopify::Tooltips;
use WWW::Shopify;

use Exporter qw(import);

my $tooltips = {
          'WWW::Shopify::Model::FulfillmentService' => {
                                                         'inventory_management' => 'States if the fulfillment service tracks product inventory and provides updates to Shopify. Valid values are "true" and "false".',
                                                         'credential1' => 'Login information of the customer (usually in the form of an email address).',
                                                         'name' => 'The name of the fulfillment service as seen by merchants and their customers.',
                                                         'callback_url' => 'States the URL endpoint that Shopify needs to retrieve inventory and tracking updates. This field is necessary if either inventory_management or tracking_support is set to "true".',
                                                         'provider_id' => 'A unique identifier for the fulfillment service provider.',
                                                         'requires_shipping_method' => 'States if the fulfillment service requires products to be physically shipped. Valid values are "true" and "false".',
                                                         'tracking_support' => 'States if the fulfillment service provides tracking numbers for packages. Valid values are "true" and "false".',
                                                         'credential2_exists' => 'States whether or not there is a password for the login information of the customer. Valid values are "true" or "false".',
                                                         'format' => 'Specifies the format of the API output. Valid values are json and xml.',
                                                         'handle' => 'A human-friendly unique string for the fulfillment service generated from its title.'
                                                       },
          'WWW::Shopify::Model::Shop' => {
                                           'source' => '',
                                           'google_apps_domain' => 'Feature is present when a shop has a google app domain. It will be returned as a URL. If the shop does not have this feature enabled it will default to "null."',
                                           'country_code' => 'The two-letter country code corresponding to the shop\'s country.',
                                           'taxes_included' => 'The setting for whether applicable taxes are included in product prices. Valid values are: "true" or "null."',
                                           'money_format' => 'A string representing the way currency is formatted when the currency isn\'t specified.',
                                           'tax_shipping' => 'Specifies wether or not taxes were charged for shipping. Valid values are: "true" or "false."',
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
          'WWW::Shopify::Model::Event' => {
                                            'subject_type' => 'The type of the resource that generated the event. This will be one of the following:<ul>',
                                            'message' => 'Human readable text that describes the event.',
                                            'body' => 'A text field containing information about the event.',
                                            'created_at' => 'The date and time when the event was created. The API returns this value in ISO 8601 format.',
                                            'subject_id' => 'The id of the resource that generated the event.',
                                            'verb' => 'The type of event that took place. Different resources generate different types of event; see Resources and their event verbs and messages (below) for details.',
                                            'arguments' => 'Refers to a certain event and its resources.',
                                            'id' => 'The unique numeric identifier for the event.'
                                          },
          'WWW::Shopify::Model::ProductSearchEngine' => {},
          'WWW::Shopify::Model::Order::LineItem' => {
                                                      'sku' => 'A unique identifier of the item in the fulfillment.',
                                                      'fulfillment_service' => 'Service provider who is doing the fulfillment. Valid values are either "manual" or the name of the provider. eg: "amazon", "shipwire", etc.',
                                                      'gift_card' => 'States wether or not the line_item is a gift card. If so, the item is not taxed or considered for shipping charges.',
                                                      'product_id' => 'The unique numeric identifier for the product in the fulfillment. Can be null if the original product associated with the order is deleted at a later date',
                                                      'id' => 'The id of the line item.',
                                                      'grams' => 'The weight of the item in grams.',
                                                      'tax_lines' => 'A list of <code>tax_line</code> objects, each of which details the taxes applicable to this line_item.',
                                                      'quantity' => 'The number of products that were purchased.',
                                                      'name' => 'The name of the product variant.',
                                                      'taxable' => 'States whether or not the product was taxable. Values are: true or false.',
                                                      'variant_title' => 'The title of the product variant.',
                                                      'fulfillment_status' => 'How far along an order is in terms line items fulfilled. Valid values are: fulfilled, null or partial.',
                                                      'variant_id' => 'The id of the product variant.',
                                                      'price' => 'The price of the item.',
                                                      'title' => 'The title of the product.',
                                                      'requires_shipping' => 'States whether or not the fulfillment requires shipping. Values are: true or false.',
                                                      'vendor' => 'The name of the supplier of the item.'
                                                    },
          'WWW::Shopify::Model::Refund' => {
                                             'created_at' => 'The date and time when the refund was created. The API returns this value in ISO 8601 format.',
                                             'refund_line_items' => '',
                                             'transactions' => 'The list of transactions involved in the refund.',
                                             'restock' => 'Whether or not the line items were added back to the store inventory.',
                                             'user_id' => 'The unique identifier of the user who performed the refund.',
                                             'id' => 'The unique numeric identifier for the refund. This one is used for API purposes.',
                                             'note' => 'The optional note attached to a refund.'
                                           },
          'WWW::Shopify::Model::Page' => {
                                           'published_at' => 'This can have two different types of values, depending on whether the page has been published (i.e., made visible to the blog\'s readers).<ul>',
                                           'shop_id' => 'The id of the shop to which the page belongs.',
                                           'metafields' => '',
                                           'author' => 'The name of the person who created the page.',
                                           'template_suffix' => 'The suffix of the liquid template being used. By default, the original template is called page.liquid, without any suffix. Any additional templates will be: page.suffix.liquid.',
                                           'created_at' => 'The date and time when the page was created. The API returns this value in ISO 8601 format.',
                                           'handle' => 'A human-friendly unique string for the page automatically generated from its title. This is used in shop themes by the Liquid templating language to refer to the page.',
                                           'updated_at' => 'The date and time when the page was last updated. The API returns this value in ISO 8601 format.',
                                           'title' => 'The title of the page.',
                                           'body_html' => 'Text content of the page, complete with HTML markup.',
                                           'id' => 'The unique numeric identifier for the page.'
                                         },
          'WWW::Shopify::Model::Checkout::ShippingLine' => {
                                                             'title' => '',
                                                             'price' => 'The price of this shipping method.'
                                                           },
          'WWW::Shopify::Model::SmartCollection' => {
                                                      'published_at' => 'This can have two different types of values, depending on whether the smart collection has been published (i.e., made visible to customers):<ul>',
                                                      'sort_order' => 'The order in which products in the smart collection appear. Valid values are:<ul>',
                                                      'rules' => '',
                                                      'published_scope' => 'The sales channels in which the smart collection is visible.',
                                                      'image' => 'The collection image.',
                                                      'template_suffix' => 'The suffix of the template you are using. By default, the original template is called product.liquid, without any suffix. Any additional templates will be: product.suffix.liquid.',
                                                      'handle' => 'A human-friendly unique string for the smart collection automatically generated from its title. This is used in shop themes by the Liquid templating language to refer to the smart collection.',
                                                      'updated_at' => 'The date and time when the smart collection was last modified. The API returns this value in ISO 8601 format.',
                                                      'title' => 'The name of the smart collection.',
                                                      'body_html' => 'The best selling ipod ever',
                                                      'id' => 'The unique numeric identifier for the smart collection.'
                                                    },
          'WWW::Shopify::Model::CustomerGroup' => {
                                                    'created_at' => 'The date and time when the customer group was created. The API returns this value in ISO 8601 format.',
                                                    'updated_at' => 'The date and time when the customer group was last modified. The API returns this value in ISO 8601 format.',
                                                    'query' => 'The set of conditions that determines which customers will go into the customer group. Queries are covered in more detail in Customer group queries.',
                                                    'name' => 'The name given by the shop owner to the customer group.',
                                                    'id' => 'A unique numeric identifier for the customer group.'
                                                  },
          'WWW::Shopify::Model::Order::ShippingLine' => {
                                                          'source' => 'The source of the shipping method.',
                                                          'tax_lines' => 'A list of <code>tax_line</code> objects, each of which details the taxes applicable to this shipping_line.',
                                                          'title' => 'The title of the shipping method.',
                                                          'price' => 'The price of this shipping method.',
                                                          'code' => 'A reference to the shipping method.'
                                                        },
          'WWW::Shopify::Model::Item' => {},
          'WWW::Shopify::Model::Transaction' => {
                                                  'test' => 'The option to use the transaction for testing purposes. Valid values are "true" or "false."',
                                                  'status' => 'The status of the transaction. Valid values are: pending, failure, success or error.',
                                                  'gateway' => 'The name of the gateway the transaction was issued through. A list of gateways can be found on Shopify\'s Payment Gateway page.',
                                                  'order_id' => 'A unique numeric identifier for the order.',
                                                  'authorization' => 'The authorization code associated with the transaction.',
                                                  'device_id' => 'The unique identifier for the device.',
                                                  'amount' => 'The amount of money that the transaction was for.',
                                                  'created_at' => 'The date and time when the transaction was created. The API returns this value in ISO 8601 format.',
                                                  'kind' => 'The kind of transaction:',
                                                  'user_id' => 'The unique identifier for the user.',
                                                  'id' => 'A unique numeric identifier for the transaction.',
                                                  'receipt' => ''
                                                },
          'WWW::Shopify::Model::Order::PaymentDetails' => {
                                                            'credit_card_company' => 'The name of the company who issued the customer\'s credit card.',
                                                            'credit_card_bin' => 'The  issuer identification number (IIN), formerly known as bank identification number (BIN) ] of the customer\'s credit card. This is made up of the first few digits of the credit card number.',
                                                            'cvv_result_code' => 'The Response code from the credit card company indicating whether the customer entered the  card security code, a.k.a. card verification value, correctly. The code is a single letter or empty string; see  this chart for the codes and their definitions.',
                                                            'credit_card_number' => 'The customer\'s credit card number, with most of the leading digits redacted with Xs.'
                                                          },
          'WWW::Shopify::Model::Order::ClientDetails' => {
                                                           'browser_ip' => 'The browser IP address.',
                                                           'session_hash' => 'A hash of the session.',
                                                           'user_agent' => '',
                                                           'accept_language' => ''
                                                         },
          'WWW::Shopify::Model::Transaction::Receipt' => {
                                                           'authorization' => '',
                                                           'testcase' => ''
                                                         },
          'WWW::Shopify::Model::Order::Fulfillment::LineItem' => {
                                                                   'sku' => 'A unique identifier of the item in the fulfillment.',
                                                                   'product_exists' => 'States whether or not the product exists. Valid values are "true" or "false".',
                                                                   'fulfillment_service' => 'Service provider who is doing the fulfillment. Valid values are: manual, ',
                                                                   'product_id' => 'The unique numeric identifier for the product in the fulfillment.',
                                                                   'id' => 'The id of the <code>line_item</code> within the fulfillment.',
                                                                   'grams' => 'The weight of the item in grams.',
                                                                   'quantity' => 'The number of items in the fulfillment.',
                                                                   'name' => 'The name of the product variant.',
                                                                   'properties' => 'Returns additional properties associated with the line item.',
                                                                   'variant_title' => 'The title of the product variant being fulfilled.',
                                                                   'fulfillment_status' => 'Status of an order in terms of the <code>line_items</code> being fulfilled. Valid values are: fulfilled, null or partial.',
                                                                   'variant_id' => 'The id of the product variant being fulfilled.',
                                                                   'price' => 'The price of the item.',
                                                                   'title' => 'The title of the product.',
                                                                   'variant_inventory_management' => 'Returns the name of the inventory management system.',
                                                                   'requires_shipping' => 'Specifies whether or not a customer needs to provide a shipping address when placing an order for this product variant. Valid values are: "true" or "false."',
                                                                   'vendor' => 'The name of the supplier of the item.'
                                                                 },
          'WWW::Shopify::Model::Article' => {
                                              'summary_html' => 'The text of the summary of the article, complete with HTML markup.',
                                              'published_at' => 'The date and time when the article was published. The API returns this value in ISO 8601 format.',
                                              'metafields' => '',
                                              'author' => 'The name of the author of this article',
                                              'tags' => 'Tags are additional short descriptors formatted as a string of comma-separated values. For example, if an article has three tags: tag1, tag2, tag3.',
                                              'published' => 'States whether or not the article is visible. Valid values are "true" for published or "false" for hidden.',
                                              'created_at' => 'The date and time when the article was created. The API returns this value in ISO 8601 format.',
                                              'updated_at' => 'The date and time when the article was last updated. The API returns this value in ISO 8601 format.',
                                              'user_id' => 'A unique numeric identifier for the author of the article.',
                                              'title' => 'The title of the article.',
                                              'blog_id' => 'A unique numeric identifier for the blog containing the article.',
                                              'body_html' => 'The text of the body of the article, complete with HTML markup.',
                                              'id' => 'A unique numeric identifier for the article.'
                                            },
          'WWW::Shopify::Model::Checkout' => {
                                               'total_price' => 'The sum of all the prices of all the items in the order, taxes and discounts included.',
                                               'line_items' => '',
                                               'billing_address' => '',
                                               'discount_codes' => '',
                                               'shipping_lines' => '',
                                               'taxes_included' => '',
                                               'buyer_accepts_marketing' => 'Indicates whether or not the person who placed the order would like to receive email updates from the shop. This is set when checking the "I want to receive occasional emails about new products, promotions and other news" checkbox during checkout. Valid values are "true" and "false."',
                                               'abandoned_checkout_url' => 'The full recovery URL to be sent to a customer to recover their abandoned checkout.',
                                               'email' => 'The customer\'s email address.',
                                               'created_at' => 'The date and time when the order was created. The API returns this value in ISO 8601 format.',
                                               'id' => 'The unique numeric identifier for the order. This one is used for API purposes. This is different from the order_number property (see below), which is also a unique numeric identifier for the order, but used by the shop owner and customer.',
                                               'token' => 'Unique identifier for a particular order.',
                                               'total_discounts' => 'The total amount of the discounts to be applied to the price of the order.',
                                               'landing_site' => 'The URL for the page where the buyer landed when entering the shop.',
                                               'total_weight' => 'The sum of all the weights of the line items in the order, in grams.',
                                               'tax_lines' => '',
                                               'cart_token' => 'Unique identifier for a particular cart that is attached to a particular order.',
                                               'referring_site' => 'The website that the customer clicked on to come to the shop.',
                                               'note' => 'The text of an optional note that a shopowner can attach to the order.',
                                               'source_name' => 'Where the checkout originated from. Returned value will be "web" or "pos"',
                                               'total_line_items_price' => 'The sum of all the prices of all the items in the order.',
                                               'updated_at' => 'The date and time when the order was last modified. The API returns this value in ISO 8601 format.',
                                               'customer' => '',
                                               'shipping_address' => '',
                                               'subtotal_price' => 'Price of the order before shipping and taxes',
                                               'total_tax' => 'The sum of all the taxes applied to the line items in the order.'
                                             },
          'WWW::Shopify::Model::Comment' => {
                                              'published_at' => 'The date and time when the comment was published. In the case of comments, this is the date and time when the comment was created, meaning that it has the same value as created_at. The API returns this value in ISO 8601 format.',
                                              'article_id' => 'A unique numeric identifier for the article to which the comment belongs.',
                                              'user_agent' => 'The user agent string provided by the software (usually a browser) used to create the comment.',
                                              'status' => 'The status of the comment. The possible values are:<ul>',
                                              'ip' => 'The IP address from which the comment was posted.',
                                              'body' => 'The basic textile markup of a comment.',
                                              'email' => 'The email address of the author of the comment.',
                                              'created_at' => 'The date and time when the comment was created. The API returns this value in ISO 8601 format.',
                                              'updated_at' => 'The date and time when the comment was last modified. When the comment is first created, this is the date and time when the comment was created, meaning that it has the same value as created_at. If the blog requires comments to be approved, this value is updated to the date and time the comment was approved upon approval. The API returns this value in ISO 8601 format.',
                                              'blog_id' => 'A unique numeric identifier for the blog containing the article that the comment belongs to.',
                                              'body_html' => 'The text of the comment, complete with HTML markup.',
                                              'id' => 'A unique numeric identifier for the comment.'
                                            },
          'WWW::Shopify::Model::Blog' => {
                                           'feedburner_location' => 'URL to the feedburner location for blogs that have enabled feedburner through their store admin.',
                                           'metafields' => '',
                                           'feedburner' => 'Feedburner is a web feed management provider and can be enabled to provide custom RSS feeds for Shopify bloggers. This property will default to blank or "null" unless feedburner is enabled through the shop admin.',
                                           'tags' => 'Tags are additional short descriptors formatted as a string of comma-separated values. For example, if an article has three tags: tag1, tag2, tag3.',
                                           'template_suffix' => 'States the name of the template a blog is using if it is using an alternate template. If a blog is using the default blog.liquid template, the value returned is "null".',
                                           'created_at' => 'The date and time when the blog was created. The API returns this value in ISO 8601 format.',
                                           'handle' => 'A human-friendly unique string for a blog automatically generated from its title. This handle is used by the Liquid templating language to refer to the blog.',
                                           'updated_at' => 'The date and time when changes were last made to the blog\'s properties. Note that this is not updated when creating, modifying or deleting articles in the blog. The API returns this value in ISO 8601 format.',
                                           'title' => 'The title of the blog.',
                                           'id' => 'A unique numeric identifier for the blog.',
                                           'commentable' => 'Indicates whether readers can post comments to the blog and if comments are moderated or not. Possible values are:<ul>'
                                         },
          'WWW::Shopify::Model::Customer' => {
                                               'last_order_name' => 'The name of the customer\'s last order. This is directly related to the Order\'s name field.',
                                               'orders_count' => 'The number of orders associated with this customer.',
                                               'state' => 'The state of the customer in a shop.  Customers start out as "disabled."  They are invited by email to setup an account with a shop.  The customer can then:',
                                               'last_name' => 'The customer\'s last name.',
                                               'email' => 'The email address of the customer.',
                                               'created_at' => 'The date and time when the customer was created. The API returns this value in ISO 8601 format.',
                                               'multipass_identifier' => 'The customer\'s identifier used with Multipass login',
                                               'verified_email' => 'States whether or not the email address has been verified.',
                                               'id' => 'A unique numeric identifier for the customer.',
                                               'last_order_id' => 'The id of the customer\'s last order.',
                                               'metafields' => '',
                                               'accepts_marketing' => 'Indicates whether the customer has consented to be sent marketing material via email. Valid values are "true" and "false."',
                                               'note' => 'A note about the customer.',
                                               'tags' => 'Tags are additional short descriptors formatted as a string of comma-separated values. For example, if an article has three tags: tag1, tag2, tag3.',
                                               'addresses' => '',
                                               'updated_at' => 'The date and time when the customer information was updated. The API returns this value in ISO 8601 format.',
                                               'default_address' => '',
                                               'total_spent' => 'The total amount of money that the customer has spent at the shop.',
                                               'first_name' => 'The customer\'s first name.'
                                             },
          'WWW::Shopify::Model::CarrierService' => {
                                                     'name' => 'The name of the shipping service as seen by merchants and their customers.',
                                                     'callback_url' => 'States the URL endpoint that shopify needs to retrieve shipping rates. This must be a public URL.',
                                                     'active' => 'States whether or not this carrier service is active. Valid values are "true" and "false".',
                                                     'service_discovery' => 'States if merchants are able to send dummy data to your service through the Shopify admin to see shipping rate examples. Valid values are "true" and "false"',
                                                     'carrier_service_type' => 'Distinguishes between api or legacy carrier services.'
                                                   },
          'WWW::Shopify::Model::ApplicationCharge' => {
                                                        'test' => 'States whether or not the application charge is a test transaction. Valid values are "true" or "null".',
                                                        'status' => 'The status of the application charge. Valid values are:<ul>',
                                                        'name' => 'The name of the one-time application charge.',
                                                        'return_url' => 'The URL the customer is sent to once they accept/decline a charge.',
                                                        'confirmation_url' => 'The URL that the customer is taken to, to accept or decline the one-time application charge.',
                                                        'created_at' => 'The date and time when the one-time application charge was created. The API returns this value in ISO 8601 format.',
                                                        'updated_at' => 'The date and time when the charge was last updated. The API returns this value in ISO 8601 format.',
                                                        'id' => 'A unique numeric identifier for the one-time application charge.',
                                                        'price' => 'The price of the the one-time application charge.'
                                                      },
          'WWW::Shopify::Model::Order::Fulfillment' => {
                                                         'line_items' => '',
                                                         'status' => 'The status of the fulfillment. Valid values are:<ul>',
                                                         'order_id' => 'The unique numeric identifier for the order.',
                                                         'created_at' => 'The date and time when the fulfillment was created. The API returns this value in ISO 8601 format.',
                                                         'updated_at' => 'The date and time when the fulfillment was last modified. The API returns this value in ISO 8601 format.',
                                                         'id' => 'A unique numeric identifier for the fulfillment.',
                                                         'tracking_company' => 'The name of the shipping company.',
                                                         'receipt' => ''
                                                       },
          'WWW::Shopify::Model::Order' => {
                                            'total_price' => 'The sum of all the prices of all the items in the order, taxes and discounts included (must be positive).',
                                            'line_items' => '',
                                            'closed_at' => 'The date and time when the order was closed. If the order was closed, the API returns this value in ISO 8601 format. If the order was not closed, this value is null.',
                                            'billing_address' => '',
                                            'taxes_included' => 'States whether or not taxes are included in the order subtotal. Valid values are "true" or "false".',
                                            'email' => 'The customer\'s email address. Is required when a billing address is present.',
                                            'id' => 'The unique numeric identifier for the order. This one is used for API purposes. This is different from the order_number property (see below), which is also a unique numeric identifier for the order, but used by the shop owner and customer.',
                                            'payment_details' => '',
                                            'total_discounts' => 'The total amount of the discounts to be applied to the price of the order.',
                                            'order_number' => 'A unique numeric identifier for the order. This one is used by the shop owner and customer. This is different from the id property, which is also a unique numeric identifier for the order, but used for API purposes.',
                                            'financial_status' => '<ul>',
                                            'landing_site' => 'The URL for the page where the buyer landed when entering the shop.',
                                            'name' => 'The customer\'s order name as represented by a number.',
                                            'cart_token' => 'Unique identifier for a particular cart that is attached to a particular order.',
                                            'total_line_items_price' => 'The sum of all the prices of all the items in the order.',
                                            'note_attributes' => 'Extra information that is added to the order. Each array entry must contain a hash with "name" and "value" keys as shown above.',
                                            'updated_at' => 'The date and time when the order was last modified. The API returns this value in ISO 8601 format.',
                                            'shipping_address' => '',
                                            'fulfillment_status' => '<ul>',
                                            'subtotal_price' => 'Price of the order before shipping and taxes',
                                            'total_tax' => 'The sum of all the taxes applied to the order (must be positive).',
                                            'number' => 'Numerical identifier unique to the shop. A number is sequential and starts at 1000.',
                                            'discount_codes' => '',
                                            'gateway' => '<strong>Deprecated as of July 14, 2014. This information is instead available on <a href=\'=/api/transaction#properties\'>transactions</strong>',
                                            'shipping_lines' => '',
                                            'buyer_accepts_marketing' => 'Indicates whether or not the person who placed the order would like to receive email updates from the shop. This is set when checking the "I want to receive occasional emails about new products, promotions and other news" checkbox during checkout. Valid values are "true" and "false."',
                                            'cancel_reason' => 'The reason why the order was cancelled. If the order was not cancelled, this value is "null." If the order was cancelled, the value will be one of the following:',
                                            'currency' => 'The three letter code (ISO 4217) for the currency used for the payment.',
                                            'created_at' => 'The date and time when the order was created. The API returns this value in ISO 8601 format.',
                                            'token' => 'Unique identifier for a particular order.',
                                            'total_weight' => 'The sum of all the weights of the line items in the order, in grams.',
                                            'tax_lines' => '',
                                            'client_details' => '',
                                            'cancelled_at' => 'The date and time when the order was cancelled. If the order was cancelled, the API returns this value in ISO 8601 format. If the order was not cancelled, this value is "null."',
                                            'processing_method' => 'States the type of payment processing method. Valid values are: checkout, direct, manual, offsite or express.',
                                            'referring_site' => 'The website that the customer clicked on to come to the shop.',
                                            'tags' => 'Tags are additional short descriptors formatted as a string of comma-separated values. For example, if an order has three tags: tag1, tag2, tag3.',
                                            'note' => 'The text of an optional note that a shop owner can attach to the order.',
                                            'browser_ip' => 'The IP address of the browser used by the customer when placing the order.',
                                            'source_name' => 'Where the order originated from. Returned value will be "web" or "pos"',
                                            'customer' => '',
                                            'fulfillments' => ''
                                          },
          'WWW::Shopify::Model::CustomCollection::Collect' => {
                                                                'position' => 'A number specifying the order in which the product appears in the custom collection, with 1 denoting the first item in the collection. This value applies only when the custom collection\'s sort-order property is set to manual.',
                                                                'sort_value' => 'This is the same value as <tt>position</tt> but padded with leading zeroes to make it alphanumeric-sortable.',
                                                                'created_at' => 'The date and time when the collect was created. The API returns this value in ISO 8601 format.',
                                                                'featured' => 'States whether or not the collect is featured. Valid values are "true" or "false".',
                                                                'product_id' => 'The unique numeric identifier for the product in the custom collection.',
                                                                'updated_at' => 'The date and time when the collect was last updated. The API returns this value in ISO 8601 format.',
                                                                'collection_id' => 'The id of the custom collection containing the product.',
                                                                'id' => 'A unique numeric identifier for the collect.'
                                                              },
          'WWW::Shopify::Model::RecurringApplicationCharge' => {
                                                                 'trial_days' => 'Number of days that the customer is eligible for a free trial.',
                                                                 'test' => 'States whether or not the application charge is a test transaction. Valid values are "true" or "null".',
                                                                 'name' => 'The name of the recurring application charge.',
                                                                 'cancelled_on' => 'The date and time when the customer cancelled their recurring application charge. The API returns this value in ISO 8601 format.<br/>Note: If the recurring application charge is not cancelled it will default to "null".',
                                                                 'trial_ends_on' => 'The date and time when the free trial ends. The API returns this value in ISO 8601 format.',
                                                                 'return_url' => 'The URL the customer is sent to once they accept/decline a charge.',
                                                                 'confirmation_url' => 'The URL that the customer is taken to, to accept or decline the recurring application charge.',
                                                                 'created_at' => 'The date and time when the recurring application charge was created. The API returns this value in ISO 8601 format.',
                                                                 'updated_at' => 'The date and time when the recurring application charge was last updated. The API returns this value in ISO 8601 format.',
                                                                 'activated_on' => 'The date and time when the customer activated the recurring application charge. The API returns this value in ISO 8601 format.<br/>Note: The recurring application charge must be activated or the returning value will be "null".',
                                                                 'id' => 'A unique numeric identifier for the recurring application charge.',
                                                                 'price' => 'The price of the the recurring application charge.',
                                                                 'billing_on' => 'The date and time when the customer will be billed. The API returns this value in ISO 8601 format.<br/>Note: The recurring application charge must be accepted or the returning value will be "null".'
                                                               },
          'WWW::Shopify::Model::Location' => {
                                               'country' => 'The country the location is in',
                                               'location_type' => 'The location type',
                                               'name' => 'The name of the location',
                                               'phone' => 'The phone number of the location, can contain special chars like - and +',
                                               'address2' => 'The second line of the address',
                                               'created_at' => 'The date and time when the location was created. The API returns this value in ISO 8601 format.',
                                               'zip' => 'The zip or postal code',
                                               'city' => 'The city the location is in',
                                               'updated_at' => 'The date and time when the location was last updated. The API returns this value in ISO 8601 format.',
                                               'id' => 'A unique numeric identifier for the location.',
                                               'address1' => 'The first line of the address',
                                               'province' => 'The province the location is in'
                                             },
          'WWW::Shopify::Model::SmartCollection::Rule' => {
                                                            'relation' => ' The relation between the identifier for the condition and the numeric amount.',
                                                            'column' => '',
                                                            'condition' => ' Select products for a collection using a condition.'
                                                          },
          'WWW::Shopify::Model::Order::Risk' => {},
          'WWW::Shopify::Model::Checkout::LineItem' => {
                                                         'sku' => 'A unique identifier of the item in the fulfillment.',
                                                         'grams' => 'The weight of the item in grams.',
                                                         'fulfillment_service' => 'Service provider who is doing the fulfillment. Valid values are: manual, ',
                                                         'quantity' => 'The number of products that were purchased.',
                                                         'variant_title' => 'The title of the product variant.',
                                                         'product_id' => 'The unique numeric identifier for the product in the fulfillment.',
                                                         'variant_id' => 'The id of the product variant.',
                                                         'price' => 'The price of the item.',
                                                         'title' => 'The title of the product.',
                                                         'vendor' => 'The name of the supplier of the item.',
                                                         'requires_shipping' => 'States whether or not the fulfillment requires shipping. Values are: true or false.'
                                                       },
          'WWW::Shopify::Model::Country::Province' => {
                                                        'tax_percentage' => 'The tax value in percent format.',
                                                        'tax_type' => 'A tax_type is applied for a compounded sales tax. For example, the Canadian HST is a compounded sales tax of both PST and GST.',
                                                        'name' => 'The name of the province or state.',
                                                        'tax_name' => 'The name of the tax as it is referred to in the applicable province/state. For example, in Ontario, Canada the tax is referred to as HST.',
                                                        'tax' => 'The tax value in decimal format.',
                                                        'id' => 'The unique numeric identifier for the particular province or state.',
                                                        'code' => 'The two letter province or state code.'
                                                      },
          'WWW::Shopify::Model::Checkout::TaxLine' => {
                                                        'rate' => 'The rate of tax to be applied.',
                                                        'title' => 'The name of the tax.',
                                                        'price' => 'The amount of tax to be charged.'
                                                      },
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
                                            'attachment' => 'An asset attached to a store\'s theme.',
                                            'value' => 'The asset that you are adding.',
                                            'src' => 'Specifies the location of an asset.',
                                            'source_key' => 'The source key copies an asset.',
                                            'public_url' => 'The public facing URL of the asset.',
                                            'size' => 'The asset size in bytes.',
                                            'key' => 'The path to the asset within a shop. For example, the asset bg-body-green.gif is located in the assets folder.',
                                            'content_type' => 'MIME representation of the content, consisting of the type and subtype of the asset.',
                                            'created_at' => 'The date and time when the asset was created. The API returns this value in ISO 8601 format.',
                                            'updated_at' => 'The date and time when an asset was last updated. The API returns this value in ISO 8601 format.'
                                          },
          'WWW::Shopify::Model::Order::TaxLine' => {
                                                     'rate' => 'The rate of tax to be applied.',
                                                     'title' => 'The name of the tax.',
                                                     'price' => 'The amount of tax to be charged.'
                                                   },
          'WWW::Shopify::Model::CustomCollection' => {
                                                       'published_at' => 'This can have two different types of values, depending on whether the custom collection has been published (i.e., made visible to customers):<ul>',
                                                       'sort_order' => 'The order in which products in the custom collection appear. Valid values are:<ul>',
                                                       'metafields' => '',
                                                       'published_scope' => 'The sales channels in which the custom collection is visible.',
                                                       'image' => '',
                                                       'template_suffix' => 'The suffix of the liquid template being used. By default, the original template is called product.liquid, without any suffix. Any additional templates will be: product.suffix.liquid.',
                                                       'published' => 'States whether the custom collection is visible. Valid values are "true" for visible and "false" for hidden.',
                                                       'handle' => 'A human-friendly unique string for the custom collection automatically generated from its title. This is used in shop themes by the Liquid templating language to refer to the custom collection.',
                                                       'updated_at' => 'The date and time when the custom collection was last modified. The API returns this value in ISO 8601 format.',
                                                       'title' => 'The name of the custom collection.',
                                                       'body_html' => 'The description of the custom collection, complete with HTML markup. Many templates display this on their custom collection pages.',
                                                       'id' => 'The unique numeric identifier for the custom collection.'
                                                     },
          'WWW::Shopify::Model::Cart' => {},
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
          'WWW::Shopify::Model::Refund::LineItem' => {
                                                       'quantity' => 'The quantity of the associated line item that was returned.',
                                                       'line_item' => 'The single line item being returned.',
                                                       'id' => 'The unique identifier of the refund line item.',
                                                       'line_item_id' => 'The id of the related line item.'
                                                     },
          'WWW::Shopify::Model::Theme' => {
                                            'created_at' => 'The date and time when the theme was created. The API returns this value in ISO 8601 format.',
                                            'updated_at' => 'The date and time when the theme was last updated. The API returns this value in ISO 8601 format.',
                                            'name' => 'The name of the theme.',
                                            'id' => 'A unique numeric identifier for the theme.',
                                            'role' => 'Specifies how the theme is being used within the shop. Valid values are:'
                                          },
          'WWW::Shopify::Model::Country' => {
                                              'name' => 'The full name of the country, in English.',
                                              'tax' => 'The national sales tax rate to be applied to orders made by customers from that country.',
                                              'id' => 'The unique numeric identifier for the country. <br /> It is important to note that the id for a given country in one shop will not be the same as the id for the same country in another shop.',
                                              'provinces' => '',
                                              'code' => 'The ISO 3166-1 alpha-2 two-letter country code for the country. The code for a given country will be the same as the code for the same country in another shop.'
                                            },
          'WWW::Shopify::Model::Product' => {
                                              'published_at' => 'The date and time when the product was published. The API returns this value in ISO 8601 format.',
                                              'images' => 'A list of image objects, each one representing an image associated with the product.',
                                              'options' => 'Custom product property names like "Size", "Color", and "Material". products are based on permutations of these options. A product may have a maximum of 3 options.',
                                              'tags' => 'A categorization that a product can be tagged with, commonly used for filtering and searching.',
                                              'published_scope' => 'The sales channels in which the product is visible.',
                                              'variants' => 'A list of variant objects, each one representing a slightly different version of the product. For example, if a product comes in different sizes and colors, each size and color permutation (such as "small black", "medium black", "large blue"), would be a variant.',
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
          'WWW::Shopify::Model::Redirect' => {
                                               'target' => 'The "after" path or URL to be redirected to. When the user visits the path specified by path, s/he will be redirected to this path or URL. This property can be set to any path on the shop\'s site, or any URL, even one on a completely different domain.',
                                               'path' => 'The "before" path to be redirected. When the user this path, s/he will be redirected to the path specified by target.',
                                               'id' => 'The unique numeric identifier for the redirect.'
                                             },
          'WWW::Shopify::Model::ScriptTag' => {
                                                'created_at' => 'The date and time when the ScriptTag was created. The API returns this value in ISO 8601 format.',
                                                'updated_at' => 'The date and time when the ScriptTag was last updated. The API returns this value in ISO 8601 format.',
                                                'src' => 'Specifies the location of the ScriptTag.',
                                                'id' => 'The unique numeric identifier for the ScriptTag.',
                                                'event' => 'DOM event which triggers the loading of the script. Valid values are: "onload."'
                                              },
          'WWW::Shopify::Model::Webhook' => {
                                              'topic' => 'The event that will trigger the webhook. Valid values are: orders/create, orders/delete, orders/updated, orders/paid, orders/cancelled, orders/fulfilled, orders/partially_fulfilled, carts/create, carts/update, checkouts/create, checkouts/update, checkouts/delete, refunds/create, products/create, products/update, products/delete, collections/create, collections/update, collections/delete, customer_groups/create, customer_groups/update, customer_groups/delete, customers/create, customers/enable, customers/disable, customers/update, customers/delete, fulfillments/create, fulfillments/update, shop/update, app/uninstalled',
                                              'created_at' => 'The date and time when the webhook was created. The API returns this value in ISO 8601 format.',
                                              'format' => 'The format in which the webhook should send the data. Valid values are json and xml.',
                                              'updated_at' => 'The date and time when the webhook was updated. The API returns this value in ISO 8601 format.',
                                              'id' => 'The unique numeric identifier for the webhook.',
                                              'address' => 'The URI where the webhook should send the POST request when the event occurs.'
                                            },
          'WWW::Shopify::Model::CustomCollection::Image' => {
                                                              'attachment' => 'An image attached to a shop\'s theme returned as Base64-encoded binary data.',
                                                              'src' => 'Source URL that specifies the location of the image.'
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