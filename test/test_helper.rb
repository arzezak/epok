$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "epok"
require "minitest/autorun"
require "minitest/reporters"
require "vcr"

Minitest::Reporters.use!

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures"
  config.hook_into :webmock
end
