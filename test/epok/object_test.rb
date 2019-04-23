require "test_helper"

module Epok
  class ObjectTest < Minitest::Test
    def setup
      VCR.insert_cassette("object")
    end

    def teardown
      VCR.eject_cassette("object")
    end

    def test_that_an_object_has_a_name
      assert_equal "Calesita del Parque Saavedra", object.name
    end

    def test_that_an_object_has_a_normalized_address
      assert_equal "GARCIA DEL RIO y CONDE", object.normalized_address
    end

    def test_that_an_object_has_content
      expected_content = {
        "Nombre" => "Calesita del Parque Saavedra",
        "Dirección" => "GARCIA DEL RIO y CONDE (CP 1430) - Saavedra - Comuna 12",
        "Actividad Principal" => "Calesita",
        "Días y Horarios" => "Todos los días de 10:00 a 12:00 y de 14:00 a 19:30.",
        "Observaciones" => "Los días de lluvia la calesita se encuentra cerrada.",
        "Sector" => "Privado",
        "Público" => "Niños"
      }

      assert_equal expected_content, object.content
    end

    private

    def object
      Object.new("dependencias_culturales|1635")
    end
  end
end
