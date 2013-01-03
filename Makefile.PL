use inc::Module::Install;

name 'WWW-Shopify';
all_from 'lib/WWW/Shopify.pm';
requires 'Crypt::Eksblowfish';
requires 'TryCatch';
requires 'Data::Random';
requires 'IO::CaptureOutput';
requires 'Data::Dumper';
requires 'DateTime::Format::MySQL';
requires 'String::Random';
requires 'Locale::Currency::Format';
requires 'DBIx::Class';
requires 'LWP::UserAgent';
requires 'String::Numeric';
requires 'DateTime';
requires 'File::Slurp';
requires 'SQL::Translator';
requires 'LWP::Protocol::https';
author 'Adam Harrison <adamdharrison@gmail.com>';
license_from 'lib/WWW/Shopify.pm';

WriteAll;
