require "net/http"
require "json"

module Epok
  class Error < StandardError; end
  class NotFound < Error; end

  class API
    BASE_URL = "https://epok.buenosaires.gob.ar".freeze
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

    def self.get(path, params)
      uri = URI("#{BASE_URL}#{path}")
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
