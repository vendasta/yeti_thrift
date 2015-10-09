module Thrift::Struct

  alias_method :default_initialize, :initialize

  # Overrides the default initializer defined by Thrift::Struct.
  #
  # - Sets the version field if present.
  # - Converts any nested structs or structs within
  #   sets, arrays, or hashes.
  # - Calls the default initialize.
  #
  # @param d [Hash] Field values to set in the new instance.
  # @yield [instance] Block is yielded the newly created instance.
  def initialize(d = {}, &block)
    values = d.dup
    if self.class.versioned?
      values.merge!('version' => self.class.struct_version)
    end
    unless values.empty?
      assign_nested!(values)
      assign_timestamps!(values)
    end
    default_initialize(values, &block)
  end

end
