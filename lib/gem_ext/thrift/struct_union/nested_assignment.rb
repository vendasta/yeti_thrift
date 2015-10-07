module Thrift::Struct_Union

  COMPOUND_TYPES = Set.new([
    ::Thrift::Types::STRUCT,
    ::Thrift::Types::LIST,
    ::Thrift::Types::MAP,
    ::Thrift::Types::SET
  ])

  # Is this a thrift type that may require conversion?
  #
  # @param type [Fixnum] Thrift type for a field
  # @return [Boolean]
  def compound_type?(type)
    COMPOUND_TYPES.include?(type)
  end

  # Perform any automatic conversion that is required to assign the value to
  # its destination based on the field_info metadata.
  #
  # If no conversion is required, then the original value is returned.
  #
  # This method is called recursively, indirectly through the other convert*
  # methods.
  #
  # @param field_info [Hash] Hash of metadata about a field, element,
  #   key or value.
  # @param value [Object] The value for a field which may require conversion.
  def convert_value(field_info, value)
    case field_info[:type]
    when ::Thrift::Types::STRUCT
      convert_struct(field_info, value)
    when ::Thrift::Types::LIST
      convert_list(field_info, value)
    when ::Thrift::Types::SET
      convert_set(field_info, value)
    when ::Thrift::Types::MAP
      convert_map(field_info, value)
    end || value
  end
  private :convert_value

  # Convert a hash into the target class for a struct.
  # Returns nil if the value is not a hash.
  #
  # @param field_info [Hash] Hash of metadata about a struct.
  # @param value [Object] The value for a field which may require conversion.
  #
  # @return [Struct, NilClass]
  def convert_struct(field_info, value)
    if value.is_a?(Hash)
      field_info[:class].new(value)
    end
  end
  private :convert_struct

  # Convert an array if the elements require conversion.
  # Returns nil if the elements do not require conversion.
  #
  # @param field_info [Hash] Hash of metadata about a list.
  # @param value [Array] The value for a field which may require conversion.
  #
  # @return [Array, NilClass]
  def convert_list(field_info, value)
    if compound_type?(field_info[:element][:type])
      convert_enumerable(field_info[:element], value)
    end
  end
  private :convert_list

  # Convert a set if the members require conversion.
  # Returns nil if the members do not require conversion.
  #
  # @param field_info [Hash] Hash of metadata about a set.
  # @param value [Enumerable] The value for a field which may require conversion.
  #
  # @return [Set, NilClass]
  def convert_set(field_info, value)
    if compound_type?(field_info[:element][:type])
      Set.new(convert_enumerable(field_info[:element], value))
    end
  end
  private :convert_set

  # Convert an enumerable object value-by-value, returning an array.
  #
  # @param element_info [Hash] Hash of metadata about an element.
  # @param value [Enumerable] The value to convert.
  #
  # @return [Array]
  def convert_enumerable(element_info, value)
    value.map do |element|
      convert_value(element_info, element)
    end
  end
  private :convert_enumerable

  # Convert a hash if the keys and/or values require conversion.
  # Returns nil if the keys/values do not require conversion.
  #
  # @param field_info [Hash] Hash of metadata about a map.
  # @param value [Hash] The value for a field which may require conversion.
  #
  # @return [Set, NilClass]
  def convert_map(field_info, value)
    value_info = field_info[:value]
    key_info = field_info[:key]
    if compound_type?(value_info[:type]) || compound_type?(key_info[:type])
      value.reduce(Hash.new) do |memo, (k, v)|
        memo.tap do |hash|
          hash[convert_value(key_info, k)] = convert_value(value_info, v)
        end
      end
    end
  end
  private :convert_map
end
