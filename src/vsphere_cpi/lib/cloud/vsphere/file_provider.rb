require 'cloud/vsphere/logger'

module VSphereCloud
  class FileTransferError < StandardError; end

  class FileProvider
    include Logger

    def initialize(http_client:, vcenter_host:, client:, retryer: nil)
      @client = client
      @vcenter_host = vcenter_host
      @http_client = http_client
      @retryer = retryer || Retryer.new
    end

    def fetch_file_from_datastore(datacenter_name, datastore, path, ds_accessible_hosts)
      begin
        logger.info("Trying to fetch file from Datastore through Host System")
        fetch_file_from_datastore_via_host(datacenter_name, datastore, path, ds_accessible_hosts)
      # rescue everything as fallback is absolute
      rescue => e
        logger.warn("Failed to upload file through HOST with #{e}")
        logger.info("Trying to fetch file from Datastore through Datacenter")
        fetch_file_from_datastore_via_datacenter(datacenter_name, datastore.name, path)
      end
    end

    def upload_file_to_datastore(datacenter_name, datastore, path, contents, ds_accessible_hosts)
      begin
        logger.info("Trying to upload file to Datastore through Host System")
        upload_file_to_datastore_via_host(datacenter_name, datastore, path, contents, ds_accessible_hosts)
      # rescue everything as fallback is absolute
      rescue => e
        logger.warn("Failed to upload file through HOST with #{e}")
        logger.info("Trying to upload file from Datastore through Datacenter")
        upload_file_to_datastore_via_datacenter(datacenter_name, datastore.name, path, contents)
      end
    end

    def upload_file_to_url(url, body, headers)
      logger.info("Uploading file to #{url}...")

      do_request(request_type: 'POST', url: url, body: body, headers: headers)
      logger.info('Successfully uploaded file.')
    end

    private

    def fetch_file_from_datastore_via_datacenter(datacenter_name, datastore_name, path)
      url ="https://#{@vcenter_host}/folder/#{path}?dcPath=#{CGI.escape(datacenter_name)}" +
        "&dsName=#{CGI.escape(datastore_name)}"

      logger.info("Fetching file from #{url}...")
      response = do_request(request_type: 'GET', url: url, allow_not_found: true)

      if response.nil?
        logger.info("Could not find file at #{url}.")
        nil
      else
        logger.info('Successfully downloaded file.')
        response.body
      end
    end

    def fetch_file_from_datastore_via_host(datacenter_name, datastore, path, ds_accessible_hosts)
      host = get_healthy_host(datastore, ds_accessible_hosts)
      raise FileTransferError, "No healthy host available for transfer" if host.nil?

      url = "https://#{host.name}/folder/#{path}?" +
        "dsName=#{CGI.escape(datastore.name)}"

      begin
        service_ticket = get_generic_service_ticket(url: url, method: 'httpGet')
      # Specifically, we want to rescue permission faults but our fallback to Datacenter is guaranteed so rescuing
      # every Standard Error.
      rescue => e
        logger.info("Failed to acquire service ticket because #{e.inspect}")
        raise FileTransferError, "Permission to acquire generic service ticket absent"
      end

      logger.info("Fetching file from #{url}...")
      response = do_request(
        request_type: 'GET',
        url: url,
        allow_not_found: false,
        headers:
          {
            'Cookie' => "vmware_cgi_ticket=#{service_ticket.id}"
          }
      )

      if response.nil?
        logger.info("Could not find file at #{url}.")
        nil
      else
        logger.info('Successfully downloaded file.')
        response.body
      end
    end

    def upload_file_to_datastore_via_datacenter(datacenter_name, datastore_name, path, contents)
      url = "https://#{@vcenter_host}/folder/#{path}?dcPath=#{CGI.escape(datacenter_name)}" +
        "&dsName=#{CGI.escape(datastore_name)}"
      logger.info("Uploading file to #{url}...")

      do_request(request_type: 'PUT', url: url, body: contents,
        headers: { 'Content-Type' => 'application/octet-stream' })
      logger.info('Successfully uploaded file.')
    end

    def upload_file_to_datastore_via_host(datacenter_name, datastore, path, contents, ds_accessible_hosts)
      host = get_healthy_host(datastore, ds_accessible_hosts)
      raise FileTransferError, "No healthy host available for transfer" if host.nil?

      url = "https://#{host.name}/folder/#{path}?" +
        "dsName=#{CGI.escape(datastore.name)}"

      begin
        service_ticket = get_generic_service_ticket(url: url, method: 'httpPut')
      # Specifically, we want to rescue permission faults but our fallback to Datacenter is guaranteed so rescuing
      # every Standard Error.
      rescue => e
        logger.info("Failed to acquire service ticket because #{e.inspect}")
        raise FileTransferError, "Permission to acquire generic service ticket absent"
      end

      logger.info("Uploading file to #{url}...")

      do_request(
        request_type: 'PUT',
        url: url, body: contents,
        headers:
          {
            'Content-Type' => 'application/octet-stream',
            'Cookie' => "vmware_cgi_ticket=#{service_ticket.id}"
          }
      )
      logger.info('Successfully uploaded file.')
    end

    # Returns first healthy host mob from all host mounts for
    # this datastore and the one which is part of cluster `vm_vsphere_cluster`
    #
    # @return [VimSdk::HostSystem] ESXi Host Managed Object
    def get_healthy_host(datastore_mob, ds_accessible_hosts)
      datastore_mob.host.detect do |host_mount|
        host = host_mount.key
        !host.runtime.in_maintenance_mode &&\
        host.runtime.power_state == 'poweredOn' &&\
        host.runtime.connection_state = 'connected' &&\
        ds_accessible_hosts.include?(host)
      end&.key
    end

    def get_generic_service_ticket(url:, method:)
      session_manager = @client.service_content.session_manager
      session_spec = VimSdk::Vim::SessionManager::HttpServiceRequestSpec.new
      session_spec.method = method
      session_spec.url = url

      logger.info("Acquiring generic service ticket for URL: #{url} and Method: #{method}")
      session_manager.acquire_generic_service_ticket(session_spec)
    end

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
          logger.warn(err)
          [nil, FileTransferError.new(err)]
        else
          [resp, nil]
        end
      end
      response
    end
  end
end
