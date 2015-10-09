require 'spec_helper'

describe Thrift::Struct, 'struct_version' do
  let(:instance) { klass.new }

  describe '#initialize' do
    context 'for a class with a version field and corresponding version constant' do
      let(:klass) { YetiThriftTest::VersionedStruct }
      let(:version_constant) { YetiThriftTest::VERSIONED_STRUCT_VERSION }

      it 'sets the version field to the constant for the class' do
        expect(instance.version).to eq(version_constant)
      end

      it 'removes the setter for the version field' do
        expect do
          instance.version = 2
        end.to raise_error(::YetiThrift::AutomaticStructVersion,
                   'version field cannot be set on YetiThriftTest::VersionedStruct')
      end

      context 'implementation' do
        it 'does not create a singleton class for the instance' do
          # Previous implementation defined :version= in the singleton
          # class for each instance
          expect(instance.singleton_methods).to be_empty
        end

        it 'overrides version= on the class only once' do
          klass.instance_variable_set(:@version_initialized, nil)
          expect(klass).to receive(:define_method).with(:version=).once
          2.times { klass.new }
        end
      end

      context 'serialization/deserialization' do
        let(:serializer) { YetiThrift::Serializer.new }
        let(:deserializer) { YetiThrift::Deserializer.new }

        before(:each) do
          expect(version_constant).not_to eq(1)
          expect(instance.version).to eq(version_constant)
          instance.instance_variable_set(:@version, 1)
          serialized = serializer.serialize(instance)
          @deserialized = klass.new
          deserializer.deserialize(@deserialized, serialized)
        end

        it 'does not override the version of a deserialized object' do
          expect(@deserialized.version).to eq(1)
        end

        it 'removes the version field setter of the deserialized object' do
          expect do
            @deserialized.version = 3
          end.to raise_error(::YetiThrift::AutomaticStructVersion)
        end
      end
    end

    context 'for a class without a version field' do
      let(:klass) { YetiThriftTest::SimpleStruct }

      it 'does not set a version field' do
        expect(instance.respond_to?(:version)).to eq(false)
        expect(instance.instance_variable_get(:@version)).to be_nil
      end
    end

    context 'for a class with a version field and no version constant' do
      let(:klass) { YetiThriftTest::StructWithVersionField }

      it 'does not set the version field' do
        expect(instance.version).to eq(1)
      end

      it 'does not remove the version field setter' do
        instance.version == 2
      end
    end

    context 'for a class with a version constant and no version field' do
      let(:klass) { YetiThriftTest::StructWithVersionConstant }

      it 'does not set a version field' do
        expect(YetiThriftTest).not_to receive(:const_get).
            with('STRUCT_WITH_VERSION_CONSTANT')
        expect(instance.respond_to?(:version)).to eq(false)
        expect(instance.instance_variable_get(:@version)).to be_nil
      end
    end
  end

end

describe Thrift::Struct::ClassMethods do

  describe '.versioned?' do

    context 'for a class with a version field and corresponding version constant' do
      let(:klass) { YetiThriftTest::VersionedStruct }

      it 'returns true' do
        expect(klass.versioned?).to eq(true)
      end
    end

    context 'for a class without a version field' do
      let(:klass) { YetiThriftTest::SimpleStruct }

      it 'returns false' do
        expect(klass.versioned?).to eq(false)
      end
    end

    context 'for a class with a version field and no version constant' do
      let(:klass) { YetiThriftTest::StructWithVersionField }

      it 'returns false' do
        expect(klass.versioned?).to eq(false)
      end
    end

  end

  describe '.struct_version' do

    context 'for a class with a version field and corresponding version constant' do
      let(:klass) { YetiThriftTest::VersionedStruct }
      let(:version_constant) { YetiThriftTest::VERSIONED_STRUCT_VERSION }

      it 'returns the value of the version constant' do
        expect(klass.struct_version).to eq(version_constant)
      end
    end

    context 'for a class without a version field' do
      let(:klass) { YetiThriftTest::SimpleStruct }

      it 'returns zero' do
        expect(klass.struct_version).to eq(0)
      end
    end

    context 'for a class with a version field and no version constant' do
      let(:klass) { YetiThriftTest::StructWithVersionField }

      it 'returns zero' do
        expect(klass.struct_version).to eq(0)
      end
    end

  end

end