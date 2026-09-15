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

"I'm at Callao y Corrientes, what's around me?" in five requests:

```ruby
require "epok"

# 1. Turn a typed address into coordinates.
here = Epok.geocode("callao y corrientes").first
puts "You are at #{here.address}"

# 2. Which neighbourhood and comuna is that?
area = Epok.datos_utiles(here.location)
puts "That's #{area.barrio}, #{area.comuna}"

# 3. What's within 300 metres, by category?
nearby = Epok.nearby(here.location, %w[estaciones_de_subte farmacias], radius: 300)
nearby.sort_by(&:distance).first(5).each do |place|
  puts "  #{place.distance.round} m  #{place.name} (#{place.kind})"
end

# 4. Drill into one: full record and coordinates for a map pin.
closest = nearby.min_by(&:distance)
puts "Pin: #{closest.location.y}, #{closest.location.x}"
closest.content.each { |key, value| puts "  #{key}: #{value}" }
```

```
You are at CALLAO AV. y CORRIENTES AV., CABA
That's San Nicolas, Comuna 3
  3 m  CALLAO - MAESTRO ALFREDO BRAVO (Línea B) (Estación de Subte (Metro))
  42 m  Farmacia en CORRIENTES AV. 1820 (Farmacia)
  73 m  Farmacia en CORRIENTES AV. 1835 (Farmacia)
  98 m  Farmacia en CALLAO AV. 477 (Farmacia)
  111 m  Farmacia en CORRIENTES AV. 1880 (Farmacia)
Pin: -34.604419, -58.392318
  Nombre: CALLAO - MAESTRO ALFREDO BRAVO (Línea B)
  Línea: B
  Estado: Estación Malabia cerrada por obras de renovación integral.
  Cabeceras: J. M. de Rosas - L. N. Alem
  Tiempo: 27 min.
```

Steps 1 to 3 are one request each; step 4 is two (the record, then the coordinate conversion). The content hash is whatever the city publishes for that category: subway stations carry line, status and travel time, pharmacies carry phone and delivery details.

### The rest

**Search by text**, optionally filtered by category and capped:

```ruby
Epok.search("cgp", categories: "sedes_de_comunas", limit: 3).map(&:name)
# => ["Sede Comunal 4", "Sede Comunal 9", "Sede Comunal 10"]
```

**Categories** are what `nearby` and the search filter take. There are 167, each with an id, a display name and a description:

```ruby
Epok.categories.find { |c| c.id == "farmacias" }
# => #<struct Epok::Category id="farmacias", name="Farmacias", description="">
```

**Collections** from `search` and `nearby` are `Enumerable` and lazy: nothing is requested until you iterate.

**Objects** know their `id`, `name`, `kind`, `category` and, from `nearby`, `distance` in metres straight from the listing. `content`, `normalized_address` and `location` fetch the full record on first use; `location` also converts the city's projected coordinates through USIG. `Epok::Object.new("farmacias|1082")` looks one up by id.

**Locations** are `Epok::Location.new(x: longitude, y: latitude)`. `geocode` returns every match across the metro area, city first, as `Address` structs with `address`, `partido`, `localidad` and `location`. `datos_utiles` returns nil for the city fields outside CABA and fills `partido_amba` and `localidad_amba` instead.

**Errors**: every request failure raises `Epok::Error`. An unknown id or address raises `Epok::NotFound`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arzezak/epok. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Epok project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/arzezak/epok/blob/main/CODE_OF_CONDUCT.md).
