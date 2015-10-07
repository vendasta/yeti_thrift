require 'spec_helper'

describe YetiThriftTest::VersionedStruct do
  let(:serialize_instance) { described_class.new(:text => "some text") }

  it_behaves_like "a yeti_thrift implementation with automatic versioning"

end

class YetiThriftTest::StructWithTypedefs
  timestamp_field :time_at
end

describe YetiThriftTest::StructWithTypedefs do
  let(:instance) { described_class.new }
  let(:field) { :time }
  it_behaves_like 'a yeti_thrift Timestamp field'
end
