# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yeti_thrift/version'

Gem::Specification.new do |gem|
  gem.name          = "yeti_thrift"
  gem.version       = YetiThrift::VERSION
  gem.authors       = ["Yesware, Inc"]
  gem.email         = ["engineering@yesware.com"]
  gem.description   = %q{Yesware common thrift definitions and extensions}
  gem.summary       = gem.description
  gem.homepage      = ""
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib", "lib/yeti_thrift/gen-rb"]

  gem.add_runtime_dependency 'thrift'
  gem.add_runtime_dependency 'activesupport'
  gem.add_runtime_dependency 'faraday'

  # Include dependencies of Thrift. Not sure why they're not in
  # the gemspec for thrift, but 0.9.1 doesn't seem to have a
  # gemspec. Maybe a bug in that release?
  gem.add_runtime_dependency 'thin'
  gem.add_runtime_dependency 'rack'

  gem.add_development_dependency "rake",
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'redcarpet'
  gem.add_development_dependency 'simplecov'
  # prior to v4.0 activesupport does include tzinfo as a dependency
  gem.add_development_dependency 'tzinfo'
end
