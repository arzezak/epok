require "epok/api"
require "epok/collection"
require "epok/object"
require "epok/version"

module Epok
  Location = Struct.new(:x, :y, keyword_init: true)
  Category = Struct.new(:id, :name, :description, keyword_init: true)

  DEFAULT_RADIUS = 500

  def self.search(query)
    Collection.new { API.search(query) }
  end

  def self.geocoder(location, categories, radius: DEFAULT_RADIUS)
    categories = Array(categories).join(",")

    Collection.new { API.geocoder(location.x, location.y, categories, radius) }
  end

  def self.categories
    API.categories.map do |category|
      Category.new(
        id: category["nombre_normalizado"],
        name: category["nombre"],
        description: category["descripcion"]
      )
    end
  end
end
