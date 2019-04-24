module Epok
  class Object
    attr_reader :id

    def initialize(id)
      @id = id
    end

    def name
      content["Nombre"]
    end

    def normalized_address
      object["direccionNormalizada"]
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
