require 'spec_helper'

describe Thrift::Union, 'initialize' do
  let(:klass) { YetiThriftTest::UnionOfStructs }

  context 'when called with an empty hash' do
    # This is different to the default behavior which
    # raises an exception with (name={}, value=nil),
    # but allows (name=nil, value=nil). Go figure!
    it 'returns an empty instance' do
      instance = klass.new({})
      expect(instance.get_set_field).to be_nil
      expect(instance.get_value).to be_nil
    end
  end

  context 'when called with a symbol and a value' do
    it 'initializes the instance' do
      instance = klass.new(:num, { :int => 5 })
      expect(instance.num).to be_a(YetiThriftTest::AllBaseStruct)
      expect(instance.num.int).to eq(5)
    end
  end

  context 'when called with a string and a value' do
    # This fails in the default implementation.
    # The @setfield is expected to be a symbol but the conversion
    # is not done.
    it 'initializes the instance' do
      instance = klass.new('num', { :int => 5 })
      expect(instance.num).to be_a(YetiThriftTest::AllBaseStruct)
      expect(instance.num.int).to eq(5)
    end
  end

  context 'when name and value are nil' do
    it 'does not call assign_timestamp' do
      expect_any_instance_of(klass).not_to receive(:assign_timestamp)
      klass.new
    end

    it 'does not call convert_nested' do
      expect_any_instance_of(klass).not_to receive(:convert_nested)
      klass.new
    end
  end

end
