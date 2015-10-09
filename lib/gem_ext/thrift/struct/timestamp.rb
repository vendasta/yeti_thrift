module Thrift
  module Struct
    # This method is intended to be called from initialize for a Struct.
    #
    # Since timestamp fields are not Thrift fields the default initialize
    # rejects them. This method looks for timestamp fields, assigns
    # them to the instance, and deletes the values from the hash.
    #
    # @param values [Hash] Field values to assign to the struct. The
    #   hash is modified when any timestamps are assigned.
    def assign_timestamps!(values)
      values.each do |name, _|
        if timestamp_fields.include?(name.to_sym)
          send("#{name}=", values.delete(name))
        end
      end if timestamp_fields.any?
    end
  end
end
