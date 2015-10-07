require 'spec_helper'

describe YetiThrift do

  context 'type checking' do
    let(:klass) { YetiThriftTest::StructWithEmbeddedStruct }
    let(:instance) { klass.new }
    let(:embedded) { YetiThriftTest::EmbeddedStruct.new(:text => 'foo') }

    it 'sets Thrift.type_checking to true' do
      expect(Thrift.type_checking).to eq(true)
    end

    it 'raises an exception when a struct is created with an invalid value' do
      expect do
        klass.new(:top_level => 'top', :embedded => 99)
      end.to raise_error(Thrift::TypeError)
    end

    it 'raises an exception when an invalid value is assigned' do
      expect do
        instance.embedded = { :text => 'foo' }
      end.to raise_error(Thrift::TypeError)
    end

    it 'allows a struct to be created with valid values' do
      struct = klass.new(:top_level => 'top', :embedded => embedded)
      expect(struct.embedded.text).to eq('foo')
    end

    it 'allows a valid value to be assigned' do
      instance.embedded = embedded
      expect(instance.embedded.text).to eq('foo')
    end
  end
end