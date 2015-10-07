# Start up coverage before anything else,
# otherwise we only get coverage for rspecs.
require 'simplecov'
SimpleCov.start do
  add_filter "/spec/" # ignore spec files
  add_filter "/lib/yeti_thrift/rake/thrift_gen_task.rb"
end
SimpleCov.minimum_coverage 100

filedir = File.dirname(__FILE__)
$LOAD_PATH.unshift(File.join(filedir, '..', 'lib'))
$LOAD_PATH.unshift(filedir)
$LOAD_PATH.unshift(File.join(filedir, 'support', 'gen-rb'))

require 'rspec'
require 'yeti_thrift'
require 'spec/support/yeti_thrift_shared_examples'
require 'active_support/log_subscriber/test_helper'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.order = 'random'
end
