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
      assert_equal "Sede Comunal 4", object.name
    end

    def test_that_an_object_has_a_kind
      assert_equal "Sedes de Comunas", object.kind
    end

    def test_that_an_object_has_a_category
      assert_equal "sedes_de_comunas", object.category
    end

    def test_that_an_object_has_a_normalized_address
      assert_equal "BARCO CENTENERA del 2906", object.normalized_address
    end

    def test_that_an_object_has_a_location
      location = object.location

      assert_instance_of Location, location
      assert_in_delta(-58.42, location.x, 0.01)
      assert_in_delta(-34.65, location.y, 0.01)
    end

    def test_that_an_object_has_content
      content = object.content

      assert_equal "Sede Comunal 4", content["Nombre"]
      assert_equal "BARCO CENTENERA del 2906", content["Dirección"]
      assert_equal "NUEVA POMPEYA", content["Barrio"]
      assert_equal "Comuna 4", content["Comuna"]
      assert_match %r{<a href="https://buenosaires.gob.ar/}, content["Trámites y servicios"]
    end

    def test_that_listing_attributes_do_not_fetch
      object = Object.new(
        "id" => "farmacias|1082",
        "nombre" => "Farmacia en CERRITO 342",
        "clase" => "Farmacia",
        "distancia" => "112.31"
      )

      VCR.eject_cassette
      VCR.turned_off do
        assert_equal "Farmacia en CERRITO 342", object.name
        assert_equal "Farmacia", object.kind
        assert_equal "farmacias", object.category
        assert_in_delta 112.31, object.distance
      end
    end

    def test_that_an_object_built_from_an_id_has_no_distance
      assert_nil object.distance
    end

    private

    def object
      Object.new("sedes_de_comunas|4")
    end
  end
end
