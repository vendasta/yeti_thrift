module Thrift
  module Struct
    # This method is intended to be called by initialize.
    #
    # It looks at the fields being set, and based on the
    # metadata for the class it converts values into the
    # expected target type.
    #
    # @param values [Hash] Field values to assign. This hash is modified
    #   when values are converted.
    def assign_nested!(values = {})
      values.each do |name, value|
        field_info = struct_fields[name_to_id(name.to_s)]
        if field_info && compound_type?(field_info[:type])
          values[name] = convert_value(field_info, value)
        end
      end
    end
    private :assign_nested!
  end
end
