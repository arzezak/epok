# Epok

GCBA EPOk wrapper to query indexed geographic objects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "epok"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install epok

## Usage

Everything starts from a location (longitude, latitude) or a text search:

```ruby
>> obelisco = Epok::Location.new(x: -58.381570, y: -34.603738)
=> #<struct Epok::Location x=-58.38157, y=-34.603738>

>> nearby = Epok.geocoder(obelisco, %w[farmacias estaciones_de_subte], radius: 300)
=> #<Epok::Collection:0x00007f8719ab4f08 ...>

>> nearby.sort_by(&:distance).first(3).map { |o| [o.name, o.kind, o.distance.round] }
=> [["C. PELLEGRINI (Línea B)", "Estación de Subte (Metro)", 79],
    ["Farmacia en PELLEGRINI, CARLOS 423", "Farmacia", 83],
    ["9 DE JULIO (Línea D)", "Estación de Subte (Metro)", 107]]

>> sede_4 = Epok.search("cgp").first
=> #<Epok::Object:0x00007f8719b36788 @id="sedes_de_comunas|4" ...>

>> sede_4.name
=> "Sede Comunal 4"

>> sede_4.content
=> {"Nombre"=>"Sede Comunal 4", "Dirección"=>"BARCO CENTENERA del 2906", "Barrio"=>"NUEVA POMPEYA", "Comuna"=>"Comuna 4", ...}

>> sede_4.location
=> #<struct Epok::Location x=-58.41..., y=-34.65...>
```

Collections are `Enumerable` and fetch lazily, so nothing is requested until you iterate.

An `Epok::Object` knows its `id`, `name`, `kind`, `category` and (from the geocoder) `distance` in metres straight from the listing. `content`, `normalized_address` and `location` fetch the full record on first use, and `location` makes one more request to the city's USIG service to convert the projected coordinates to longitude and latitude.

The geocoder takes one category or an array. The full list, with ids and display names, is:

```ruby
>> Epok.categories.first
=> #<struct Epok::Category id="academias_de_espanol", name="Academias de Español", description="">
```

Typed addresses become locations through the city's USIG normalizer. Every match is returned, across the whole metro area, so the first one is usually the city's:

```ruby
>> Epok.geocode("callao y corrientes").first
=> #<struct Epok::Address address="CALLAO AV. y CORRIENTES AV., CABA", partido="CABA", localidad="CABA", location=#<struct Epok::Location x=-58.392293, y=-34.604434>>
```

To know where a location is, `Epok.datos_utiles` asks the city's USIG service for the neighbourhood, comuna, police precinct, hospital area, and school district. Outside the city those are nil and the AMBA partido and localidad are filled instead:

```ruby
>> Epok.datos_utiles(obelisco)
=> #<struct Epok::DatosUtiles barrio="San Nicolas", comuna="Comuna 1", comisaria="3", comisaria_vecinal="1B", area_hospitalaria="HTAL. DR. J.M. RAMOS MEJÍA", region_sanitaria="I (Este)", distrito_escolar="Distrito Escolar I", partido_amba=nil, localidad_amba=nil>
```

Every request failure raises `Epok::Error`. An id that does not exist raises `Epok::NotFound`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arzezak/epok. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Epok project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/arzezak/epok/blob/main/CODE_OF_CONDUCT.md).
