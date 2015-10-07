require 'spec_helper'

describe Thrift::Struct_Union, 'nested_assignment' do
  let(:instance) { klass.new }
  let(:klass) { YetiThriftTest::StructWithEmbeddedStruct }
  let(:hash) do
    {
      :top_level => 'top',
      :embedded => { :text => 'inner' }
    }
  end

  it 'allows an embedded struct to be initialized from a nested hash' do
    struct = klass.new(hash)
    expect(struct.embedded).to be_instance_of(YetiThriftTest::EmbeddedStruct)
    expect(struct.embedded.text).to eq(hash[:embedded][:text])
  end

  it 'does not modify the hash of values' do
    original_hash = hash.dup
    klass.new(hash)
    expect(original_hash).to eq(hash)
  end

  context 'unsupported features' do
    # TODO: to support this the writer methods for compound types
    #   should be overridden to use nested assignment too.
    #   This could be done by overriding self.generate_accessors
    #   for Structs and Unions.
    it 'raises an error if a hash is assigned to an embedded struct' do
      expect do
        instance.embedded = hash[:embedded]
      end.to raise_error(Thrift::TypeError)
    end

    it 'raises an error if a hash is assigned to an embedded struct '\
     'in a block passed to initialize' do
      expect do
        klass.new do |obj|
          obj.embedded = hash[:embedded]
        end
      end.to raise_error(Thrift::TypeError)
    end
  end

  context 'struct with union' do
    let(:klass) { YetiThriftTest::StructWithUnion }

    it 'allows an embedded union to be initialized from a hash' do
      # Check each member of the union
      YetiThriftTest::PersonIdentifier::FIELDS.values do |field_info|
        value = { field_info[:name] => 'my value'}
        struct = klass.new(:person_identifier => value)
        expect(struct.person_identifier.email).to eq(value[field_info[:name]])
      end
    end
  end

  context 'set of structs' do
    let(:klass) { YetiThriftTest::SetOfStructs }
    it 'allows a set of structs to be assigned from a set of hashes' do
      obj = klass.new(:structs => Set.new([:text => 'foo']))
      expect(obj.structs.to_a.first.text).to eq('foo')
    end

    it 'allows a set of structs to be assigned from an array of hashes' do
      obj = klass.new(:structs => [:text => 'foo'])
      expect(obj.structs.to_a.first.text).to eq('foo')
    end
  end

  context 'list of structs' do
    let(:klass) { YetiThriftTest::ListOfStructs }
    it 'allows an array of structs to be assigned from an array of hashes' do
      obj = klass.new(:structs => [:text => 'foo'])
      expect(obj.structs.first.text).to eq('foo')
    end
  end

  context 'map of structs' do
    let(:klass) { YetiThriftTest::MapOfStructs }
    it 'allows a map of structs to be assigned from a hash of hashes' do
      obj = klass.new(:structs => { 'one' => { :text => 'foo' } })
      expect(obj.structs.keys).to eq(['one'])
      expect(obj.structs.values.first.text).to eq('foo')
    end
  end

  context 'map of structs to structs' do
    let(:klass) { YetiThriftTest::MapOfStructsToStructs }

    it 'allows a map of structs with structs as keys to be assigned from a '\
       'hash of hashes with hashes as keys' do
      value = {
        { :text => 'key' } => { :text => 'value'}
      }
      obj = klass.new(:structs => value)
      expect(obj.structs.keys.first.text).to eq('key')
      expect(obj.structs.values.first.text).to eq('value')
    end
  end

  context 'list of lists' do
    let(:klass) { YetiThriftTest::ListOfLists }

    it 'allows nested arrays to be assigned' do
      value = [[1, 2, 3], [4, 5, 6]]
      obj = klass.new(:matrix => value)
      expect(obj.matrix).to eq(value)
    end
  end

  context 'union with a struct member' do
    let(:klass) { YetiThriftTest::UnionOfStructs }

    it 'allows a union member to be assigned' do
      value = { :num => { :int => 2 } }
      # initialize Union with a hash arg
      obj = klass.new(value)
      expect(obj.num.int).to eq(2)

      value2 = { :str => 'foo' }
      # initialize Union with name, value pair
      obj2 = klass.new('str', value2)
      expect(obj2.str.str).to eq('foo')
    end
  end

  context 'union with a list of structs' do
    let(:klass) { YetiThriftTest::UnionWithListOfStructs }

    it 'assigns each struct in the list' do
      value = [{ text: 'foo' }, { text: 'bar' }]
      obj = klass.new(structs: value)
      obj.structs.length == 2
      expect(obj.structs.map(&:text)).to eq(%w{foo bar})
    end
  end

end
