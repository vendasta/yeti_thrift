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

# Shared example for ensuring required fields are actually required
# Expects to be called with arguments:
# @param :klass [Class] The class of the Thrift struct to test
# @param :required_fields [Array<String,Symbol>] List of required fields to verify
# And expects these variables to be defined:
# @param :object_attrs [Hash] Attributes necessary to initialize a :klass
shared_examples_for 'a yeti_thrift implementation with required fields' do |klass, required_fields|
  describe klass.to_s do
    required_fields.each do |field|
      context "when #{field} is missing" do
        let(:filtered_attrs) do
          object_attrs.symbolize_keys.tap { |h| h.delete(field.to_sym) }
        end
        let(:instance) { klass.new(filtered_attrs) }

        it "requires #{field}" do
          expect do
            instance.validate
          end.to raise_error(Thrift::ProtocolException, "Required field #{field} is unset!")
        end
      end
    end
  end
end

# Test the helpful initializer methods Thrift generates. Useful for maintaining 100% test
#   coverage. Expects these variables to be defined:
# @param initializer [String] initialization method name
# @param val [Object] The value for the initializer to set
shared_examples_for 'a yeti_thrift union initializer' do
  it 'allows initialization of the union with the right type' do
    described_class.send(initializer, val).validate
  end
end
