require "test_helper"

module Epok
  class NearbyTest < Minitest::Test
    def setup
      VCR.insert_cassette("nearby")
    end

    def teardown
      VCR.eject_cassette("nearby")
    end

    def test_that_nearby_results_are_epok_objects
      assert_instance_of Object, result
    end

    def test_that_a_single_nearby_result_has_a_name
      assert_match "Línea D", result.name
    end

    def test_that_nearby_results_have_a_distance
      assert_operator result.distance, :<, 500
    end

    def test_that_nearby_accepts_a_radius
      near = Epok.nearby(obelisco, "estaciones_de_subte", radius: 100)
      far = Epok.nearby(obelisco, "estaciones_de_subte", radius: 1000)

      assert_operator near.count, :<, far.count
      assert near.all? { |station| station.distance <= 100 }
    end

    def test_that_nearby_accepts_several_categories
      results = Epok.nearby(obelisco, %w[estaciones_de_subte farmacias])

      assert_equal %w[estaciones_de_subte farmacias].sort, results.map(&:category).uniq.sort
    end

    private

    def result
      Epok.nearby(obelisco, "estaciones_de_subte").first
    end

    def obelisco
      Location.new(x: -58.381570, y: -34.603738)
    end
  end
end
