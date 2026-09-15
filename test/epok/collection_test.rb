require "test_helper"

module Epok
  class CollectionTest < Minitest::Test
    def test_that_a_collection_is_enumerable
      collection = Collection.new { [{"id" => "a|1"}, {"id" => "a|2"}] }

      assert_equal ["a|1", "a|2"], collection.map(&:id)
      assert_equal 2, collection.count
    end

    def test_that_a_collection_fetches_lazily_and_once
      calls = 0
      collection = Collection.new { calls += 1; [{"id" => "a|1"}] }

      assert_equal 0, calls
      collection.first
      collection.to_a
      assert_equal 1, calls
    end
  end
end
