use Module::Build;

my $build = Module::Build->new(
	module_name => 'WWW-Shopify',
	license_from => 'lib/WWW/Shopify.pm',
	dist_author_from => 'lib/WWW/Shopify.pm',
	dist_version_from => 'lib/WWW/Shopify.pm',
	requires => {
		'Crypt::Eksblowfish' => 0,
		'Data::Random' => 0,
		'IO::CaptureOutput' => 0,
		'Data::Dumper' => 0,
		'DateTime::Format::MySQL' => 0,
		'String::Random' => 0,
		'Locale::Currency::Format' => 0,
		'DBIx::Class' => 0,
		'LWP::UserAgent' => 0,
		'String::Numeric' => 0,
		'DateTime' => 0,
		'File::Slurp' => 0,
		'SQL::Translator' => 0,
		'MIME::Base64' => 0,
		'JSON' => 0,
		'LWP::Protocol::https' => 0
	},
	meta_merge => {no_index => {directory => ['lib/WWW/Shopify/Model/DBIx/Result']}}
);
$build->create_build_script;
