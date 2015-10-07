require 'base64'

module YetiThrift

  # Specialization of the YetiThrift::Serializer that base-64 encodes the
  # serialized data before returning. This is typically to deal with transport
  # mechanisms that do not work well with binary data such as Resque.
  class Base64Serializer < ::YetiThrift::Serializer
    def serialize(base)
      ::Base64::encode64(super(base))
    end
  end
end
