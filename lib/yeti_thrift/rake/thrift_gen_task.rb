require 'rake'
require 'rake/tasklib'

module YetiThrift
  module Rake

    # Rake task to generate ruby classes from Thrift
    # interface definition files.
    class ThriftGenTask < ::Rake::TaskLib
      # The name of the task
      # @return [String] the task name
      attr_accessor :name

      # The namespace for the task
      # @return [String] the namespace for the task
      attr_accessor :task_namespace

      # Description for the task
      # @return [String] a description for the task
      attr_accessor :task_desc

      # List of directories searched for include directives
      # @return [Array] directories searched for included directives
      attr_accessor :include_dirs

      # Parent directory for generated files.
      # A "gen-rb" directory will be created beneath this location.
      # This corresponds to the thrift "-o" option.
      # @return [String] parent directory for "gen-rb" output directory
      attr_accessor :output_dir

      # Output directory location for generated files.
      # If specified this overrides +output_dir+ and
      # no "gen-rb" directory is created.
      # This corresponds to the thrift "-out" option.
      # @return [String] output directly location.
      attr_accessor :output_location

      # Thrift interface definition file.
      # @return [String] file location
      attr_accessor :thrift_file

      # Creates a new task with name +name+.
      #
      # @param [String, Symbol] name the name of the rake task
      # @yield a block to allow any options to be modified on the task
      def initialize(name = :gen)
        @name = name
        @task_namespace = :thrift
        @task_desc = 'Generate ruby classes from Thrift'
        @include_dirs = []

        yield self if block_given?

        define
      end

      # Define the rake task
      # @return [void]
      # !@visibility protected
      def define
        include_dirs_str = compute_include_dirs
        output_dir_str = compute_output_dir

        namespace task_namespace do
          desc task_desc
          task(name) do
            raise 'thrift_file must be specified' unless thrift_file
            %x{ which -s thrift }
            raise 'thrift executable not found' unless $?.success?
            %x{ thrift --gen rb #{include_dirs_str} #{output_dir_str} #{thrift_file} }
            unless $?.success?
              puts "" # prevent "rake aborted!" from appearing on same line as the error
              raise "#{self.class.name} failed" unless $?.success?
            end
          end
        end
      end
      protected :define

      # Compute a formatted string for all directories to
      # search for included directives.
      # @return [String]
      # @!visibility private
      def compute_include_dirs
        include_dirs.map do |dir|
          "-I #{dir}" if dir && !dir.empty?
        end.compact.join(' ')
      end
      private :compute_include_dirs

      # Compute a formatted string for where generated files
      # will be written.
      # If specified `output_location` (-out) is preferred over
      # `output_dir` (-o).
      # @return [String]
      # @!visibility private
      def compute_output_dir
        if output_location
          "-out #{output_location}"
        elsif output_dir
          "-o #{output_dir}"
        end
      end
      private :compute_output_dir
    end
  end
end
