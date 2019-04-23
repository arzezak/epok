module Epok
  class Search
    include Collectable

    attr_reader :query

    def initialize(query)
      @query = query
    end

    private

    def results
      collection API.search(query)
    end
  end
end
