require "epok/api"
require "epok/collection"
require "epok/object"
require "epok/version"

module Epok
  Location = Struct.new(:x, :y, keyword_init: true)
  Category = Struct.new(:id, :name, :description, keyword_init: true)
  DatosUtiles = Struct.new(
    :barrio, :comuna, :comisaria, :comisaria_vecinal,
    :area_hospitalaria, :region_sanitaria, :distrito_escolar,
    :partido_amba, :localidad_amba,
    keyword_init: true
  )

  Address = Struct.new(:address, :partido, :localidad, :location, keyword_init: true)

  DEFAULT_RADIUS = 500

  def self.search(query, categories: nil, limit: nil)
    categories = Array(categories).join(",") if categories

    Collection.new { API.search(query, categories, limit) }
  end

  def self.nearby(location, categories, radius: DEFAULT_RADIUS)
    categories = Array(categories).join(",")

    Collection.new { API.nearby(location.x, location.y, categories, radius) }
  end

  def self.geocode(text)
    API.geocode(text).map do |address|
      coordinates = address["coordenadas"]
      location = coordinates && Location.new(
        x: coordinates["x"].to_f, y: coordinates["y"].to_f
      )

      Address.new(
        address: address["direccion"],
        partido: address["nombre_partido"],
        localidad: address["nombre_localidad"],
        location: location
      )
    end
  end

  def self.datos_utiles(location)
    datos = API.datos_utiles(location.x, location.y)

    DatosUtiles.new(
      DatosUtiles.members.to_h do |member|
        value = datos[member.to_s]
        [member, value.to_s.empty? ? nil : value]
      end
    )
  end

  def self.categories
    API.categories.map do |category|
      Category.new(
        id: category["nombre_normalizado"],
        name: category["nombre"],
        description: category["descripcion"]
      )
    end
  end
end
