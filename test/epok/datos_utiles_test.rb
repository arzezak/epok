require "test_helper"

module Epok
  class DatosUtilesTest < Minitest::Test
    def setup
      VCR.insert_cassette("datos_utiles")
    end

    def teardown
      VCR.eject_cassette("datos_utiles")
    end

    def test_that_datos_utiles_returns_the_barrio_and_comuna
      datos = Epok.datos_utiles(Location.new(x: -58.381570, y: -34.603738))

      assert_equal "San Nicolas", datos.barrio
      assert_equal "Comuna 1", datos.comuna
    end

    def test_that_datos_utiles_returns_the_other_jurisdictions
      datos = Epok.datos_utiles(Location.new(x: -58.381570, y: -34.603738))

      assert_equal "3", datos.comisaria
      assert_equal "1B", datos.comisaria_vecinal
      assert_equal "HTAL. DR. J.M. RAMOS MEJÍA", datos.area_hospitalaria
      assert_equal "I (Este)", datos.region_sanitaria
      assert_equal "Distrito Escolar I", datos.distrito_escolar
    end

    def test_that_outside_the_city_fields_are_nil_and_amba_is_filled
      datos = Epok.datos_utiles(Location.new(x: -58.60, y: -34.60))

      assert_nil datos.barrio
      assert_nil datos.comuna
      assert_equal "Tres de Febrero", datos.partido_amba
      assert_equal "Ciudad Jardín Lomas de El Palomar", datos.localidad_amba
    end
  end
end
