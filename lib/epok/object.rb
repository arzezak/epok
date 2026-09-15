module Epok
  class Object
    attr_reader :id, :distance

    # Accepts either an id ("farmacias|1082") or a result hash from a search
    # or geocoder listing. Listing attributes are available immediately; the
    # full content is fetched on first use.
    def initialize(attributes)
      attributes = { "id" => attributes } if attributes.is_a?(String)

      @id = attributes.fetch("id")
      @name = attributes["nombre"]&.strip
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

    def content
      object["contenido"].each_with_object({}) do |entry, hash|
        name, value = entry.values_at("nombre", "valor")
        value = value.strip
        hash[name] = value unless value.empty?
      end
    end

    private

    def object
      @object ||= API.object(id)
    end
  end
end
