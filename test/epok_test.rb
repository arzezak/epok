require "test_helper"

class EpokTest < Minitest::Test
  def test_that_search_builds_a_search
    search = Epok.search("garicoits")

    assert_instance_of Epok::Search, search
    assert_equal "garicoits", search.query
  end

  def test_that_geocoder_builds_a_geocoder
    obelisco = Epok::Location.new(x: -58.381570, y: -34.603738)
    geocoder = Epok.geocoder(obelisco, "farmacias")

    assert_instance_of Epok::Geocoder, geocoder
    assert_equal(-58.381570, geocoder.x)
    assert_equal(-34.603738, geocoder.y)
    assert_equal "farmacias", geocoder.categories
  end
end
