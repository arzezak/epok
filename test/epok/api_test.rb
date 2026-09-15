require "test_helper"

module Epok
  class APITest < Minitest::Test
    include WebMock::API

    def setup
      VCR.eject_cassette
      VCR.turn_off!
    end

    def teardown
      WebMock.reset!
      VCR.turn_on!
    end

    def test_that_a_server_error_raises
      stub_request(:get, /epok/).to_return(status: 500, body: "boom")

      error = assert_raises(Error) { Epok.search("x").first }
      assert_match "500", error.message
    end

    def test_that_a_timeout_raises
      stub_request(:get, /epok/).to_timeout

      assert_raises(Error) { Epok.categories }
    end

    def test_that_a_non_json_body_raises
      stub_request(:get, /epok/).to_return(status: 200, body: "<html>")

      assert_raises(Error) { Epok.search("x").first }
    end

    def test_that_a_missing_object_raises_not_found
      stub_request(:get, /getObjectContent/).to_return(status: 200, body: "{}")

      assert_raises(NotFound) { Object.new("nope|1").content }
    end

    def test_that_an_object_without_a_centroid_has_no_location
      stub_request(:get, /getObjectContent/)
        .to_return(status: 200, body: '{"contenido": [], "ubicacion": null}')

      object = Object.new("espacios_verdes_publicos|1")

      assert_nil object.location
      assert_nil object.location
    end

    def test_that_a_failed_coordinate_conversion_raises
      stub_request(:get, /getObjectContent/)
        .to_return(status: 200, body: '{"ubicacion": {"centroide": "POINT (1 2)"}}')
      stub_request(:get, /usig/)
        .to_return(status: 200, body: '{"tipo_resultado":"Error","resultado":{"x":"","y":""}}')

      assert_raises(Error) { Object.new("x|1").location }
    end

    def test_that_strings_in_responses_are_normalized
      stub_request(:get, /buscar/).to_return(status: 200, body: JSON.generate(
        "instancias" => [{"id" => "x|1", "nombre" => "  LA NAVE  LIBROS ", "clase" => " Libreria "}]
      ))

      result = Epok.search("x").first

      assert_equal "LA NAVE LIBROS", result.name
      assert_equal "Libreria", result.kind
    end

    def test_that_an_unparseable_centroid_raises
      stub_request(:get, /getObjectContent/)
        .to_return(status: 200, body: '{"ubicacion": {"centroide": "garbage"}}')

      assert_raises(Error) { Object.new("x|1").location }
    end

    def test_that_non_string_content_values_are_tolerated
      stub_request(:get, /getObjectContent/).to_return(status: 200, body: JSON.generate(
        "contenido" => [
          {"nombre" => "Nombre", "valor" => "Plaza"},
          {"nombre" => "Codigo", "valor" => 12},
          {"nombre" => "Vacio", "valor" => nil}
        ]
      ))

      assert_equal({"Nombre" => "Plaza", "Codigo" => "12"}, Object.new("x|1").content)
    end

    def test_that_a_geocode_match_without_coordinates_has_no_location
      stub_request(:get, /normalizar/).to_return(status: 200, body: JSON.generate(
        "direccionesNormalizadas" => [{"direccion" => "X 1, CABA", "nombre_partido" => "CABA", "nombre_localidad" => "CABA"}]
      ))

      assert_nil Epok.geocode("x 1").first.location
    end

    def test_that_not_found_is_an_error
      assert_operator NotFound, :<, Error
    end
  end
end
