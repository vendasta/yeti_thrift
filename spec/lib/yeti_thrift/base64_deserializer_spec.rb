require 'spec_helper'

describe YetiThrift::Base64Deserializer do

  let(:object) do
    YetiThriftTest::SimpleStruct.new do |struct|
      struct.long = 1
      struct.int = 2
      struct.str = 'foo'
      struct.t_or_f = true
    end
  end

  it 'subclasses Thrift::Deserializer' do
    expect(described_class.new).to be_kind_of(::Thrift::Deserializer)
  end

  it_behaves_like 'a wrapped Serializer/Deserializer'

  it 'base64 decodes the value before deserializing' do
    serialized = ::YetiThrift::Serializer.new.serialize(object)
    base64_serialized = ::Base64.encode64(serialized)

    expect(::YetiThrift::Base64Deserializer.new.
        deserialize(YetiThriftTest::SimpleStruct.new, base64_serialized)).
        to eq(object)
  end
end
