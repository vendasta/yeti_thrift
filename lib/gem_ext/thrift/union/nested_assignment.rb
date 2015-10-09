module Thrift
  class Union

    # This method is intended to be called from initialize for a Union.
    #
    # @param name [Symbol] The name of a member field.
    # @param value [Object]
    # @return [Array<Symbol, Object>] Returns the name and value
    #   of the field to set.
    def convert_nested(name, value)
      _name = name; _value = value
      field_info = struct_fields[name_to_id(_name.to_s)]
      if field_info && compound_type?(field_info[:type])
        _value = convert_value(field_info, _value)
      end
      [_name, _value]
    end
  end
end
