require "net/http"
require "json"

module Epok
  class API
    BASE_URL = "https://epok.buenosaires.gob.ar".freeze

    def self.object(id)
      get("/getObjectContent/", id: id)
    end

    def self.search(query)
      get("/buscar/", texto: query)["instancias"]
    end

    def self.geocoder(x, y, categories, radius)
      get("/reverseGeocoderLugares/",
        x: x, y: y, categorias: categories, radio: radius)["instancias"]
    end

    def self.categories
      get("/getCategorias/", {})["categorias"]
    end

    def self.get(path, params)
      uri = URI("#{BASE_URL}#{path}")
      uri.query = URI.encode_www_form(params)
      JSON.parse(Net::HTTP.get_response(uri).body)
    end
    private_class_method :get
  end
end
