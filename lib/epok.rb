require "epok/api"
require "epok/collectable"
require "epok/collection"
require "epok/geocoder"
require "epok/object"
require "epok/search"
require "epok/version"

module Epok
  def self.search(query)
    Search.new(query)
  end

  def self.geocoder(location, categories)
    Geocoder.new(location, categories)
  end
end
