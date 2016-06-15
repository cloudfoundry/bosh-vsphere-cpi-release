module VSphereCloud
  class FileProvider
    include VSphereCloud::RetryBlock

    def initialize(http_client:, vcenter_host:)
      @vcenter_host = vcenter_host
      @http_client = http_client
    end

    def fetch_file(datacenter_name, datastore_name, path)
      retry_block do
        url ="https://#{@vcenter_host}/folder/#{path}?dcPath=#{URI.escape(datacenter_name)}" +
          "&dsName=#{URI.escape(datastore_name)}"

        response = @http_client.get(url)

        if response.code < 400
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

        response = @http_client.put(
          url,
          contents,
          { 'Content-Type' => 'application/octet-stream', 'Content-Length' => contents.length })

        unless response.code < 400
          raise "Could not upload file '#{url}', received status code '#{response.code}'"
        end
      end
    end
  end
end
