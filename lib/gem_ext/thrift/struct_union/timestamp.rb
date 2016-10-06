require 'active_support/core_ext/array/extract_options'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/time/zones'
require 'active_support/core_ext/module/delegation'

# Thrift does not provide a date or timestamp field type.
# The methods in this module define accessors for an i64 field
# used to store a timestamp as a number of seconds.
module Thrift::Struct_Union

  TIME_CLASS_DEFAULT = Time

  # Alias class because delegate cannot be used with class using
  # ActiveSupport < 4.0
  alias_method :klass, :class

  delegate :timestamp_map,
           :timestamp_fields,
           :timestamp_seconds_fields,
           :to => :klass

  # @return [Boolean]
  def seconds_field?(field_name)
    timestamp_seconds_fields.include?(field_name.try(:to_sym))
  end
  private :seconds_field?

  module ClassMethods

    # Specify the time_class to be used for timestamp fields for
    # a Thrift::Struct class.
    #
    # @example Use the time class
    #   time_class Time
    #
    # If a value is specified then the time_class is set.
    # If no value is specified then the current time_class is returned.
    #
    # @return value [Class] Must respond to #at to create a Time-like object.
    def time_class(value = nil)
      if value.present?
        @time_class = value
      else
        @time_class || TIME_CLASS_DEFAULT
      end
    end

    # Hash containing information about the timestamp fields defined for a
    # a class.
    # Keys are the names of the underlying i64 fields that store seconds.
    #
    # Values are hashes containing the name of the timestamp field, and the
    # name of the time class, if non-default.
    #
    # @return [Hash<Symbol, Hash>]
    def timestamp_map
      @timestamp_map ||= {}
    end

    # @return [Set<Symbol>]
    def timestamp_seconds_fields
      @timestamp_seconds_fields ||= timestamp_map.keys.to_set
    end

    # @return [Set<Symbol>]
    def timestamp_fields
      @timestamp_fields ||= timestamp_map.values.map do |info|
        info[:timestamp]
      end.to_set
    end

    # @param name [String, Symbol]
    # @param seconds [Symbol]
    # @param time_class [Class]
    def add_to_timestamp_map(name, seconds, time_class)
      @timestamp_seconds_fields = nil
      @timestamp_fields = nil
      timestamp_map[seconds] = {
        :timestamp => name.to_sym,
        :time_class => time_class
      }
    end
    private :add_to_timestamp_map

    # Define virtual attributes for a timestamp. This method defines
    # accessors around a field that stores a number of seconds since epoch.
    #
    # @example Define :sent_at accessor around a :sent field.
    #   timestamp_field :sent_at
    #
    # @example Define :message_sent_at accessor around a :sent field.
    #   timestamp_field :message_sent_at, :seconds_field => :sent
    #
    # @example Define :sent_at accessor for Time attributes
    #   timestamp_field :sent_at, :time_class => Time
    #
    # @param name [String, Symbol]
    # @param options [Hash]
    # @option :seconds_field [String, Symbol] Name of the underlying i64 field.
    # @option :time_class [Class] Class for timestamp fields.
    #   This should respond to #at to create a Time-like object from seconds.
    def timestamp_field(*args)
      options = args.extract_options!.with_indifferent_access
      name = args.first
      validate_timestamp_name(name)

      seconds = get_seconds_field_value(options[:seconds_field], name)
      raise ':name and :seconds_field must be different' if (name.to_sym == seconds)
      validate_seconds_field(seconds)

      time_klass = get_time_class_for_field(options[:time_class])

      # Define reader
      define_method("#{name}") do
        i64_value = self.send(seconds)
        time_klass.at(i64_value) if i64_value
      end

      # Define writer
      define_method("#{name}=") do |value|
        i64_value = value.to_i if value
        self.send("#{seconds}=", i64_value)
      end

      add_to_timestamp_map(name, seconds, time_klass)
    end

    # Determine the class used for timestamp fields.
    # @return [Class]
    def get_time_class_for_field(option)
      if option.present?
        option
      else
        self.time_class
      end
    end
    private :get_time_class_for_field

    # @param option [String, Symbol] Name for the seconds field from options.
    # @param timestamp_name [String, Symbol]
    # @return [Symbol]
    def get_seconds_field_value(option, timestamp_name)
      if option.present?
        option
      else
        seconds_field_from_timestamp_name(timestamp_name)
      end.to_sym
    end
    private :get_seconds_field_value

    # Determine the name of the underlying seconds field based on
    # removing "_at" from the end of a timestamp attribute.
    # @return [String]
    def seconds_field_from_timestamp_name(name)
      name_str = name.to_s
      if name_str.end_with?('_at')
        name_str.slice(0..-4)
      else
        raise ':name does not match expected format: <seconds>_at'
      end
    end
    private :seconds_field_from_timestamp_name

    # Check that the seconds field exists for the struct and
    # that it has the expected type.
    # @param seconds_name [Symbol]
    def validate_seconds_field(seconds_name)
      seconds_str = seconds_name.to_s
      _, field = self::FIELDS.find { |_, v| v[:name] == seconds_str }
      raise "seconds field '#{seconds_str}' not found" if field.nil?
      if field[:type] != ::Thrift::Types::I64
        raise "seconds field '#{seconds_str}' does not have type I64"
      end
    end
    private :validate_seconds_field

    # Check that a name was specified, that it is not
    # an existing field for the struct, and that it does
    # not conflict with existing methods.
    # @param name [String, Symbol]
    def validate_timestamp_name(name)
      raise ':name must be specified for a timestamp' unless name.present?

      name_str = name.to_s
      name_field = self::FIELDS.find { |_, v| v[:name] == name_str }
      raise "'#{name_str}' is already a field" unless name_field.nil?

      if self.instance_methods.include?(name.to_sym) ||
             self.instance_methods.include?("#{name_str}=".to_sym)
        raise "timestamp field conflicts with ##{name_str} and/or ##{name_str}="
      end
    end
    private :validate_timestamp_name
  end

end
