# yeti_thrift Changelog

## v3.1.0, August 30, 2026
- Remove `thin` and `rack` from runtime dependencies. They were placeholders
  for thrift 0.9.1's missing gemspec metadata; nothing in `lib/` requires
  either. Both remain development dependencies for the `ThinHTTPServer` test
  fixture. Apps relying on the transitive `thin` must declare it themselves
  (a fleet sweep found none).

## v3.0.2, December 4, 2022
- Update to work with newer (7.1.0+) ActiveSupport versions

## v3.0.1, October 6, 2016
- Explicitly require `Object#try` from `ActiveSupport`.
- New shared examples for testing required fields and unions.

## v3.0.0, October 8, 2015
- First public release.
