require 'spec_helper'
require 'active_support'

describe Thrift::Struct_Union, 'timestamp' do

  # Define a class with SimpleStruct as the parent
  # and class_eval the specified block.
  # @return [Class]
  def test_class(&block)
    Class.new(YetiThriftTest::SimpleStruct, &block)
  end

  # Expect an exception when defining a test class using
  # the specified block.
  # @return [Void]
  def expect_test_class_exception(ex, &block)
    expect do
      test_class(&block)
    end.to raise_error(ex)
  end

  let(:klass) { test_class { timestamp_field :long_at } }
  let(:instance) { klass.new }

  # @param field [Symbol] The name of the accessor.
  # @param time_class [Class] The class for the timestamp value.
  # @param seconds [Symbol] The name of the underlying i64 seconds field.
  shared_examples_for 'a class with a timestamp field' \
      do |field, time_class = Time, seconds = :long|
    let(:now) { Time.now.to_i }
    let(:time_klass) { time_class.is_a?(Proc) ? time_class.call : time_class }

    it 'adds a reader for the timestamp' do
      expect(instance.respond_to?("#{field}")).to eq(true)
      instance.send("#{seconds}=", now)
      expect(instance.send(field)).to eq(Time.at(now))
    end

    it 'adds a writer for the timestamp' do
      expect(instance.respond_to?("#{field}=")).to eq(true)
      instance.send("#{field}=", Time.at(now))
      expect(instance.send(seconds)).to eq(now)
    end

    it 'add details about the timestamp field to the klass' do
      # delayed evaluation is necessary because Time.zone may not be set
      # when the example is defined
      expect(klass.send(:timestamp_map)[seconds]).
          to eq({
                      :timestamp => field,
                      :time_class => time_klass
                    })
    end

    it 'can be initialized' do
      now = time_klass.at(time_klass.now.to_i)
      obj = klass.new(field => now)
      expect(obj.send("#{field}")).to eq(now)
    end
  end

  context 'Union' do
    # Define a class with a Union (UnionOfStructs) as the parent
    # and class_eval the specified block.
    def test_union(&block)
      Class.new(YetiThriftTest::EventUnion, &block)
    end

    let(:klass) { test_union { timestamp_field :happened_at } }

    it_behaves_like 'a class with a timestamp field',
                    :happened_at,
                    Time,
                    :happened

  end

  describe '.timestamp_field' do
    it_behaves_like 'a class with a timestamp field', :long_at

    context 'when the timestamp field is specified as a string' do
      let(:klass) { test_class { timestamp_field 'long_at'} }

      it_behaves_like 'a class with a timestamp field', :long_at
    end

    context 'when the seconds field is specified as a string' do
      let(:klass) do
        test_class { timestamp_field :event_at, :seconds_field => 'long' }
      end

      it_behaves_like 'a class with a timestamp field', :event_at
    end

    context 'when the time class is overridden' do
      let(:klass) do
        test_class do
          timestamp_field :long_at, :time_class => Time.zone
        end
      end

      around(:each) do |example|
        Time.zone = 'Eastern Time (US & Canada)'
        example.run
        Time.zone = nil
      end

      it_behaves_like 'a class with a timestamp field',
                      :long_at,
                      -> { Time.zone },
                      :long
    end

    context 'validation' do
      it 'raises an error if a name is not specified for the timestamp field' do
        expect_test_class_exception(':name must be specified for a timestamp') do
          timestamp_field
        end
      end

      it 'raises an error if the name is already a field' do
        expect_test_class_exception('\'long\' is already a field') do
          timestamp_field :long, :seconds_field => :long_seconds
        end
      end

      it 'raises an error if a reader exists with the same name' do
        expect_test_class_exception('timestamp field conflicts with #long_at and/or #long_at=') do
          def long_at; end
          timestamp_field :long_at
        end
      end

      it 'raises an error if a writer exists with the same name' do
        expect_test_class_exception('timestamp field conflicts with #long_at and/or #long_at=') do
          def long_at=; end
          timestamp_field :long_at
        end
      end

      it 'raises an error if the name and seconds field are the same' do
        expect_test_class_exception(':name and :seconds_field must be different') do
          timestamp_field :long_at, :seconds_field => :long_at
        end
      end

      it 'raises an error if the seconds field is not i64' do
        expect_test_class_exception('seconds field \'str\' does not have type I64') do
          timestamp_field :my_time, :seconds_field => :str
        end
      end

      it 'raises an error is the seconds field is missing' do
        expect_test_class_exception('seconds field \'kaboom\' not found') do
          timestamp_field :kaboom_at
        end
      end

      it 'raises an error if the seconds field cannot be guessed' do
        expect_test_class_exception(
            ':name does not match expected format: <seconds>_at') do
          timestamp_field :unexpected_format
        end
      end
    end

  end

  describe '.time_class' do
    let(:time_klass) { double('Class') }

    it 'sets and returns the time_class to be used for a struct class' do
      klass.time_class time_klass
      expect(klass.time_class).to eq(time_klass)
    end

    it 'returns the default time_class' do
      klass.instance_variable_set(:@time_class, nil)
      expect(klass.time_class).to be_present
      expect(klass.time_class).to eq(Thrift::Struct_Union::TIME_CLASS_DEFAULT)
    end
  end

  context 'timestamp accessors' do
    let(:time_value) { Time.new(2013, 2, 4, 22, 1) }
    let(:seconds_value) { time_value.to_i }
    let(:match_class) { Time }

    # @param timestamp [Symbol] The name of the accessor created.
    # @param seconds [Symbol] The name of the I64 field.
    shared_examples_for 'a timestamp accessor' do |timestamp, seconds|
      context 'timestamp writer' do
        it 'sets the underlying seconds field' do
          instance.send("#{timestamp}=", time_value)
          expect(instance.send(seconds)).to eq(seconds_value)
        end

        context 'when set to nil' do
          it 'sets the underlying seconds field to nil' do
            instance.send("#{timestamp}=", nil)
            expect(instance.send(seconds)).to be_nil
          end
        end
      end

      context 'timestamp reader' do
        it 'returns an instance of the time class' do
          instance.send("#{seconds}=", seconds_value)
          expect(instance.send(timestamp)).to eq(time_value)
          expect(instance.send(timestamp)).to be_instance_of(match_class)
        end

        context 'when the second field is nil' do
          it 'returns nil' do
            instance.send("#{seconds}=", nil)
            expect(instance.send(timestamp)).to be_nil
          end
        end
      end
    end

    it_behaves_like 'a timestamp accessor', :long_at, :long

    context 'with a non-default seconds field' do
      let(:klass) do
        test_class { timestamp_field :event_at, :seconds_field => :long }
      end

      it_behaves_like 'a timestamp accessor', :event_at, :long
    end

    context 'with Time.zone as the time class (non-default)' do
      let(:match_class) { ActiveSupport::TimeWithZone }
      let(:klass) do
        test_class { timestamp_field :long_at, :time_class => Time.zone }
      end

      around(:each) do |example|
        Time.zone = 'Eastern Time (US & Canada)'
        example.run
        Time.zone = nil
      end

      it_behaves_like 'a timestamp accessor', :long_at, :long
    end
  end
end
