require "test_helper"

module Epok
  class CategoriesTest < Minitest::Test
    def setup
      VCR.insert_cassette("categories")
    end

    def teardown
      VCR.eject_cassette("categories")
    end

    def test_that_categories_are_listed
      categories = Epok.categories

      assert_operator categories.size, :>, 100
      assert categories.all? { |category| category.is_a?(Category) }
    end

    def test_that_a_category_has_an_id_and_a_name
      pharmacies = Epok.categories.find { |category| category.id == "farmacias" }

      assert_equal "Farmacias", pharmacies.name
    end
  end
end
