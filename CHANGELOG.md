# yeti_thrift Changelog

## v3.2.0, September 23, 2026
- Raise `required_ruby_version` to `>= 3.3.0`, matching the interpreter used
  to regenerate the Thrift-generated Ruby (compiler 0.24.0, was 0.9.0 for
  `lib/yeti_thrift/gen-rb`). The regenerated output changes only comment
  headers and a `frozen_string_literal` magic comment; nothing in `lib/`
  changes behaviorally.

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
