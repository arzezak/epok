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
      assert_equal "BIBLIOTECA ANMAT ", object.name
    end

    def test_that_an_object_has_a_normalized_address
      assert_equal "DE MAYO AV. 869", object.normalized_address
    end

    def test_that_an_object_has_content
      expected_content = {
        "Nombre" => "BIBLIOTECA ANMAT ",
        "Categoria" => "BIBLIOTECA",
        "Subcategoria" => "ESPECIALIZADA GUBERNAMENTAL",
        "Teléfonos" => "54.011 4340-0800 INT. 1047 FAX 54.011 4340-0800 INT. 1048",
        "E-Mail" => "<a href=\"mailto:contacto@example.com\">contacto@example.com</a>",
        "Página WEB" => "<a href=\"http://WWW.ANMAT.GOV.AR\" target=\"_blank\">WWW.ANMAT.GOV.AR</a>",
        "Dependencia" => "ADMINISTRACION NACIONAL DE MEDICAMENTOS Y TECNOLOGIA MEDICA ANMAT",
        "Sector" => "PUBLICO",
        "Dirección" => "DE MAYO AV. 869",
        "Barrio" => "MONSERRAT",
        "Comuna" => "Comuna 1"
      }

      assert_equal expected_content, object.content
    end

    private

    def object
      Object.new("dependencias_culturales|1635")
    end
  end
end
