require 'spec_helper'

describe YetiThrift::Base64Serializer do

  let(:object) do
    YetiThriftTest::SimpleStruct.new do |struct|
      struct.long = 1
      struct.int = 2
      struct.str = 'foo'
      struct.t_or_f = true
    end
  end

  it 'subclasses Thrift::Serializer' do
    expect(described_class.new).to be_kind_of(::Thrift::Serializer)
  end

  it_behaves_like 'a wrapped Serializer/Deserializer'

  it 'base64 encodes serialized data' do
    yeti_serialized = ::YetiThrift::Serializer.new.serialize(object)
    expected = ::Base64.encode64(yeti_serialized)
    actual = ::YetiThrift::Base64Serializer.new.serialize(object)
    expect(actual).to eq(expected)
  end

  it 'can serialize and deserialize' do
    serialized = ::YetiThrift::Base64Serializer.new.serialize(object)
    expect(::YetiThrift::Base64Deserializer.new.
        deserialize(YetiThriftTest::SimpleStruct.new, serialized)).
        to eq(object)
  end

end
