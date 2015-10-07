module YetiThrift

  # This class wraps the Thrift::Serializer with a different
  # default protocol.
  class Serializer < ::Thrift::Serializer
    def initialize(protocol_factory = ::Thrift::CompactProtocolFactory.new)
      super(protocol_factory)
    end
  end
end