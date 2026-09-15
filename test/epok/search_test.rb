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

    private

    def result
      Epok.search("garicoits").first
    end
  end
end
