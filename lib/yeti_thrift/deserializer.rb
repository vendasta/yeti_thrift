module YetiThrift

  # This class wraps the Thrift::Deserializer with a different
  # default protocol.
  class Deserializer < ::Thrift::Deserializer
    def initialize(protocol_factory = ::Thrift::CompactProtocolFactory.new)
      super(protocol_factory)
    end
  end
end