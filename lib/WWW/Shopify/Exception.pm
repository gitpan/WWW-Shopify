#!/usr/bin/perl

use strict;
use warnings;
use Devel::StackTrace;

# Basic WWW::Shopify exception class;
package WWW::Shopify::Exception;
use Data::Dumper;
use overload 
	'fallback' => 1,
	'""' => sub { return "Error: " . Dumper($_[0]->error, $_[0]->stack) };
# Generic constructor; class is blessed with the package that new specifies, and contains a hash specified inside the parentheses of a new call.
# Example: new WWW::Shopify::Exception('try' => 'catch'); $_[0] is 'WWW::Shopify::Exception', $_[1] is {'try' => 'catch'}.
# The object will be of type WWW::Shopify::Exception, and have the contents of {'try' => 'catch'}.
sub new($$) { return bless {'error' => $_[1], 'stack' => Devel::StackTrace->new->as_string}, $_[0]; }
sub error { return $_[0]->{error}; }
sub stack { return $_[0]->{stack}; }

# Thrown when a URL request exceeds the Shopify API call limit.
package WWW::Shopify::Exception::CallLimit;
use parent 'WWW::Shopify::Exception';

package WWW::Shopify::Exception::InvalidKey;
use parent 'WWW::Shopify::Exception';

package WWW::Shopify::Exception::DBError;
use parent 'WWW::Shopify::Exception';

1;
