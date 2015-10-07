require 'spec_helper'

describe Thrift::Struct_Union, 'to_h' do

  let(:simple_struct) do
    YetiThriftTest::SimpleStruct.new do |struct|
      struct.long = 1
      struct.int = 2
      struct.str = 'foo'
      struct.t_or_f = true
    end
  end

  describe '#to_h' do
    it 'converts the instance to a hash' do
      expect(simple_struct.to_h).to eq(
          {
              'long' => 1,
              'int' => 2,
              'str' => 'foo',
              't_or_f' => true
          }
      )
    end

    it 'supports all base Thrift types' do
      YetiThriftTest::AllBaseStruct.new.to_h
    end

    it 'does not include nil values' do
      result = YetiThriftTest::AllBaseStruct.new do |struct|
        struct.str = 'foo'
        struct.long = 99
      end.to_h

      %w{str long}.each do |key|
        expect(result.has_key?(key)).to eq(true)
      end

      %w{t_or_f data short int num}.each do |key|
        expect(result.has_key?(key)).to eq(false)
      end
    end

    context 'boolean values' do
      it 'includes false values for booleans' do
        simple_struct.t_or_f = false
        expect(simple_struct.to_h['t_or_f']).to eq(false)
      end
    end

    context 'timestamp fields' do
      let(:klass) do
        Class.new(YetiThriftTest::SimpleStruct) do
          timestamp_field :long_at
        end
      end
      let(:result) do
        klass.new do |struct|
          struct.long = 1
        end.to_h
      end

      it 'serializes timestamp fields' do
        expect(result.has_key?('long_at')).to eq(true)
        expect(result['long_at']).to eq(Time.at(1))
      end

      it 'does not serialize the i64 seconds field' do
        expect(result.has_key?('long')).to eq(false)
      end

      it 'can be used to initialize an instance' do
        new_instance = klass.new(result)
        expect(new_instance.long).to eq(1)
      end
    end

    context 'a list within a struct' do

      it 'includes the elements of the list' do
        data = %w{foo bar baz}
        result = YetiThriftTest::StructWithList.new do |struct|
          struct.data = data
        end.to_h

        expect(result['data']).to eq(data)
      end

      context 'a complex list' do
        data = [
            { 'text' => 'foo' },
            { 'text' => 'bar' }
        ]
        it 'converts the list elements to a hash' do
          result = YetiThriftTest::ListOfStructs.new(
            structs: data
          ).to_h

          expect(result['structs']).to eq(data)
        end
      end
    end

    context 'a set within a struct' do
      it 'includes the members of the set' do
        data = Set.new(%w{foo bar})
        result = YetiThriftTest::StructWithSet.new(data: data).to_h

        expect(result['data']).to eq(data)
      end

      it 'constructs one' do
        YetiThriftTest::SetOfStructs.new(
            structs: Set.new([{ text: 'foo'}, { text: 'bar'}])
        )
      end

      context 'a complex set' do
        it 'converts the set members to a hash' do
          data = Set.new(
              %w{foo bar}.map { |text| { text: text } }
          )
          result = YetiThriftTest::SetOfStructs.new(structs: data).to_h

          expect(result['structs']).to eq(Set.new(
              %w{foo bar}.map { |text| { 'text' => text } }))
        end
      end
    end

    context 'a struct within a struct' do
      it 'recursively converts structs to hashes' do
        result = YetiThriftTest::StructWithEmbeddedStruct.new({
            top_level: 'top',
            embedded: { text: 'inside' }
                                                              }).to_h

        expect(result).to eq({
            'top_level' => 'top',
            'embedded' => { 'text' => 'inside' }
        })
      end
    end

    context 'a map within a struct' do
      it 'converts the map' do
        data = { 1 => 'a', 2 => 'b' }
        result = YetiThriftTest::StructWithMap.new(data: data).to_h
        expect(result['data']).to eq(data)
      end

      context 'a map with struct values' do
        it 'converts the values in the map' do
          data = { 'a' => { :text => 'foo'}, 'b' => { :text => 'bar' } }
          result = YetiThriftTest::MapOfStructs.new(structs: data).to_h
          expect(result).to eq({
              'structs' => {
                  'a' => { 'text' => 'foo' },
                  'b' => { 'text' => 'bar' }
              }
          })
        end
      end

      context 'a map with struct keys and struct values' do
        it 'converts the keys and values in the map' do
          data = {
              { :text => 'a' } => { :text => 'foo'},
              { :text => 'b' } => { :text => 'bar' }
          }
          result = YetiThriftTest::MapOfStructsToStructs.new(structs: data).to_h
          expect(result).to eq({
            'structs' => {
              { 'text' => 'a' } => { 'text' => 'foo' },
              { 'text' => 'b' } => { 'text' => 'bar' }
            }
          })
        end
      end
    end

    context 'a union within a struct' do
      it 'serializes whichever field is set' do
        name = YetiThriftTest::StructWithUnion.new(
            person_identifier: { name: 'Max Power' }
        ).to_h
        email = YetiThriftTest::StructWithUnion.new(
            person_identifier: { email: 'homer@simpsons.com' }
        ).to_h

        expect(name['person_identifier']).to eq( \
            { 'name' => 'Max Power' }
        )
        expect(email['person_identifier']).to eq( \
            { 'email' => 'homer@simpsons.com' }
        )
      end
    end

    context 'a union with a struct member' do
      it 'serializes the struct field that is set' do
        # Note: makes use of nested assignment
        u = YetiThriftTest::UnionOfStructs.new(num: { int: 2 })
        u2 = YetiThriftTest::UnionOfStructs.new('str', { str: 'foo' })
        expect(u.to_h).to eq({ 'num' => { 'int' => 2 } })
        expect(u2.to_h).to eq({ 'str' => { 'str' => 'foo' } })
      end
    end

    context 'a union without an assigned member' do
      it 'returns an empty hash' do
        expect(YetiThriftTest::UnionOfStructs.new.to_h).to eq({})
      end
    end

    context 'a union with a boolean member' do
      it 'includes a boolean field that is false' do
        u = YetiThriftTest::TrueOrFalse.new(b: false)
        expect(u.to_h).to eq({ 'b' => false })
      end
    end

  end

end
