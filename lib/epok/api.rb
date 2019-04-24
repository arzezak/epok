require "net/http"
require "json"

module Epok
  class API
    BASE_URL = "epok.buenosaires.gob.ar".freeze

    def self.object(id)
      response = Net::HTTP.get_response(BASE_URL, "/getObjectContent/?id=#{id}")
      JSON.parse(response.body)
    end

    def self.search(query)
      response = Net::HTTP.get_response(BASE_URL, "/buscar/?texto=#{query}")
      JSON.parse(response.body)["instancias"]
    end

    def self.geocoder(x, y, categories)
      response = Net::HTTP.get_response(BASE_URL,
        "/reverseGeocoderLugares/?x=#{x}&y=#{y}&categorias=#{categories}&radio=500")
      JSON.parse(response.body)["instancias"]
    end
  end
end
