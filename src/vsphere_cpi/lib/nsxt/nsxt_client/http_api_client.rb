require 'date'
require 'json'
require 'logger'
require 'tempfile'
require 'uri'
require 'http'

module NSXT
  class HttpApiClient

    # The Configuration object holding settings to be used in the API client.
    attr_accessor :config

    def initialize(config = Configuration.default)
      @config = config
    end

    def call_api(http_method, path, opts = {})
      http_method = http_method.to_sym.downcase

      request_body = build_request_body(opts[:body])

      if @config.debugging
        @config.logger.debug "HTTP request body param ~BEGIN~\n#{request_body}\n~END~\n"
      end
      response = authentication
                   .headers(default_headers)
                   .send(http_method,
                         build_request_url(path),
                         params: opts[:query_params],
                         body: request_body,
                         ssl_context: ssl_context)

      if @config.debugging
        @config.logger.debug "HTTP response body ~BEGIN~\n#{response.body}\n~END~\n"
      end
      
      unless has_good_response_code?(response.code)
        api_error = ApiError.new(JSON.parse(response.body))
        error_message = api_error.related_errors ? api_error.related_errors : api_error.error_message
        fail ApiCallError.new(:code => response.code,
                              :response_headers => response.headers,
                              :response_body => response.body,
                              :message => error_message),
             response.status
      end

      if opts[:return_type]
        data = deserialize(response.to_s, opts[:return_type])
      else
        data = nil
      end
      return data, response.code, response.headers
    end

    # Convert object (array, hash, object, etc) to JSON string.
    # @param [Object] model object to be converted into JSON string
    # @return [String] JSON string representation of the object
    def object_to_http_body(model)
      return model if model.nil? || model.is_a?(String)
      if model.is_a?(Array)
        local_body = model.map { |m| object_to_hash(m) }
      else
        local_body = object_to_hash(model)
      end
      local_body.to_json
    end

    def select_header_accept(accepts)
      #Do nothing. Hardcode application/json in a headers in call_api
    end

    def select_header_content_type(content_types)
      #Do nothing. Hardcode application/json in a headers in call_api
    end

    private

    def has_good_response_code?(code)
      code >= 200 && code < 300
    end

    # Convert object(non-array) to hash.
    # @param [Object] obj object to be converted into JSON string
    # @return [String] JSON string representation of the object
    def object_to_hash(obj)
      if obj.respond_to?(:to_hash)
        obj.to_hash
      else
        obj
      end
    end

    # Deserialize the response to the given return type.
    #
    # @param [Response] response HTTP response
    # @param [String] return_type some examples: "User", "Array[User]", "Hash[String,Integer]"
    def deserialize(response, return_type)
      body = response

      return nil if body.nil? || body.empty?

      return body if return_type == 'String'

      begin
        data = JSON.parse("[#{body}]", :symbolize_names => true)[0]
      rescue JSON::ParserError => e
        if %w(String Date DateTime).include?(return_type)
          data = body
        else
          raise e
        end
      end
      convert_to_type data, return_type
    end

    # Convert data to the given return type.
    # @param [Object] data Data to be converted
    # @param [String] return_type Return type
    # @return [Mixed] Data in a particular type
    def convert_to_type(data, return_type)
      return nil if data.nil?
      case return_type
        when 'String'
          data.to_s
        when 'Integer'
          data.to_i
        when 'Float'
          data.to_f
        when 'BOOLEAN'
          data == true
        when 'DateTime'
          # parse date time (expecting ISO 8601 format)
          DateTime.parse data
        when 'Date'
          # parse date time (expecting ISO 8601 format)
          Date.parse data
        when 'Object'
          # generic object (usually a Hash), return directly
          data
        when /\AArray<(.+)>\z/
          # e.g. Array<Pet>
          sub_type = $1
          data.map { |item| convert_to_type(item, sub_type) }
        when /\AHash\<String, (.+)\>\z/
          # e.g. Hash<String, Integer>
          sub_type = $1
          {}.tap do |hash|
            data.each { |k, v| hash[k] = convert_to_type(v, sub_type) }
          end
        else
          # models, e.g. Pet
          NSXT.const_get(return_type).new.tap do |model|
            model.build_from_hash data
          end
      end
    end

    def build_request_body(body)
      if body
        data = body.is_a?(String) ? body : body.to_json
      else
        data = nil
      end
      data
    end

    def build_request_url(path)
      # Add leading and trailing slashes to path
      path = "/#{path}".gsub(/\/+/, '/')
      URI.encode("#{@config.scheme}://#{@config.host}#{@config.base_path}#{path}")
    end

    def ssl_context
      ctx = OpenSSL::SSL::SSLContext.new
      ctx.ca_file = @config.ssl_ca_cert
      unless @config.cert_file.nil? && @config.key_file.nil?
        ctx.cert = OpenSSL::X509::Certificate.new(open(@config.cert_file).read)
        ctx.key = OpenSSL::PKey::RSA.new(open(@config.key_file).read)
      end
      if @config.verify_ssl
        ctx.verify_mode = OpenSSL::SSL::VERIFY_PEER
      end
      ctx
    end

    def json_mime?(mime)
      (mime == '*/*') || !(mime =~ /Application\/.*json(?!p)(;.*)?/i).nil?
    end

    def default_headers
      { content_type: 'application/json',
        :'X-Allow-Overwrite' => true }
    end

    def authentication
      if @config.username && @config.password
        return HTTP.basic_auth(:user => @config.username, :pass => @config.password)
      else
        #No authentication in headers
        HTTP
      end
    end
  end
end