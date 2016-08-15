module VSphereCloud
  class RetryHttpClient
    MAX_RETRY_COUNT = 5
    RETRY_INTERVAL_IN_SEC = 1.0
    RETRYABLE_ERRORS = [
      'An error occurred while communicating with the remote host',
      'No route to host',
      'The operation is not allowed in the current state of the host',
    ]

    def initialize(http_client, logger)
      @http_client = http_client
      @logger = logger
    end

    def get(url, additional_headers = {})
      do_request('GET', url, nil, additional_headers)
    end
    def post(url, content, additional_headers = {})
      do_request('POST', url, content, additional_headers)
    end
    def put(url, content, additional_headers = {})
      do_request('PUT', url, content, additional_headers)
    end

    private

    def do_request(request_type, url, content, additional_headers)
      case request_type
        when 'GET'
          perform_resp = lambda { @http_client.get(url, additional_headers) }
        when 'POST'
          perform_resp = lambda { @http_client.post(url, content, additional_headers) }
        when 'PUT'
          perform_resp = lambda { @http_client.put(url, content, additional_headers) }
      end

      response = nil
      MAX_RETRY_COUNT.times do
        @logger.warn("Retrying request to #{url}...") unless response.nil?

        response = perform_resp.call
        break unless is_retryable?(response)

        sleep RETRY_INTERVAL_IN_SEC
      end
      response
    end

    def is_retryable?(response)
      if response.code.between?(500,599) && response.body
        return RETRYABLE_ERRORS.any? { |error_msg| response.body.include?(error_msg) }
      end

      false
    end
  end
end
