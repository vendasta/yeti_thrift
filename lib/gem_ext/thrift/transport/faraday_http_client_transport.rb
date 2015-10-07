require 'faraday'

# Faraday-based http client transport. Similar to Thrift::HTTPClientTransport,
# except it uses Faraday instead of raw Net::HTTP to allow us to inject
# Middleware so we can do things like request validation via HTTP headers.
#
# This also supports setting a HTTP proxy to peek into the requests and debug
# issues.
#
module Thrift
  class FaradayHTTPClientTransport < Thrift::HTTPClientTransport

    # Construct a new Thrift HTTPClientTransport using Faraday.
    # @param url [String] to connect to (eg http://localhost:8888/thrift)
    # @param opts [Hash] parameters for tuning
    # @option opts [Boolean] :ssl_verify Whether or not to verify SSL
    #   certificates (useful when running against a self-signed certificate
    #   server.
    # @option opts [String] :proxy_url Proxy to run HTTP requests through. For
    #   instance to use Charles: http://localhost:8888
    # @option opts [Proc] :faraday_callback Callback proc to provide
    #   customization to the Faraday middleware.
    def initialize(url, opts = {})
      super(url, opts)
      # Faraday specific options
      @ssl_verify = opts.fetch(:ssl_verify, true)
      @proxy_url = opts.fetch(:proxy_url, nil)
      @faraday_callback = opts.fetch(:faraday_callback, nil)
    end

    def flush
      response = connection.post do |req|
        req.url(@url.path)
        req.headers = @headers
        req.body = @outbuf
      end

      data = Bytes.force_binary_encoding(response.body)
      @inbuf = StringIO.new data
      @outbuf = Bytes.empty_byte_buffer
    end

    def connection
      ::Faraday.new(:url => @url,
                    :proxy => @proxy_url,
                    :ssl => {
                      :verify => @ssl_verify
                    }) do |faraday|
        if @faraday_callback
          @faraday_callback.call(faraday)
        end
        faraday.adapter(Faraday.default_adapter)
      end
    end
    private :connection

  end

end
