require 'base64'

module YetiThrift

  # Specialization of the YetiThrift::Deserializer that assumes the incoming
  # serialized data has been base64 encoded. This is typically to deal with
  # transport mechanisms that do not work well with binary data such as Resque.
  class Base64Deserializer < ::YetiThrift::Deserializer
    def deserialize(base, buffer)
      super(base, ::Base64.decode64(buffer))
    end
  end
end
