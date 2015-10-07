require 'spec_helper'
require 'thrift/server/thin_http_server'

describe Thrift::FaradayHTTPClientTransport do

  describe 'examples mocking out the actual network traffic' do

    let(:url) do
      'http://my.domain.com/path/to/service?param=value'
    end

    def expect_faraday_call(expected_body,
                            additional_headers = {},
                            proxy = nil,
                            ssl_verify = true)
      mock_faraday = double('Faraday')
      mock_request = double('request')
      mock_body = double('body')
      mock_response = double('response')

      expected_headers = {
        'Content-Type' => 'application/x-thrift'
      }.merge!(additional_headers)

      expect(mock_request).to receive(:url).with('/path/to/service')
      expect(mock_request).to receive(:headers=).with(expected_headers)
      expect(mock_request).to receive(:body=).with(expected_body)
      expect(mock_response).to receive(:body).and_return('data')
      expect(mock_faraday).to receive(:adapter).with(Faraday.default_adapter)
      expect(mock_faraday).to receive(:post).and_yield(mock_request).
          and_return(mock_response)
      expect(::Faraday).to receive(:new).
        with({
               :url => URI(url),
               :proxy => proxy,
               :ssl => {
                 :verify => ssl_verify
               }
             }).
        and_yield(mock_faraday).
        and_return(mock_faraday)
      # Return the mocked faraday so it can be used to mock the callback.
      mock_faraday
    end

    before(:each) do
      @client = described_class.new(url)
    end

    it 'should always be open' do
      expect(@client).to be_open
      @client.close
      expect(@client).to be_open
    end

    it 'should post via HTTP and return the results' do
      @client.write('a test')
      @client.write(' frame')

      expect_faraday_call('a test frame')

      @client.flush
      expect(@client.read(10)).to eq('data')
    end

    it 'should send custom headers if defined' do
      @client.write('test')
      custom_headers = { 'Cookie' => 'Foo' }

      @client.add_headers(custom_headers)

      expect_faraday_call('test', custom_headers, nil, true)

      @client.flush
    end

    it 'can disable verifying ssl certificates' do
      @client = described_class.new(url, ssl_verify: false)
      @client.write('ssl')
      expect_faraday_call('ssl', {}, nil, false)
      @client.flush
    end

    it 'should use a proxy when asked' do
      proxy = 'http://localhost:8888'
      @client = described_class.new(url, proxy_url: proxy)
      @client.write('proxy')
      expect_faraday_call('proxy', {}, proxy, true)
      @client.flush
    end

    it 'calls faraday callbacks to install middleware' do
      callback = double('callback')
      @client = described_class.new(url, faraday_callback: callback)
      @client.write('callback')
      faraday = expect_faraday_call('callback')
      expect(callback).to receive(:call).with(faraday)
      @client.flush
    end

  end

  context 'with a live thrift service' do

    let(:port) { 59599 }
    let(:handler) { SimpleServiceHandler.new }
    let(:processor) { YetiThriftTest::SimpleService::Processor.new(handler) }
    let(:protocol_factory) { Thrift::JsonProtocolFactory.new }

    let(:transport) do
      Thrift::HTTPClientTransport.new("http://localhost:#{port}")
    end
    let(:protocol) { Thrift::JsonProtocol.new(transport) }
    let(:client) { YetiThriftTest::SimpleService::Client.new(protocol) }

    it 'starts up a server' do
      @server = Thrift::ThinHTTPServer.
        new(processor,
            port: port,
            protocol_factory: protocol_factory)
      thread = Thread.new do
        @server.serve
      end

      sleep(0.5)
      transport.open
      ss = YetiThriftTest::SimpleStruct.new do |ss|
        ss.long = 388219
        ss.int = 21
        ss.str = 'string'
        ss.t_or_f = false
      end
      ss_mod = client.mutate(ss, 19, 'more', true)
      expect(ss_mod.long).to eq(ss.long + 19)
      expect(ss_mod.int).to eq(ss.int + 19)
      expect(ss_mod.str).to eq('stringmore')
      expect(ss_mod.t_or_f).to eq(true)

      transport.close
      thread.kill
      thread.join
    end

  end

end
