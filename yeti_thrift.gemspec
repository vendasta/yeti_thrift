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
  gem.required_ruby_version = '>= 3.3.0'

  gem.add_runtime_dependency 'thrift', '>= 0.9.1'
  gem.add_runtime_dependency 'activesupport'
  gem.add_runtime_dependency 'faraday'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'redcarpet'
  gem.add_development_dependency 'simplecov'
  # prior to v4.0 activesupport does include tzinfo as a dependency
  gem.add_development_dependency 'tzinfo'
  # thin web server used for testing only works with rack 2.x
  gem.add_development_dependency 'rack', '~> 2.0'
  # test-only: faraday_http_client_transport_spec boots Thrift::ThinHTTPServer
  gem.add_development_dependency 'thin'
end
