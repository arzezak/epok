require "test_helper"

class EpokTest < Minitest::Test
  def test_that_search_builds_a_collection
    assert_instance_of Epok::Collection, Epok.search("garicoits")
  end

  def test_that_geocoder_builds_a_collection
    obelisco = Epok::Location.new(x: -58.381570, y: -34.603738)

    assert_instance_of Epok::Collection, Epok.geocoder(obelisco, "farmacias")
  end
end
