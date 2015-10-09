require 'spec_helper'

describe YetiThrift, '.type_name' do

  it 'returns the name corresponding to a Thrift type' do
    expect(YetiThrift.type_name(::Thrift::Types::STRUCT)).to eq('Struct')
  end

end