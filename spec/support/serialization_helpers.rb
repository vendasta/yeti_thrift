shared_examples_for 'a wrapped Serializer/Deserializer' do

  it 'uses the CompactProtocol by default' do
    expect(::Thrift::CompactProtocolFactory).to receive(:new).and_call_original
    protocol = described_class.new.instance_variable_get(:@protocol)
    expect(protocol).to be_instance_of(::Thrift::CompactProtocol)
  end

  it 'allows the protocol to be overridden' do
    instance = described_class.new(::Thrift::BinaryProtocolFactory.new)
    protocol = instance.instance_variable_get(:@protocol)
    expect(protocol).to be_instance_of(::Thrift::BinaryProtocol)
  end

end