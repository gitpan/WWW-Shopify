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
		'Date::Calc' => 0,
		'DateTime::Format::MySQL' => '0.04',
		'DateTime::Format::SQLite' => '0.11',
		'String::Random' => '0.22',
		'Devel::StackTrace' => '1.30',
		'DBIx::Class' => '0.08204',
		'LWP::UserAgent' => '6.04',
		'String::Numeric' => '0.9',
		'DateTime' => '0.78',
		'SQL::Translator' => '0.11016',
		'MIME::Base64' => '3.13',
		'JSON' => '2.53',
		'LWP::Protocol::https' => '6.03',
		'HTTP::Request::Common' => '6.04',
		'URI::Escape' => '3.31',
		'Scalar::Util' => 0,
		'Math::Round' => 0,
		'Clone' => 0,
		'Date::Parse' => 0,
	},
	build_requires => {
		'DBD::SQLite' => 0
	},
	meta_merge => {
		resources => {
			 repository  => 'https://bitbucket.org/bengmn/experimental-projects'
		},
		no_index => {
	    		directory => [ 'lib/WWW/Shopify/Model/DBIx', 'lib/WWW/Shopify/Field' ]
		}
	}
);
$build->create_build_script;
