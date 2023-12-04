require 'active_support'
require 'active_support/core_ext/string/inflections'
require 'yeti_thrift/exceptions'

module Thrift::Struct

  module ClassMethods

    # Does the class have a version field and is there a version constant
    # defined for it? If the class is versioned and the version setter
    # has not yet been replaced, then override with a method that
    # raises an exception.
    # @return [Boolean]
    def versioned?
      (public_instance_methods.include?(:version) &&
          (struct_version != 0)).tap do |versioned|
        if versioned && !@version_initialized
          replace_version_setter
          @version_initialized = true
        end
      end
    end

    # Override the version setter method for the class to raise
    # an exception.
    # @return [Void]
    def replace_version_setter
      define_method(:version=) do |_|
        raise ::YetiThrift::AutomaticStructVersion,
              "version field cannot be set on #{self.class.name}"
      end
    end
    private :replace_version_setter

    def struct_version
      @struct_version ||= compute_struct_version
    end

    def compute_struct_version
      if class_module.const_defined?(version_constant_name)
        class_module.const_get(version_constant_name)
      else
        0
      end
    end
    private :compute_struct_version

    def class_module
      @class_module ||= compute_class_module
    end
    private :class_module

    def compute_class_module
      # Do not use deconstantize until activesupport 3.2 can be required
      # This copies the implementation from 3.2.13 active_support/inflector/methods
      # name.deconstantize.constantize
      name[0...(name.rindex('::') || 0)].constantize
    end
    private :compute_class_module

    def version_constant_name
      @version_constant_name ||= compute_version_constant_name
    end
    private :version_constant_name

    def compute_version_constant_name
      "#{name.demodulize.underscore.upcase}_VERSION"
    end
    private :compute_version_constant_name

  end
end
