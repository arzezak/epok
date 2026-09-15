require "net/http"
require "json"

module Epok
  class API
    BASE_URL = "https://epok.buenosaires.gob.ar".freeze

    def self.object(id)
      JSON.parse(get("/getObjectContent/?id=#{id}"))
    end

    def self.search(query)
      JSON.parse(get("/buscar/?texto=#{query}"))["instancias"]
    end

    def self.geocoder(x, y, categories)
      JSON.parse(get(
        "/reverseGeocoderLugares/?x=#{x}&y=#{y}&categorias=#{categories}&radio=500"
      ))["instancias"]
    end

    def self.get(path)
      Net::HTTP.get_response(URI("#{BASE_URL}#{path}")).body
    end
    private_class_method :get
  end
end
