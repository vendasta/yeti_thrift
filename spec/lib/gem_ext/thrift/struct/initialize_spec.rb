require 'spec_helper'

describe Thrift::Struct, 'initialize' do
  let(:klass) { YetiThriftTest::SimpleStruct }

  it 'calls #versioned? on the class' do
    expect(klass).to receive(:versioned?)
    klass.new
  end

  it 'does not call assign_nested! if no values are specified' do
    expect_any_instance_of(klass).not_to receive(:assign_nested!)
    klass.new
  end

  it 'calls assign_nested! if values are specified' do
    values = { :int => 1, :str => 'a' }
    expect_any_instance_of(klass).to receive(:assign_nested!).with(values)
    klass.new(values)
  end

  it 'passes along the values and block to the default initialize' do
    values = { :int => 1, :str => 'a' }
    expect_any_instance_of(klass).to receive(:default_initialize).
        with(values).and_call_original

    obj = klass.new(values) do |object|
      object.long = 2
    end
    expect(obj.int).to eq(values[:int])
    expect(obj.str).to eq(values[:str])
    expect(obj.long).to eq(2)
  end

  context 'for a versioned struct' do
    let(:klass) { YetiThriftTest::VersionedStruct }

    it 'adds the version to the value before calling the default initialize' do
      expect_any_instance_of(klass).to receive(:default_initialize) do |obj, hash|
        expect(hash['version']).to eq(klass.struct_version)
      end
      klass.new
    end
  end
end
