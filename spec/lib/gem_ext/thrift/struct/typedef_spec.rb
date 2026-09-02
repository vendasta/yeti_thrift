require 'spec_helper'

describe Thrift::Struct, 'typedefs' do

  let(:struct) do
    YetiThriftTest::StructWithTypedefs.new do |struct|
      struct.version = 5
      struct.object_id = "object id"
      struct.time = 1234
    end
  end
  let(:struct_member_symbols) do
    {
      :version => { :ruby_type => Integer,
                    :thrift_type => ::Thrift::Types::I32 },
      :object_id => { :ruby_type => String,
                      :thrift_type => ::Thrift::Types::STRING },
      :time => { :ruby_type => Integer,
                 :thrift_type => ::Thrift::Types::I64 }
    }
  end

  # The Thrift types of the structs are defined through constants in
  # the class, e.g.
  #
  # VERSION_FIELD_ID = 1
  # OBJECT_ID_FIELD_ID = 2
  # TIME_FIELD_ID = 3
  #
  # FIELDS = {
  #   VERSION_FIELD_ID => {:type => ::Thrift::Types::I32, :name => 'version', :optional => true},
  #   OBJECT_ID_FIELD_ID => {:type => ::Thrift::Types::STRING, :name => 'object_id', :optional => true},
  #   TIME_FIELD_ID => {:type => ::Thrift::Types::I64, :name => 'time', :optional => true}
  # }
  #
  # The "_FIELD_ID" suffix is emitted by the compiler these fixtures are
  # generated with (0.24.0); 0.18.1 emitted the bare field name.
  #
  # The memoized FIELDS reference and the thrift_field_constant method
  # help to extract these.

  let(:struct_thrift_fields_hash) { struct.class::FIELDS }

  def thrift_field_constant(field_symbol)
    struct.class.const_get("#{field_symbol.upcase}_FIELD_ID")
  end


  it "maps to the correct base types" do
    struct_member_symbols.each do |symbol, type_hash|
      expect(struct.send(symbol)).to be_instance_of(type_hash[:ruby_type])

      expect(struct_thrift_fields_hash[thrift_field_constant(symbol)][:type]).
          to eq(type_hash[:thrift_type])
    end
  end

end