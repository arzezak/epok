module Epok
  Location = Struct.new(:x, :y, keyword_init: true)

  class Geocoder
    include Collectable

    attr_reader :x, :y, :categories

    def initialize(location, categories)
      @x = location.x
      @y = location.y
      @categories = categories
    end

    private

    def results
      collection API.geocoder(x, y, categories)
    end
  end
end
