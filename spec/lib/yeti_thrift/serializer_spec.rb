require 'spec_helper'

describe YetiThrift::Serializer do

  describe '#initialize' do
    it 'subclasses Thrift::Serializer' do
      expect(described_class.new).to be_kind_of(::Thrift::Serializer)
    end

    it_behaves_like 'a wrapped Serializer/Deserializer'
  end

end