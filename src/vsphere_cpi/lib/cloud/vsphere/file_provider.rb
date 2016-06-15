module VSphereCloud
  class FileProvider
    include VSphereCloud::RetryBlock

    def initialize(http_client:, vcenter_host:, logger:)
      @vcenter_host = vcenter_host
      @http_client = http_client
      @logger = logger
    end

    def fetch_file(datacenter_name, datastore_name, path)
      retry_block do
        url ="https://#{@vcenter_host}/folder/#{path}?dcPath=#{URI.escape(datacenter_name)}" +
          "&dsName=#{URI.escape(datastore_name)}"
        @logger.info("Fetching file from #{url}...")
        response = @http_client.get(url)

        if response.code < 400
          @logger.info("File fetched successfully.")
          response.body
        elsif response.code == 404
          nil
        else
          raise "Could not fetch file '#{url}', received status code '#{response.code}'"
        end
      end
    end

    def upload_file(datacenter_name, datastore_name, path, contents)
      retry_block do
        url = "https://#{@vcenter_host}/folder/#{path}?dcPath=#{URI.escape(datacenter_name)}" +
          "&dsName=#{URI.escape(datastore_name)}"
        @logger.info("Uploading file to #{url}...")
        response = @http_client.put(
          url,
          contents,
          { 'Content-Type' => 'application/octet-stream', 'Content-Length' => contents.length })

        if response.code < 400
          @logger.info("File uploaded successfully.")
        else
          raise "Could not upload file '#{url}', received status code '#{response.code}'"
        end
      end
    end
  end
end
