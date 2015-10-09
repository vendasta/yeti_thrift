module Thrift
  class Union
    # Convert the union to a hash. The only key in the hash will be
    # for the set field. The value will converted recursively if it
    # contains a struct.
    def to_h
      {}.tap do |hash|
        unless @value.nil?
          name = @setfield.to_s
          hash.merge!(
              name => value_for_hash(struct_fields[name_to_id(name)], @value))
        end
      end
    end
  end
end
