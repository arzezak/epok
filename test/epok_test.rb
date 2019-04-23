require "test_helper"

class EpokTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil Epok::VERSION
  end
end
