require "swarf/probe"

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "epok"
require "minitest/autorun"
require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures"
  config.hook_into :webmock
  # Cassettes are committed. Locally, new requests get appended so a test
  # can be added or changed; on CI nothing may touch the network.
  config.default_cassette_options = { record: ENV["CI"] ? :none : :new_episodes }
  config.before_record { |interaction| interaction.response.headers.delete("Set-Cookie") }
end
