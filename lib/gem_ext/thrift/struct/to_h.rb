module Thrift
  module Struct
    # Converts the struct to a hash. Values are converted recursively if
    # they contain structs.
    #
    # TODO: this does not have any special handling for enums
    #
    # @return [Hash<String, Object>] Keys are the names of populated fields for
    #   the struct.
    def to_h
      {}.tap do |result|
        each_field do |_, field_info|
          key, value = field_for_hash(field_info, send(field_info[:name]))
          result[key] = value unless value.nil?
        end
      end
    end

  end
end
