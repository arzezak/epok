require "epok/api"
require "epok/collection"
require "epok/object"
require "epok/version"

module Epok
  Location = Struct.new(:x, :y, keyword_init: true)

  def self.search(query)
    Collection.new { API.search(query) }
  end

  def self.geocoder(location, categories)
    Collection.new { API.geocoder(location.x, location.y, categories) }
  end
end
