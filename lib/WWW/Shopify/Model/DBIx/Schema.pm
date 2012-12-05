package WWW::Shopify::Model::DBIx::Schema;
use base qw/DBIx::Class::Schema/;

__PACKAGE__->exception_action(sub { die new WWW::Shopify::Exception::DBError(@_); });
__PACKAGE__->load_namespaces();

1;
