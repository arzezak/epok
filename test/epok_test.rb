require "test_helper"

class EpokTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil Epok::VERSION
  end

  def test_responds_to_search
    assert_respond_to Epok, :search
  end

  def test_responds_to_geocoder
    assert_respond_to Epok, :geocoder
  end
end
