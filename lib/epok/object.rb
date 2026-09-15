module Epok
  class Object
    attr_reader :id, :distance

    # Accepts either an id ("farmacias|1082") or a result hash from a search
    # or geocoder listing. Listing attributes are available immediately; the
    # full content is fetched on first use.
    def initialize(attributes)
      attributes = { "id" => attributes } if attributes.is_a?(String)

      @id = attributes.fetch("id")
      @name = attributes["nombre"]
      @kind = attributes["clase"]
      @distance = attributes["distancia"]&.to_f
    end

    def name
      @name ||= content["Nombre"]
    end

    def kind
      @kind ||= object["clase"]
    end

    def category
      id.split("|").first
    end

    def normalized_address
      object["direccionNormalizada"]
    end

    # Longitude and latitude as a Location, or nil when EPOk has no
    # centroid for the object. Costs one extra request the first time.
    def location
      return @location if defined?(@location)

      centroid = object.dig("ubicacion", "centroide")
      @location = centroid && begin
        x, y = centroid[/\(([^)]*)\)/, 1].split.map(&:to_f)
        lon, lat = API.to_lonlat(x, y)
        Location.new(x: lon, y: lat)
      end
    end

    def content
      object["contenido"].each_with_object({}) do |entry, hash|
        name, value = entry.values_at("nombre", "valor")
        hash[name] = value unless value.empty?
      end
    end

    private

    def object
      @object ||= API.object(id)
    end
  end
end
