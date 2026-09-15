require "test_helper"

module Epok
  class GeocoderTest < Minitest::Test
    def setup
      VCR.insert_cassette("geocoder")
    end

    def teardown
      VCR.eject_cassette("geocoder")
    end

    def test_that_geocoder_results_are_epok_objects
      assert_instance_of Object, result
    end

    def test_that_a_single_geocoder_result_has_a_name
      assert_match "Línea D", result.name
    end

    def test_that_geocoder_results_have_a_distance
      assert_operator result.distance, :<, 500
    end

    private

    def result
      obelisco = Location.new(x: -58.381570, y: -34.603738)
      Epok.geocoder(obelisco, "estaciones_de_subte").first
    end
  end
end
