require "net/http"
require "json"

module Epok
  class Error < StandardError; end
  class NotFound < Error; end

  class API
    EPOK_URL = "https://epok.buenosaires.gob.ar".freeze
    USIG_URL = "https://ws.usig.buenosaires.gob.ar".freeze
    USIG_SERVICES_URL = "https://servicios.usig.buenosaires.gob.ar".freeze
    TIMEOUT = 10

    def self.object(id)
      object = get(EPOK_URL, "/getObjectContent/", id: id)
      raise NotFound, "no object with id #{id}" if object.empty?

      object
    end

    def self.search(query, categories = nil, limit = nil)
      params = { texto: query, categoria: categories, limit: limit }.compact

      get(EPOK_URL, "/buscar/", params)["instancias"]
    end

    def self.nearby(x, y, categories, radius)
      get(EPOK_URL, "/reverseGeocoderLugares/",
        x: x, y: y, categorias: categories, radio: radius)["instancias"]
    end

    def self.categories
      get(EPOK_URL, "/getCategorias/", {})["categorias"]
    end

    def self.geocode(text)
      response = get(USIG_SERVICES_URL, "/normalizar/", direccion: text, geocodificar: true)
      addresses = response["direccionesNormalizadas"]
      raise NotFound, response["errorMessage"] if addresses.empty?

      addresses
    end

    def self.datos_utiles(x, y)
      get(USIG_URL, "/datos_utiles", x: x, y: y)
    end

    # Converts EPOk's projected coordinates (Gauss-Krüger Buenos Aires) to
    # longitude and latitude through the city's USIG service.
    def self.to_lonlat(x, y)
      response = get(USIG_URL, "/rest/convertir_coordenadas", x: x, y: y, output: "lonlat")
      raise Error, "USIG could not convert (#{x}, #{y})" unless response["tipo_resultado"] == "Ok"

      response["resultado"].values_at("x", "y").map(&:to_f)
    end

    def self.get(host, path, params)
      uri = URI("#{host}#{path}")
      uri.query = URI.encode_www_form(params)

      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true,
        open_timeout: TIMEOUT, read_timeout: TIMEOUT) do |http|
        http.get(uri.request_uri)
      end

      unless response.is_a?(Net::HTTPSuccess)
        raise Error, "EPOk responded #{response.code} to #{uri}"
      end

      normalize(JSON.parse(response.body))
    rescue SystemCallError, SocketError, Timeout::Error, OpenSSL::SSL::SSLError, JSON::ParserError => e
      raise Error, "#{e.class}: #{e.message}"
    end
    private_class_method :get

    # The API pads and double-spaces strings at random. Clean every string
    # in a response once, here, so no field needs its own strip.
    def self.normalize(value)
      case value
      when Hash then value.transform_values { |v| normalize(v) }
      when Array then value.map { |v| normalize(v) }
      when String then value.strip.squeeze(" ")
      else value
      end
    end
    private_class_method :normalize
  end
end
