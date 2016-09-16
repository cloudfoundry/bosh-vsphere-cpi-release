module VSphereCloud
  class FileProvider

    def initialize(http_client:, vcenter_host:, logger:, retryer: nil)
      @vcenter_host = vcenter_host
      @http_client = http_client
      @logger = logger
      @retryer = retryer || Retryer.new
    end

    def fetch_file_from_datastore(datacenter_name, datastore_name, path)
      url ="https://#{@vcenter_host}/folder/#{path}?dcPath=#{URI.escape(datacenter_name)}" +
        "&dsName=#{URI.escape(datastore_name)}"

      @logger.info("Fetching file from #{url}...")
      response = do_request(request_type: 'GET', url: url, allow_not_found: true)

      if response.nil?
        @logger.info("Could not find file at #{url}.")
        nil
      else
        @logger.info('Successfully downloaded file.')
        response.body
      end
    end

    def upload_file_to_datastore(datacenter_name, datastore_name, path, contents)
      url = "https://#{@vcenter_host}/folder/#{path}?dcPath=#{URI.escape(datacenter_name)}" +
        "&dsName=#{URI.escape(datastore_name)}"
      @logger.info("Uploading file to #{url}...")

      do_request(request_type: 'PUT', url: url, body: contents,
        headers: { 'Content-Type' => 'application/octet-stream' })
      @logger.info('Successfully uploaded file.')
    end

    def upload_file_to_url(url, body, headers)
      @logger.info("Uploading file to #{url}...")

      do_request(request_type: 'POST', url: url, body: body, headers: headers)
      @logger.info('Successfully uploaded file.')
    end

    private

    def do_request(request_type:, url:, body: nil, headers: {}, allow_not_found: false)
      base_headers = {}
      unless body.nil?
        if body.is_a?(File)
          content_length = body.size
        elsif body.respond_to?(:bytesize)
          content_length = body.bytesize
        else
          content_length = body.length
        end
        base_headers = { 'Content-Length' => content_length }
      end
      req_headers = base_headers.merge(headers)

      case request_type
      when 'GET'
        make_request = lambda { @http_client.get(url, req_headers) }
      when 'POST'
        make_request = lambda { @http_client.post(url, body, req_headers) }
      when 'PUT'
        make_request = lambda { @http_client.put(url, body, req_headers) }
      else
        raise "Invalid request type: #{request_type}."
      end

      response = @retryer.try do
        resp = make_request.call

        if resp.code == 404 && allow_not_found
          [nil, nil]
        elsif resp.code >= 400
          err = "Could not transfer file '#{url}', received status code '#{resp.code}'"
          @logger.warn(err)
          [nil, err]
        else
          [resp, nil]
        end
      end

      response
    end
  end
end
