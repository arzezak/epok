# Epok

Ruby gem wrapping the GCBA EPOk API (https://epok.buenosaires.gob.ar).
No runtime dependencies beyond the standard library.

## Development

```
bundle install
bundle exec rake test     # records VCR cassettes into test/fixtures on first run
bundle exec swarf lib/    # complexity vs. coverage report, worst first
```

Cassettes are gitignored, so the first test run hits the live API.
The API rejects curl's default User-Agent, but Ruby's Net::HTTP works fine.

## API notes

Official docs are Swagger specs on the city's 3scale portal. The HTML at
https://datosabiertos-apis.buenosaires.gob.ar/BA_Root/Documentacion is
JavaScript-rendered; fetch the JSON directly:

- Index: https://datosabiertos-apis.buenosaires.gob.ar/api_docs/services.json
- EPOk ("Busquedas de Lugares"): .../api_docs/services/10.json
- USIG Geocoder: .../api_docs/services/8.json
- Datos Útiles: .../api_docs/services/9.json

The specs list `datosabiertos-*-apis.buenosaires.gob.ar` hosts that return
404. The live hosts are `epok.buenosaires.gob.ar` for EPOk and
`ws.usig.buenosaires.gob.ar` for USIG (REST index with docs at
https://ws.usig.buenosaires.gob.ar/rest/).

- `/buscar/` also takes `categoria` (comma-separated), `clase`, `bbox`,
  `start`, `limit` and `totalFull`.
- `/reverseGeocoderLugares/` takes `srid` (default 4326) and `radio`
  (default 1 metre, hence our 500 default).
- Unknown ids return `200 {}`, unknown categories return an empty list.
  Some geocoder results point at ids with no record (6 of 20 pharmacies
  near the Obelisco), so `content` can raise NotFound on a listed object.
- Strings come back padded or double-spaced at random, in every endpoint.
  `API.get` normalizes all of them once; nothing else should strip.
- Object coordinates are projected (Gauss-Krüger Buenos Aires). USIG's
  `/rest/convertir_coordenadas` turns them into longitude and latitude.
- `ws.usig.buenosaires.gob.ar/datos_utiles?x=&y=` answers with empty strings
  outside the city; `Epok.datos_utiles` turns those into nil.
- `servicios.usig.buenosaires.gob.ar/normalizar/?direccion=&geocodificar=true`
  matches across the whole AMBA, CABA first. Coordinates come back as
  strings for CABA and floats elsewhere. No match is `200` with an empty
  list and an `errorMessage`; `Epok.geocode` raises NotFound with it.
- A December 2025 city report says "API USIG" is being replaced by
  "API Servicios Geo" during 2026. The USIG hosts above may move.
