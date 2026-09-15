require "test_helper"

module Epok
  class GeocodeTest < Minitest::Test
    def setup
      VCR.insert_cassette("geocode")
    end

    def teardown
      VCR.eject_cassette("geocode")
    end

    def test_that_an_address_is_normalized_and_located
      address = Epok.geocode("cabildo 1234").first

      assert_equal "CABILDO AV. 1234, CABA", address.address
      assert_in_delta(-58.448466, address.location.x)
      assert_in_delta(-34.568290, address.location.y)
    end

    def test_that_an_address_has_a_partido_and_localidad
      addresses = Epok.geocode("cabildo 1234")

      assert_equal "CABA", addresses.first.partido
      assert_equal "CABA", addresses.first.localidad
      assert_equal "La Matanza", addresses[1].partido
      assert_equal "Villa Madero", addresses[1].localidad
    end

    def test_that_an_unknown_address_raises_not_found
      error = assert_raises(NotFound) { Epok.geocode("xyzzy 999") }

      assert_equal "Calle inexistente: xyzzy 999", error.message
    end
  end
end
