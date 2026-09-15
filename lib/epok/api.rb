require "net/http"
require "json"

module Epok
  class Error < StandardError; end
  class NotFound < Error; end

  class API
    BASE_URL = "https://epok.buenosaires.gob.ar".freeze
    USIG_URL = "https://ws.usig.buenosaires.gob.ar/rest/convertir_coordenadas".freeze
    TIMEOUT = 10

    def self.object(id)
      object = get("/getObjectContent/", id: id)
      raise NotFound, "no object with id #{id}" if object.empty?

      object
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

    # Converts EPOk's projected coordinates (Gauss-Krüger Buenos Aires) to
    # longitude and latitude through the city's USIG service.
    def self.to_lonlat(x, y)
      response = get(USIG_URL, x: x, y: y, output: "lonlat")
      raise Error, "USIG could not convert (#{x}, #{y})" unless response["tipo_resultado"] == "Ok"

      response["resultado"].values_at("x", "y").map(&:to_f)
    end

    def self.get(path, params)
      uri = URI(path.start_with?("http") ? path : "#{BASE_URL}#{path}")
      uri.query = URI.encode_www_form(params)

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true,
        open_timeout: TIMEOUT, read_timeout: TIMEOUT) do |http|
        http.get(uri.request_uri)
      end

      unless response.is_a?(Net::HTTPSuccess)
        raise Error, "EPOk responded #{response.code} to #{uri}"
      end

      JSON.parse(response.body)
    rescue SystemCallError, SocketError, Timeout::Error, OpenSSL::SSL::SSLError, JSON::ParserError => e
      raise Error, "#{e.class}: #{e.message}"
    end
    private_class_method :get
  end
end
