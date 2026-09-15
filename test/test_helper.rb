require "swarf/probe"

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "epok"
require "minitest/autorun"
require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures"
  config.hook_into :webmock
  config.default_cassette_options = { record: :new_episodes }
end
