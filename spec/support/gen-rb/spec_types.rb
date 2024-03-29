#
# Autogenerated by Thrift Compiler (0.18.1)
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#

require 'thrift'
require 'yeti_common_types'


module YetiThriftTest
  class SimpleStruct; end

  class VersionedStruct; end

  class StructWithVersionField; end

  class StructWithVersionConstant; end

  class AllBaseStruct; end

  class StructWithTypedefs; end

  class EmbeddedStruct; end

  class StructWithEmbeddedStruct; end

  class StructWithMap; end

  class StructWithSet; end

  class StructWithList; end

  class PersonIdentifier < ::Thrift::Union; end

  class StructWithUnion; end

  class SetOfStructs; end

  class ListOfStructs; end

  class MapOfStructs; end

  class MapOfStructsToStructs; end

  class ListOfLists; end

  class UnionOfStructs < ::Thrift::Union; end

  class EventUnion < ::Thrift::Union; end

  class UnionWithListOfStructs < ::Thrift::Union; end

  class TrueOrFalse < ::Thrift::Union; end

  class SimpleStruct
    include ::Thrift::Struct, ::Thrift::Struct_Union
    LONG = 1
    INT = 2
    STR = 3
    T_OR_F = 4

    FIELDS = {
      LONG => {:type => ::Thrift::Types::I64, :name => 'long'},
      INT => {:type => ::Thrift::Types::I32, :name => 'int'},
      STR => {:type => ::Thrift::Types::STRING, :name => 'str'},
      T_OR_F => {:type => ::Thrift::Types::BOOL, :name => 't_or_f'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class VersionedStruct
    include ::Thrift::Struct, ::Thrift::Struct_Union
    VERSION = 1
    TEXT = 2

    FIELDS = {
      VERSION => {:type => ::Thrift::Types::I32, :name => 'version', :default => 0},
      TEXT => {:type => ::Thrift::Types::STRING, :name => 'text', :optional => true}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class StructWithVersionField
    include ::Thrift::Struct, ::Thrift::Struct_Union
    VERSION = 1
    TEXT = 2

    FIELDS = {
      VERSION => {:type => ::Thrift::Types::I32, :name => 'version', :default => 1},
      TEXT => {:type => ::Thrift::Types::STRING, :name => 'text', :optional => true}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class StructWithVersionConstant
    include ::Thrift::Struct, ::Thrift::Struct_Union
    TEXT = 1

    FIELDS = {
      TEXT => {:type => ::Thrift::Types::STRING, :name => 'text'}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class AllBaseStruct
    include ::Thrift::Struct, ::Thrift::Struct_Union
    T_OR_F = 1
    DATA = 2
    SHORT = 3
    INT = 4
    LONG = 5
    NUM = 6
    STR = 7

    FIELDS = {
      T_OR_F => {:type => ::Thrift::Types::BOOL, :name => 't_or_f', :optional => true},
      DATA => {:type => ::Thrift::Types::BYTE, :name => 'data', :optional => true},
      SHORT => {:type => ::Thrift::Types::I16, :name => 'short', :optional => true},
      INT => {:type => ::Thrift::Types::I32, :name => 'int', :optional => true},
      LONG => {:type => ::Thrift::Types::I64, :name => 'long', :optional => true},
      NUM => {:type => ::Thrift::Types::DOUBLE, :name => 'num', :optional => true},
      STR => {:type => ::Thrift::Types::STRING, :name => 'str', :optional => true}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class StructWithTypedefs
    include ::Thrift::Struct, ::Thrift::Struct_Union
    VERSION = 1
    OBJECT_ID = 2
    TIME = 3

    FIELDS = {
      VERSION => {:type => ::Thrift::Types::I32, :name => 'version', :optional => true},
      OBJECT_ID => {:type => ::Thrift::Types::STRING, :name => 'object_id', :optional => true},
      TIME => {:type => ::Thrift::Types::I64, :name => 'time', :optional => true}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class EmbeddedStruct
    include ::Thrift::Struct, ::Thrift::Struct_Union
    TEXT = 1

    FIELDS = {
      TEXT => {:type => ::Thrift::Types::STRING, :name => 'text', :optional => true}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class StructWithEmbeddedStruct
    include ::Thrift::Struct, ::Thrift::Struct_Union
    TOP_LEVEL = 1
    EMBEDDED = 2

    FIELDS = {
      TOP_LEVEL => {:type => ::Thrift::Types::STRING, :name => 'top_level', :optional => true},
      EMBEDDED => {:type => ::Thrift::Types::STRUCT, :name => 'embedded', :class => ::YetiThriftTest::EmbeddedStruct, :optional => true}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class StructWithMap
    include ::Thrift::Struct, ::Thrift::Struct_Union
    DATA = 1

    FIELDS = {
      DATA => {:type => ::Thrift::Types::MAP, :name => 'data', :key => {:type => ::Thrift::Types::I32}, :value => {:type => ::Thrift::Types::STRING}, :optional => true}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class StructWithSet
    include ::Thrift::Struct, ::Thrift::Struct_Union
    DATA = 1

    FIELDS = {
      DATA => {:type => ::Thrift::Types::SET, :name => 'data', :element => {:type => ::Thrift::Types::STRING}, :optional => true}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class StructWithList
    include ::Thrift::Struct, ::Thrift::Struct_Union
    DATA = 1

    FIELDS = {
      DATA => {:type => ::Thrift::Types::LIST, :name => 'data', :element => {:type => ::Thrift::Types::STRING}, :optional => true}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class PersonIdentifier < ::Thrift::Union
    include ::Thrift::Struct_Union
    class << self
      def email(val)
        PersonIdentifier.new(:email, val)
      end

      def name(val)
        PersonIdentifier.new(:name, val)
      end
    end

    EMAIL = 1
    NAME = 2

    FIELDS = {
      EMAIL => {:type => ::Thrift::Types::STRING, :name => 'email', :optional => true},
      NAME => {:type => ::Thrift::Types::STRING, :name => 'name', :optional => true}
    }

    def struct_fields; FIELDS; end

    def validate
      raise(StandardError, 'Union fields are not set.') if get_set_field.nil? || get_value.nil?
    end

    ::Thrift::Union.generate_accessors self
  end

  class StructWithUnion
    include ::Thrift::Struct, ::Thrift::Struct_Union
    PERSON_IDENTIFIER = 1

    FIELDS = {
      PERSON_IDENTIFIER => {:type => ::Thrift::Types::STRUCT, :name => 'person_identifier', :class => ::YetiThriftTest::PersonIdentifier}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class SetOfStructs
    include ::Thrift::Struct, ::Thrift::Struct_Union
    STRUCTS = 1

    FIELDS = {
      STRUCTS => {:type => ::Thrift::Types::SET, :name => 'structs', :element => {:type => ::Thrift::Types::STRUCT, :class => ::YetiThriftTest::EmbeddedStruct}}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class ListOfStructs
    include ::Thrift::Struct, ::Thrift::Struct_Union
    STRUCTS = 1

    FIELDS = {
      STRUCTS => {:type => ::Thrift::Types::LIST, :name => 'structs', :element => {:type => ::Thrift::Types::STRUCT, :class => ::YetiThriftTest::EmbeddedStruct}}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class MapOfStructs
    include ::Thrift::Struct, ::Thrift::Struct_Union
    STRUCTS = 1

    FIELDS = {
      STRUCTS => {:type => ::Thrift::Types::MAP, :name => 'structs', :key => {:type => ::Thrift::Types::STRING}, :value => {:type => ::Thrift::Types::STRUCT, :class => ::YetiThriftTest::EmbeddedStruct}}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class MapOfStructsToStructs
    include ::Thrift::Struct, ::Thrift::Struct_Union
    STRUCTS = 1

    FIELDS = {
      STRUCTS => {:type => ::Thrift::Types::MAP, :name => 'structs', :key => {:type => ::Thrift::Types::STRUCT, :class => ::YetiThriftTest::EmbeddedStruct}, :value => {:type => ::Thrift::Types::STRUCT, :class => ::YetiThriftTest::EmbeddedStruct}}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class ListOfLists
    include ::Thrift::Struct, ::Thrift::Struct_Union
    MATRIX = 1

    FIELDS = {
      MATRIX => {:type => ::Thrift::Types::LIST, :name => 'matrix', :element => {:type => ::Thrift::Types::LIST, :element => {:type => ::Thrift::Types::I32}}}
    }

    def struct_fields; FIELDS; end

    def validate
    end

    ::Thrift::Struct.generate_accessors self
  end

  class UnionOfStructs < ::Thrift::Union
    include ::Thrift::Struct_Union
    class << self
      def num(val)
        UnionOfStructs.new(:num, val)
      end

      def str(val)
        UnionOfStructs.new(:str, val)
      end
    end

    NUM = 1
    STR = 2

    FIELDS = {
      NUM => {:type => ::Thrift::Types::STRUCT, :name => 'num', :class => ::YetiThriftTest::AllBaseStruct, :optional => true},
      STR => {:type => ::Thrift::Types::STRUCT, :name => 'str', :class => ::YetiThriftTest::AllBaseStruct, :optional => true}
    }

    def struct_fields; FIELDS; end

    def validate
      raise(StandardError, 'Union fields are not set.') if get_set_field.nil? || get_value.nil?
    end

    ::Thrift::Union.generate_accessors self
  end

  class EventUnion < ::Thrift::Union
    include ::Thrift::Struct_Union
    class << self
      def event_type(val)
        EventUnion.new(:event_type, val)
      end

      def happened(val)
        EventUnion.new(:happened, val)
      end
    end

    EVENT_TYPE = 1
    HAPPENED = 2

    FIELDS = {
      EVENT_TYPE => {:type => ::Thrift::Types::STRING, :name => 'event_type', :optional => true},
      HAPPENED => {:type => ::Thrift::Types::I64, :name => 'happened', :optional => true}
    }

    def struct_fields; FIELDS; end

    def validate
      raise(StandardError, 'Union fields are not set.') if get_set_field.nil? || get_value.nil?
    end

    ::Thrift::Union.generate_accessors self
  end

  class UnionWithListOfStructs < ::Thrift::Union
    include ::Thrift::Struct_Union
    class << self
      def structs(val)
        UnionWithListOfStructs.new(:structs, val)
      end

      def other(val)
        UnionWithListOfStructs.new(:other, val)
      end
    end

    STRUCTS = 1
    OTHER = 2

    FIELDS = {
      STRUCTS => {:type => ::Thrift::Types::LIST, :name => 'structs', :element => {:type => ::Thrift::Types::STRUCT, :class => ::YetiThriftTest::EmbeddedStruct}, :optional => true},
      OTHER => {:type => ::Thrift::Types::STRING, :name => 'other', :optional => true}
    }

    def struct_fields; FIELDS; end

    def validate
      raise(StandardError, 'Union fields are not set.') if get_set_field.nil? || get_value.nil?
    end

    ::Thrift::Union.generate_accessors self
  end

  class TrueOrFalse < ::Thrift::Union
    include ::Thrift::Struct_Union
    class << self
      def t_or_f(val)
        TrueOrFalse.new(:t_or_f, val)
      end

      def b(val)
        TrueOrFalse.new(:b, val)
      end

      def one_or_zero(val)
        TrueOrFalse.new(:one_or_zero, val)
      end
    end

    T_OR_F = 1
    B = 2
    ONE_OR_ZERO = 3

    FIELDS = {
      T_OR_F => {:type => ::Thrift::Types::STRING, :name => 't_or_f', :optional => true},
      B => {:type => ::Thrift::Types::BOOL, :name => 'b', :optional => true},
      ONE_OR_ZERO => {:type => ::Thrift::Types::I16, :name => 'one_or_zero', :optional => true}
    }

    def struct_fields; FIELDS; end

    def validate
      raise(StandardError, 'Union fields are not set.') if get_set_field.nil? || get_value.nil?
    end

    ::Thrift::Union.generate_accessors self
  end

end
