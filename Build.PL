use Module::Build;

my $build = Module::Build->new(
	module_name => 'WWW-Shopify',
	license_from => 'lib/WWW/Shopify.pm',
	dist_author_from => 'lib/WWW/Shopify.pm',
	dist_version_from => 'lib/WWW/Shopify.pm',
	configure_requires => { 'Module::Build' => 0.38 },
	requires => {
		'Crypt::Eksblowfish' => '0.009',
		'Data::Random' => '0.08',
		'IO::CaptureOutput' => '1.1102',
		'Data::Dumper' => '0',
		'DateTime::Format::MySQL' => '0.04',
		'DateTime::Format::SQLite' => '0.11',
		'String::Random' => '0.22',
		'Devel::StackTrace' => '1.30',
		'Locale::Currency::Format' => '1.30',
		'DBIx::Class' => '0.08204',
		'LWP::UserAgent' => '6.04',
		'String::Numeric' => '0.9',
		'DateTime' => '0.78',
		'File::Slurp' => '9999.19',
		'SQL::Translator' => '0.11016',
		'MIME::Base64' => '3.13',
		'JSON' => '2.53',
		'LWP::Protocol::https' => '6.03',
		'HTTP::Request::Common' => '6.04',
		'Date::Calc' => '6.3',
		'URI::Escape' => '3.31'
	},
	meta_merge => {
		resources => {
			 repository  => 'https://bitbucket.org/bengmn/perl-shopify-api'
		},
		no_index => {
	    		directory => [ 'lib/WWW/Shopify/Model/DBIx', 'lib/WWW/Shopify/Field' ]
		}
	}
);
$build->create_build_script;
