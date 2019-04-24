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

```ruby
>> obelisco = Epok::Location.new(x: -58.381570, y: -34.603738)
=> #<struct Epok::Location x=-58.38157, y=-34.603738>

>> pharmacies_around_obelisco = Epok.geocoder(obelisco, "farmacias")
=> #<Epok::Geocoder:0x00007f8719ab4f08 @x=-58.38157, @y=-34.603738, @categories="farmacias">

>> pharmacies_around_obelisco.first.content
=> {"Nombre"=>"Farmacia en PELLEGRINI, CARLOS 765", "Teléfono"=>"43223198 43220298"}

>> cgp = Epok.search("cgp")
=> #<Epok::Search:0x00007f871a09ac60 @query="cgp">

>> sede_4 = cgp.first
=> #<Epok::Object:0x00007f8719b36788 @id="sedes_de_comunas|4">

>> sede_4.name
=> "Sede Comunal 4"

>> sede_4.content
=> {"Nombre"=>"Sede Comunal 4", "Dirección"=>"BARCO CENTENERA del 2906", "Teléfonos"=>"4918-2243/1815/8920-4949 9024 Int. 105", "Trámites y Servicios"=>"<a href=\"http://www.buenosaires.gob.ar/comuna-4/sede-comunal-4\" target=\"_blank\">link</a>"}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/arzezak/epok. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Epok project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/arzezak/epok/blob/master/CODE_OF_CONDUCT.md).
