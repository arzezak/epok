lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "epok/version"

Gem::Specification.new do |spec|
  spec.name          = "epok"
  spec.version       = Epok::VERSION
  spec.authors       = ["Ariel Rzezak"]
  spec.email         = ["arzezak@gmail.com"]

  spec.summary       = "Ruby client for the Buenos Aires city EPOk geographic API."
  spec.description   = "Search the city's indexed geographic objects, find what is " \
                       "near a point, geocode addresses and look up the barrio and " \
                       "comuna of a location, through the GCBA EPOk and USIG services."
  spec.homepage      = "https://github.com/arzezak/epok"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.3"

  spec.metadata = {
    "source_code_uri"       => spec.homepage,
    "changelog_uri"         => "#{spec.homepage}/blob/main/CHANGELOG.md",
    "bug_tracker_uri"       => "#{spec.homepage}/issues",
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir["lib/**/*.rb"] + %w[README.md CHANGELOG.md LICENSE.txt]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "vcr", "~> 6.0"
  spec.add_development_dependency "webmock", "~> 3.5", ">= 3.5.1"
end
