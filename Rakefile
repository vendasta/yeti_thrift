require "bundler/gem_tasks"

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new

require 'yeti_thrift/rake/thrift_gen_task'
YetiThrift::Rake::ThriftGenTask.new do |task|
  task.thrift_file = 'thrift/yeti_common.thrift'
  task.output_dir = 'lib/yeti_thrift'
end

YetiThrift::Rake::ThriftGenTask.new(:spec) do |task|
  task.task_desc = 'Generate ruby files for specs'

  task.thrift_file = 'spec/thrift/spec.thrift'
  task.output_dir = 'spec/support'
  task.include_dirs << 'thrift'
end

# All-in-one target for CI servers to run.
task :ci => ['spec']
