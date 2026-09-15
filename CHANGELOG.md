# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project
follows [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Changed

- **Breaking:** `Epok.geocoder` is now `Epok.nearby`. Next to `Epok.geocode`
  (address to point) the old name read as the same thing backwards.
- Every string in an API response is stripped and squeezed once in `API.get`.
  The API pads and double-spaces names at random, in every endpoint, and the
  per-field strips it replaces only covered some of them.

## [0.5.0] - 2026-09-15

### Added

- `Epok.geocode(text)` turns "cabildo 1234" or "callao y corrientes" into
  `Address` structs with the normalized text, partido, localidad and a
  `Location`, via USIG's normalizer. Unknown addresses raise `Epok::NotFound`
  with the service's message.
- `Epok.datos_utiles(location)` returns the barrio, comuna, comisaría,
  hospital area, health region and school district for a point. Outside the
  city those are nil and `partido_amba` and `localidad_amba` are filled.
- `Epok.search` accepts `categories:` (one or an array) and `limit:`.

### Changed

- README rewritten around an end-to-end example.
- Removed minitest-reporters from the development dependencies.

## [0.4.0] - 2026-09-15

### Added

- `Epok::Object` keeps listing data: `name`, `kind`, `category` and
  `distance` (metres, from the geocoder) are available without a request.
  `content`, `normalized_address` and `location` fetch lazily.
- `Epok::Object#location` returns longitude and latitude, converted from the
  city's projected grid through USIG. Nil when the object has no centroid.
- `Epok.categories` lists all EPOk categories as `Category` structs.
- `Epok.geocoder` accepts `radius:` (default 500 metres) and an array of
  categories.
- `Epok::Error` wraps timeouts, network failures, non-2xx responses and bad
  JSON. `Epok::NotFound` for unknown ids.

## [0.3.0] - 2026-09-15

Tagged but never pushed to rubygems.org.

### Changed

- **Breaking:** `Epok.search` and `Epok.geocoder` return an
  `Epok::Collection`, which is `Enumerable` and lazy. `Epok::Search`,
  `Epok::Geocoder` and `Epok::Collectable` are removed, along with the
  `query`, `x`, `y` and `categories` readers.

### Fixed

- Query parameters are URL-encoded, so non-ASCII searches like "peña" no
  longer raise `URI::InvalidURIError`.

## [0.2.0] - 2026-09-15

### Fixed

- Requests go over HTTPS. The API started redirecting plain HTTP to HTTPS
  with an empty body, which made every call fail with a JSON parse error.
- Object content values are stripped of surrounding whitespace.
- Test suite runs on Ruby 4: vcr bumped to 6.x, lockfile regenerated,
  bundler dev dependency dropped.

## [0.1.1] - 2019-04-24

Initial release: `Epok.search`, `Epok.geocoder` and `Epok::Object`.

[Unreleased]: https://github.com/arzezak/epok/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/arzezak/epok/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/arzezak/epok/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/arzezak/epok/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/arzezak/epok/compare/e629f99...v0.2.0
[0.1.1]: https://github.com/arzezak/epok/commits/e629f99
