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

- `/buscar/`, `/reverseGeocoderLugares/` and `/getObjectContent/` are the
  documented endpoints. `/getCategorias/` is not documented but lists all
  categories the geocoder accepts.
- Unknown ids return `200 {}`, unknown categories return an empty list.
- Object coordinates are projected (Gauss-Krüger Buenos Aires). USIG's
  `convertir_coordenadas` service turns them into longitude and latitude.

## Releasing

1. Make sure `main` is clean and pushed, and `bundle exec rake test` passes.
2. Bump `Epok::VERSION` in `lib/epok/version.rb`. Follow semver:
   patch for fixes, minor for new behaviour, major for breaking changes.
3. Commit it as `Bump version to X.Y.Z`.
4. Run `bundle exec rake release`. This builds the gem into `pkg/`, creates
   and pushes the `vX.Y.Z` tag, and pushes the gem to rubygems.org.
   The push prompts for a rubygems OTP, so it has to run in an interactive
   terminal. If it fails after tagging, push the built gem directly:
   `gem push pkg/epok-X.Y.Z.gem`.
5. Create a GitHub release from the tag with a short summary of what changed:
   `gh release create vX.Y.Z --generate-notes`.

Version numbers on rubygems.org cannot be reused, so check the diff before
running step 4.
