#!/usr/bin/perl

use strict;
use warnings;
use Devel::StackTrace;

# Basic WWW::Shopify exception class;
package WWW::Shopify::Exception;
use overload 
	'fallback' => 1,
	'""' => sub { 
		return "Error: " . $_[0]->error->decoded_content . "\n" . $_[0]->stack if $_[0]->error && ref($_[0]->error) && ref($_[0]->error) eq "HTTP::Response";
		return "Error: " . $_[0]->error . "\n" . $_[0]->stack;
	};
# Generic constructor; class is blessed with the package that new specifies, and contains a hash specified inside the parentheses of a new call.
# Example: new WWW::Shopify::Exception('try' => 'catch'); $_[0] is 'WWW::Shopify::Exception', $_[1] is {'try' => 'catch'}.
# The object will be of type WWW::Shopify::Exception, and have the contents of {'try' => 'catch'}.
sub new($$) { return bless {'error' => $_[1] ? $_[1] : $_[0]->default_error, 'stack' => Devel::StackTrace->new->as_string, extra => $_[2]}, $_[0]; }
sub extra { return $_[0]->{extra}; }
sub error { return $_[0]->{error}; }
sub stack { return $_[0]->{stack}; }
sub default_error { return "Unknown exception occured."; }

# Thrown when a URL request exceeds the Shopify API call limit.
package WWW::Shopify::Exception::CallLimit;
use parent 'WWW::Shopify::Exception';
sub default_error { return "Call limit reached."; }

package WWW::Shopify::Exception::InvalidKey;
use parent 'WWW::Shopify::Exception';
sub default_error { return "Invalid API key."; }

package WWW::Shopify::Exception::NotFound;
use parent 'WWW::Shopify::Exception';
sub default_error { return "Asset not found."; }

package WWW::Shopify::Exception::DBError;
use parent 'WWW::Shopify::Exception';
sub default_error { return "Database error."; }

1;
