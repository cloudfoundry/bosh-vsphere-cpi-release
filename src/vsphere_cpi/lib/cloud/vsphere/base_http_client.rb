require 'httpclient'

module VSphereCloud
  class BaseHttpClient

    attr_reader :backing_client

    def initialize(http_log: nil, trusted_ca_file: nil, ca_cert_manifest_key: nil, skip_ssl_verify: false)
      @backing_client = HTTPClient.new
      @backing_client.send_timeout = 14400 # 4 hours, for stemcell uploads
      @backing_client.receive_timeout = 14400
      @backing_client.connect_timeout = 60
      @ca_cert_manifest_key = ca_cert_manifest_key
      @log_filter = VSphereCloud::SdkHelpers::LogFilter.new

      if trusted_ca_file
        @backing_client.ssl_config.add_trust_ca(trusted_ca_file)
      elsif skip_ssl_verify
        @backing_client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      case http_log
        when String
          log_file = File.open(http_log, 'w')
          log_file.sync = true
          @log_writer = log_file
        when IO, StringIO
          @log_writer = http_log
        else
          @log_writer = File.open(File::NULL, 'w')
      end
    end

    def get(url, additional_headers = {})
      do_request(url, 'GET', nil, additional_headers)
    end

    def put(url, content, additional_headers = {})
      do_request(url, 'PUT', content, additional_headers)
    end

    def post(url, content, additional_headers = {})
      do_request(url, 'POST', content, additional_headers)
    end

    def delete(url, additional_headers = {})
      do_request(url, 'DELETE', nil, additional_headers)
    end

    private

    def do_request(url, method, content, additional_headers)
      @log_writer << "= Request\n\n"
      @log_writer << "#{method} #{url}\n\n"
      @log_writer << "Date: #{Time.now}\n"
      @log_writer << "Additional Request Headers:\n"
      log_headers(additional_headers)

      if content
        @log_writer << "Request Body:\n"

        if is_content_loggable?(content, additional_headers)
          @log_writer << @log_filter.filter(content) + "\n"
        else
          @log_writer << "REQUEST BODY IS BINARY DATA\n"
        end
      end

      begin
        case method
          when 'GET'
            resp = @backing_client.get(url, additional_headers)
          when 'PUT'
            resp = @backing_client.put(url, content, additional_headers)
          when 'POST'
            resp = @backing_client.post(url, content, additional_headers)
          when 'DELETE'
            resp = @backing_client.delete(url, additional_headers)
          else
            raise "Invalid HTTP method '#{method}'"
        end
      rescue OpenSSL::SSL::SSLError => e
        error_msg = "The URL #{url} does not have a valid SSL certificate."
        if @ca_cert_manifest_key
          error_msg += " You may use the manifest property '#{@ca_cert_manifest_key}' in the global CPI config to set a trusted CA CERTIFICATE, PEM-encoded."
        end
        error_msg += " Exception: #{e.message}"
        raise error_msg
      end

      log_response(resp)

      resp
    end

    def log_headers(headers)
      headers.each do |key, value|
        @log_writer << "#{key}: #{value}\n"
      end
      @log_writer << "None\n" if headers.empty?
    end

    def log_response(resp)
      @log_writer << "= Response\n\n"
      @log_writer << "Status: #{resp.code} #{resp.reason}\n"
      @log_writer << "Response Headers:\n"
      log_headers(resp.headers)

      if resp.content
        @log_writer << "Response Body:\n"

        if is_content_loggable?(resp.content, resp.headers)
          @log_writer << resp.content + "\n"
        else
          @log_writer << "RESPONSE BODY IS BINARY DATA\n"
        end
      end
    end

    def is_content_loggable?(content, headers)
      content.is_a?(String) && headers['Content-Type'] != 'application/octet-stream' && content.force_encoding('utf-8').valid_encoding?
    end
  end
end
