module Thrift::Struct

  def self.included(base)
    base.extend ClassMethods
  end

end