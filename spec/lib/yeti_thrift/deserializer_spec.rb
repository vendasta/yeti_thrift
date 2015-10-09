require 'spec_helper'

describe YetiThrift::Deserializer do

  describe '#initialize' do
    it 'subclasses Thrift::Deserializer' do
      expect(described_class.new).to be_kind_of(::Thrift::Deserializer)
    end

    it_behaves_like 'a wrapped Serializer/Deserializer'
  end

end