# yeti_thrift

Yesware common thrift definitions and extensions.

## Installation

Add this line to your application's Gemfile:

    gem 'yeti_thrift'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yeti_thrift

## Usage

To regenerate ruby files from the thrift files contained in this gem,
thrift version 0.9.1 or later must be installed:

    brew install thrift

To use the shared examples, the file must be loaded in
`spec_helper.rb` in your repo:

    require 'spec/support/yeti_thrift_shared_examples'

## Extensions

### nested_assignment

Create a struct or union containing embedded structs using a hash:

```ruby
obj = StructWithEmbeddedStruct.new({
        :top_level => 'top',
        :embedded => { :text => 'inner' }
      })
obj.inspect
#=> <StructWithEmbeddedStruct top_level:"top", embedded:<EmbeddedStruct text:"inner">>
```

### to_h

Convert a struct or union to a Hash:

```ruby
struct.to_h
#=> { 'long' => 1, 'int' => 2, 'str' => 'foo', 't_or_f' => true }
```

### timestamp_field

Define virtual accessors to treat an I64 field as a timestamp.
By convention, the name of the accessor ends in "_at" and the
I64 field that stores the seconds is assumed to have the same
name with the "_at" suffix removed.

```ruby
# as an extension to the class definition
timestamp_field :event_at

# then using an instance
struct.event_at = Time.new(2012, 2, 29)
struct.event
#=> 1330491600
```

### version

A `version` field on a new instance of a `Thrift::Struct` is automatically
populated if there is a corresponding `<CLASS_NAME>_VERSION` constant.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
