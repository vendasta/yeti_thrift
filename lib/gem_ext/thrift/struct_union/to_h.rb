require 'yeti_thrift/exceptions'
require 'yeti_thrift/type_name'

module Thrift
  module Struct_Union

    BASIC_TYPES = [
        ::Thrift::Types::BOOL,
        ::Thrift::Types::BYTE,
        ::Thrift::Types::I16,
        ::Thrift::Types::I32,
        ::Thrift::Types::I64,
        ::Thrift::Types::DOUBLE,
        ::Thrift::Types::STRING
    ].to_set

    # @param field_info [Hash]
    # @param value [Object] The value for the field.
    # @return [(String, Object)] Returns the name of the field for the hash
    #   and the value.
    def field_for_hash(field_info, value)
      case

      when field_info[:type] == ::Thrift::Types::LIST
        list_to_h(field_info, value)

      when value.is_a?(::Thrift::Union)
        union_to_h(field_info, value)

      when field_info[:type] == ::Thrift::Types::STRUCT
        struct_to_h(field_info, value)

      when field_info[:type] == ::Thrift::Types::MAP
        map_to_h(field_info, value)

      when field_info[:type] == ::Thrift::Types::SET
        set_to_h(field_info, value)

      when seconds_field?(field_info[:name])
        timestamp_to_h(field_info)

      when BASIC_TYPES.include?(field_info[:type])
        wrap_to_h_value(field_info[:name]) { value }

      end
    end

    def value_for_hash(field_info, value)
      field_for_hash(field_info, value).last
    end

    def wrap_to_h_value(field_name)
      [field_name, yield]
    end
    private :wrap_to_h_value

    def set_to_h(field_info, value)
      wrap_to_h_value(field_info[:name]) do
        value.map do |element|
          value_for_hash(field_info[:element], element)
        end.to_set if value
      end
    end
    private :set_to_h

    def map_to_h(field_info, value)
      wrap_to_h_value(field_info[:name]) do
        value.reduce(Hash.new) do |memo, (k, v)|
          memo[value_for_hash(field_info[:key], k)] =
              value_for_hash(field_info[:value], v)
          memo
        end if value
      end
    end
    private :map_to_h

    def union_to_h(field_info, union)
      wrap_to_h_value(field_info[:name]) { union.to_h }
    end
    private :union_to_h

    def struct_to_h(field_info, struct)
      wrap_to_h_value(field_info[:name]) { struct.try(:to_h) }
    end
    private :struct_to_h

    def list_to_h(field_info, value)
      wrap_to_h_value(field_info[:name]) do
        value.try(:map) { |element| value_for_hash(field_info[:element], element) }
      end
    end
    private :list_to_h

    # @return [Array[String, Object]]
    def timestamp_to_h(field_info)
      timestamp_info = timestamp_map[field_info[:name].to_sym]
      timestamp = timestamp_info[:timestamp].to_s
      wrap_to_h_value(timestamp) { send(timestamp) }
    end
    private :timestamp_to_h

  end
end
