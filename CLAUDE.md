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

## Releasing

1. Make sure `main` is clean and pushed, and `bundle exec rake test` passes.
2. Bump `Epok::VERSION` in `lib/epok/version.rb`. Follow semver:
   patch for fixes, minor for new behaviour, major for breaking changes.
3. Commit it as `Bump version to X.Y.Z`.
4. Run `bundle exec rake release`. This builds the gem, creates and pushes
   the `vX.Y.Z` tag, and pushes the gem to rubygems.org. It needs rubygems
   credentials (`gem signin`) and may prompt for an OTP if the account has
   MFA enabled. If it prompts, the user has to run it themselves.
5. Create a GitHub release from the tag with a short summary of what changed:
   `gh release create vX.Y.Z --generate-notes`.

Version numbers on rubygems.org cannot be reused, so check the diff before
running step 4.
