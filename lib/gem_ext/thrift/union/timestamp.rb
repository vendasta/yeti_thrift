module Thrift
  class Union

    # This method is intended to be called from initialize for a Union.
    #
    # @param name [Symbol] The name of a member field.
    # @param value [Object] Time-like value.
    # @return [Array<Symbol, Object>] Returns the name and value
    #   for the field to set. This is the underlying seconds field if the
    #   name was a timestamp field.
    def assign_timestamp(name, value)
      _name = name; _value = value
      if timestamp_fields.include?(_name)
        send("#{_name}=", _value)
        _name, _value = get_set_field, get_value
      end
      [_name, _value]
    end
  end
end
