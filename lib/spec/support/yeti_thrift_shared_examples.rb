# Shared examples to be used by classes in other repos that use
# yeti_thrift

# @param serialize_instance [Thrift::Struct] an instance of the class being
#   tested with values to be serialized and deseriaalized.
shared_examples_for "a yeti_thrift implementation with automatic versioning" do

  describe "versioning" do
    it "sets the default version" do
      instance = described_class.new
      # Infer the class's constant, which is defined in the containing
      # module.
      containing_module = described_class.name.deconstantize.constantize
      base_class_name = described_class.name.demodulize

      expect(instance.version).to eq containing_module.
          const_get("#{base_class_name.underscore.upcase}_VERSION")
    end
  end

  # This example requires 'serialize_instance' to be defined as an
  # instance of the class, populated with data as desired.
  describe "serialization" do
    let(:serializer) { YetiThrift::Serializer.new }
    let(:deserializer) { YetiThrift::Deserializer.new }
    let(:serialize_data) { serializer.serialize(serialize_instance) }

    it "serializes and deserializes correctly" do
      deserialize_instance = described_class.new
      deserializer.deserialize(deserialize_instance, serialize_data)
      expect(deserialize_instance).to eq serialize_instance
    end

  end
end

# Shared example for automating testing of timestamp derived fields
# Inputs expected:
# @param instance [Object] The instance of the thrift object to test
# @param field [String, Symbol] The field to test
shared_examples_for 'a yeti_thrift Timestamp field' do
  let(:time_value) { Time.new(2013, 2, 4, 22, 1) }
  let(:seconds_value) { time_value.to_i }
  let(:match_class) { Time }
  let(:timestamp_field) { "#{field}_at" }

  context 'timestamp writer' do
    it 'sets the underlying seconds field' do
      instance.send("#{timestamp_field}=", time_value)
      expect(instance.send(field)).to eq seconds_value
    end

    context 'when set to nil' do
      it 'sets the underlying seconds field to nil' do
        instance.send("#{timestamp_field}=", nil)
        expect(instance.send(field)).to be_nil
      end
    end
  end

  context 'timestamp reader' do
    it 'returns an instance of the time class' do
      instance.send("#{field}=", seconds_value)
      expect(instance.send(timestamp_field)).to eq time_value
      expect(instance.send(timestamp_field)).to be_instance_of(match_class)
    end

    context 'when the second field is nil' do
      it 'returns nil' do
        instance.send("#{field}=", nil)
        expect(instance.send(timestamp_field)).to be_nil
      end
    end
  end

end
