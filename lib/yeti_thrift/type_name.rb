module YetiThrift

  # Returns the capitalized name, e.g. 'String' corresponding
  # to a Thrift type.
  def self.type_name(type_id)
    get_type_map[type_id]
  end

  def self.get_type_map
    @_type_map ||= cache_type_map
  end
  private_class_method :get_type_map

  def self.cache_type_map
    ::Thrift::Types.constants.reduce({}) do |memo, sym|
      memo.tap do |hash|
        hash[::Thrift::Types.const_get(sym)] = sym.to_s.capitalize
      end
    end
  end
  private_class_method :cache_type_map

end