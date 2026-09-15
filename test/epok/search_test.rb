require "test_helper"

module Epok
  class SearchTest < Minitest::Test
    def setup
      VCR.insert_cassette("search")
    end

    def teardown
      VCR.eject_cassette("search")
    end

    def test_that_search_results_are_epok_objects
      assert_instance_of Object, result
    end

    def test_that_a_single_search_result_has_a_name
      assert_match "San Miguel de Garicoits", result.name
    end

    def test_that_search_encodes_the_query
      assert_match "Peña", Epok.search("plaza peña").first.name
    end

    def test_that_search_filters_by_category
      results = Epok.search("san martin", categories: "estaciones_de_subte")

      assert_equal ["estaciones_de_subte"], results.map(&:category).uniq
    end

    def test_that_search_filters_by_several_categories
      results = Epok.search("san martin", categories: %w[estaciones_de_subte estaciones_de_ferrocarril])

      assert_equal %w[estaciones_de_ferrocarril estaciones_de_subte], results.map(&:category).uniq.sort
    end

    def test_that_search_limits_results
      assert_equal 2, Epok.search("san martin", limit: 2).count
    end

    private

    def result
      Epok.search("garicoits").first
    end
  end
end
