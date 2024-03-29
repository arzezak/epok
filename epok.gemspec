lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "epok/version"

Gem::Specification.new do |spec|
  spec.name          = "epok"
  spec.version       = Epok::VERSION
  spec.authors       = ["Ariel Rzezak"]
  spec.email         = ["arzezak@gmail.com"]

  spec.summary       = "GCBA EPOk wrapper."
  spec.description   = "GCBA EPOk wrapper to query indexed geographic objects."
  spec.homepage      = "https://github.com/arzezak/epok"
  spec.license       = "MIT"

  spec.files = `git ls-files`.split("\n")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters", "~> 1.3", ">= 1.3.6"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "vcr", "~> 4.0"
  spec.add_development_dependency "webmock", "~> 3.5", ">= 3.5.1"
end
