require "yeti_thrift/version"
require "yeti_common_constants"
require "gem_ext/thrift/struct_union"
require "gem_ext/thrift/struct"
require "gem_ext/thrift/union"
require "gem_ext/thrift/transport"
require "yeti_thrift/deserializer"
require "yeti_thrift/serializer"
require "yeti_thrift/base64_deserializer"
require "yeti_thrift/base64_serializer"
require 'yeti_thrift/rake/thrift_gen_task'
require 'active_support'
require 'active_support/core_ext/object'

# Check field types when assigning to structs
Thrift.type_checking = true

module YetiThrift
  # The root path for YetiThrift source libraries
  ROOT = File.expand_path(File.dirname(__FILE__))

  # The root path of Thrift files in yeti_thrift
  THRIFT_ROOT = File.join(ROOT, '..', 'thrift')
end
