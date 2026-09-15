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

    def test_that_geocoder_accepts_a_radius
      near = Epok.geocoder(obelisco, "estaciones_de_subte", radius: 100)
      far = Epok.geocoder(obelisco, "estaciones_de_subte", radius: 1000)

      assert_operator near.count, :<, far.count
      assert near.all? { |station| station.distance <= 100 }
    end

    def test_that_geocoder_accepts_several_categories
      results = Epok.geocoder(obelisco, %w[estaciones_de_subte farmacias])

      assert_equal %w[estaciones_de_subte farmacias].sort, results.map(&:category).uniq.sort
    end

    private

    def result
      Epok.geocoder(obelisco, "estaciones_de_subte").first
    end

    def obelisco
      Location.new(x: -58.381570, y: -34.603738)
    end
  end
end
