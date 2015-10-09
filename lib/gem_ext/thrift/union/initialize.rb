module Thrift
  class Union

    alias_method :default_initialize, :initialize

    # Override the default initializer defined by Thrift::Union.
    #
    # @param name [Symbol, String, Hash]
    # @param value [Object, NilClass]
    def initialize(name = nil, value = nil)
      _name, _value = name, value
      if name.is_a?(Hash)
        if name.size <= 1
          _name, _value = name.keys.first, name.values.first
        end
      else
        # Note: it may be a bug in Thrift::Union that that name
        # passed to initialize must be a Symbol for it to be recognized
        # as set.
        _name = _name.to_sym if _name
      end


      if _name && _value
        _name, _value = assign_timestamp(_name, _value)
        _name, _value = convert_nested(_name, _value)
      end

      default_initialize(_name, _value)
    end
  end
end
