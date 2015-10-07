include "yeti_common.thrift"

namespace rb YetiThriftTest

struct SimpleStruct {
  1: i64 long,
  2: i32 int,
  3: string str,
  4: bool t_or_f
}

/**
 * Simple service to demonstrate our customizations on client/server code.
 */
service SimpleService {
  SimpleStruct mutate(1:SimpleStruct input,
                      2:i32 add,
                      3:string concat,
                      4:bool toggle)
}

const yeti_common.StructVersion VERSIONED_STRUCT_VERSION = 5;

struct VersionedStruct {
  1: yeti_common.StructVersion version = 0,
  2: optional string text
}

/* This struct has a version field but no corresponding
   version constant defined. */
struct StructWithVersionField {
  1: yeti_common.StructVersion version = 1
  2: optional string text
}

/* This struct has a corresponding version constant
   but no version field */
const yeti_common.StructVersion STRUCT_WITH_VERSION_CONSTANT = 1;
struct StructWithVersionConstant {
  1: string text
}

/* This struct contains all Thrift base types */
struct AllBaseStruct {
  1: optional bool t_or_f,
  2: optional byte data,
  3: optional i16 short,
  4: optional i32 int,
  5: optional i64 long,
  6: optional double num,
  7: optional string str
}

/* Struct with typedefs from yeti_common.thrift */
struct StructWithTypedefs {
  1: optional yeti_common.StructVersion version
  2: optional yeti_common.BSONObjectId object_id
  3: optional yeti_common.Timestamp time
}

struct EmbeddedStruct {
  1: optional string text
}

struct StructWithEmbeddedStruct {
  1: optional string top_level,
  2: optional EmbeddedStruct embedded
}

struct StructWithMap {
  1: optional map<i32, string> data
}

struct StructWithSet {
  1: optional set<string> data
}

struct StructWithList {
  1: optional list<string> data
}

union PersonIdentifier {
  1: string email,
  2: string name
}

struct StructWithUnion {
  1: PersonIdentifier person_identifier
}

struct SetOfStructs {
  1: set<EmbeddedStruct> structs
}

struct ListOfStructs {
  1: list<EmbeddedStruct> structs
}

struct MapOfStructs {
  1: map<string, EmbeddedStruct> structs
}

struct MapOfStructsToStructs {
  1: map<EmbeddedStruct, EmbeddedStruct> structs
}

struct ListOfLists {
  1: list<list<i32>> matrix
}

union UnionOfStructs {
  1: AllBaseStruct num
  2: AllBaseStruct str
}

union EventUnion {
  1: string event_type
  2: yeti_common.Timestamp happened
}

union UnionWithListOfStructs {
  1: list<EmbeddedStruct> structs
  2: string other
}

union TrueOrFalse {
  1: string t_or_f
  2: bool b
  3: i16 one_or_zero
}
