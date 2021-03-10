=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.17

=end

require 'uri'

module NSXTPolicy
  class PolicyInfraSitesApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Create or fully replace a Site under infra
    # Create or fully replace a Site under Infra. Revision is optional for creation and required for update. 
    # @param site_id 
    # @param site 
    # @param [Hash] opts the optional parameters
    # @return [Site]
    def create_or_update_infra_site(site_id, site, opts = {})
      data, _status_code, _headers = create_or_update_infra_site_with_http_info(site_id, site, opts)
      data
    end

    # Create or fully replace a Site under infra
    # Create or fully replace a Site under Infra. Revision is optional for creation and required for update. 
    # @param site_id 
    # @param site 
    # @param [Hash] opts the optional parameters
    # @return [Array<(Site, Fixnum, Hash)>] Site data, response status code and response headers
    def create_or_update_infra_site_with_http_info(site_id, site, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraSitesApi.create_or_update_infra_site ...'
      end
      # verify the required parameter 'site_id' is set
      if @api_client.config.client_side_validation && site_id.nil?
        fail ArgumentError, "Missing the required parameter 'site_id' when calling PolicyInfraSitesApi.create_or_update_infra_site"
      end
      # verify the required parameter 'site' is set
      if @api_client.config.client_side_validation && site.nil?
        fail ArgumentError, "Missing the required parameter 'site' when calling PolicyInfraSitesApi.create_or_update_infra_site"
      end
      # resource path
      local_var_path = '/global-infra/sites/{site-id}'.sub('{' + 'site-id' + '}', site_id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(site)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'Site')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraSitesApi#create_or_update_infra_site\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or fully replace a Site under infra
    # Create or fully replace a Site under Infra. Revision is optional for creation and required for update. 
    # @param site_id 
    # @param site 
    # @param [Hash] opts the optional parameters
    # @return [Site]
    def create_or_update_infra_site_0(site_id, site, opts = {})
      data, _status_code, _headers = create_or_update_infra_site_0_with_http_info(site_id, site, opts)
      data
    end

    # Create or fully replace a Site under infra
    # Create or fully replace a Site under Infra. Revision is optional for creation and required for update. 
    # @param site_id 
    # @param site 
    # @param [Hash] opts the optional parameters
    # @return [Array<(Site, Fixnum, Hash)>] Site data, response status code and response headers
    def create_or_update_infra_site_0_with_http_info(site_id, site, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraSitesApi.create_or_update_infra_site_0 ...'
      end
      # verify the required parameter 'site_id' is set
      if @api_client.config.client_side_validation && site_id.nil?
        fail ArgumentError, "Missing the required parameter 'site_id' when calling PolicyInfraSitesApi.create_or_update_infra_site_0"
      end
      # verify the required parameter 'site' is set
      if @api_client.config.client_side_validation && site.nil?
        fail ArgumentError, "Missing the required parameter 'site' when calling PolicyInfraSitesApi.create_or_update_infra_site_0"
      end
      # resource path
      local_var_path = '/infra/sites/{site-id}'.sub('{' + 'site-id' + '}', site_id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(site)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'Site')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraSitesApi#create_or_update_infra_site_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete a site
    # Delete a site under Infra. 
    # @param site_id 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :force 
    # @return [nil]
    def delete_infra_site(site_id, opts = {})
      delete_infra_site_with_http_info(site_id, opts)
      nil
    end

    # Delete a site
    # Delete a site under Infra. 
    # @param site_id 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :force 
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def delete_infra_site_with_http_info(site_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraSitesApi.delete_infra_site ...'
      end
      # verify the required parameter 'site_id' is set
      if @api_client.config.client_side_validation && site_id.nil?
        fail ArgumentError, "Missing the required parameter 'site_id' when calling PolicyInfraSitesApi.delete_infra_site"
      end
      # resource path
      local_var_path = '/global-infra/sites/{site-id}'.sub('{' + 'site-id' + '}', site_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'force'] = opts[:'force'] if !opts[:'force'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraSitesApi#delete_infra_site\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete a site
    # Delete a site under Infra. 
    # @param site_id 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :force 
    # @return [nil]
    def delete_infra_site_0(site_id, opts = {})
      delete_infra_site_0_with_http_info(site_id, opts)
      nil
    end

    # Delete a site
    # Delete a site under Infra. 
    # @param site_id 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :force 
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def delete_infra_site_0_with_http_info(site_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraSitesApi.delete_infra_site_0 ...'
      end
      # verify the required parameter 'site_id' is set
      if @api_client.config.client_side_validation && site_id.nil?
        fail ArgumentError, "Missing the required parameter 'site_id' when calling PolicyInfraSitesApi.delete_infra_site_0"
      end
      # resource path
      local_var_path = '/infra/sites/{site-id}'.sub('{' + 'site-id' + '}', site_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'force'] = opts[:'force'] if !opts[:'force'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraSitesApi#delete_infra_site_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Returns the certificate of the listener
    # Connects to the given IP and port, and, if an SSL listener is present, returns the certificate of the listener. Intent of this API is \"Do you trust this certificate?\". 
    # @param address Host name or IP address of TLS listener
    # @param port TCP port number of the TLS listener
    # @param [Hash] opts the optional parameters
    # @return [TlsListenerCertificate]
    def get_infra_site_listener_certificate(address, port, opts = {})
      data, _status_code, _headers = get_infra_site_listener_certificate_with_http_info(address, port, opts)
      data
    end

    # Returns the certificate of the listener
    # Connects to the given IP and port, and, if an SSL listener is present, returns the certificate of the listener. Intent of this API is \&quot;Do you trust this certificate?\&quot;. 
    # @param address Host name or IP address of TLS listener
    # @param port TCP port number of the TLS listener
    # @param [Hash] opts the optional parameters
    # @return [Array<(TlsListenerCertificate, Fixnum, Hash)>] TlsListenerCertificate data, response status code and response headers
    def get_infra_site_listener_certificate_with_http_info(address, port, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraSitesApi.get_infra_site_listener_certificate ...'
      end
      # verify the required parameter 'address' is set
      if @api_client.config.client_side_validation && address.nil?
        fail ArgumentError, "Missing the required parameter 'address' when calling PolicyInfraSitesApi.get_infra_site_listener_certificate"
      end
      # verify the required parameter 'port' is set
      if @api_client.config.client_side_validation && port.nil?
        fail ArgumentError, "Missing the required parameter 'port' when calling PolicyInfraSitesApi.get_infra_site_listener_certificate"
      end
      if @api_client.config.client_side_validation && port > 65535
        fail ArgumentError, 'invalid value for "port" when calling PolicyInfraSitesApi.get_infra_site_listener_certificate, must be smaller than or equal to 65535.'
      end

      if @api_client.config.client_side_validation && port < 0
        fail ArgumentError, 'invalid value for "port" when calling PolicyInfraSitesApi.get_infra_site_listener_certificate, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/global-infra/sites/listener_certificate'

      # query parameters
      query_params = {}
      query_params[:'address'] = address
      query_params[:'port'] = port

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'TlsListenerCertificate')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraSitesApi#get_infra_site_listener_certificate\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Returns the certificate of the listener
    # Connects to the given IP and port, and, if an SSL listener is present, returns the certificate of the listener. Intent of this API is \"Do you trust this certificate?\". 
    # @param address Host name or IP address of TLS listener
    # @param port TCP port number of the TLS listener
    # @param [Hash] opts the optional parameters
    # @return [TlsListenerCertificate]
    def get_infra_site_listener_certificate_0(address, port, opts = {})
      data, _status_code, _headers = get_infra_site_listener_certificate_0_with_http_info(address, port, opts)
      data
    end

    # Returns the certificate of the listener
    # Connects to the given IP and port, and, if an SSL listener is present, returns the certificate of the listener. Intent of this API is \&quot;Do you trust this certificate?\&quot;. 
    # @param address Host name or IP address of TLS listener
    # @param port TCP port number of the TLS listener
    # @param [Hash] opts the optional parameters
    # @return [Array<(TlsListenerCertificate, Fixnum, Hash)>] TlsListenerCertificate data, response status code and response headers
    def get_infra_site_listener_certificate_0_with_http_info(address, port, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraSitesApi.get_infra_site_listener_certificate_0 ...'
      end
      # verify the required parameter 'address' is set
      if @api_client.config.client_side_validation && address.nil?
        fail ArgumentError, "Missing the required parameter 'address' when calling PolicyInfraSitesApi.get_infra_site_listener_certificate_0"
      end
      # verify the required parameter 'port' is set
      if @api_client.config.client_side_validation && port.nil?
        fail ArgumentError, "Missing the required parameter 'port' when calling PolicyInfraSitesApi.get_infra_site_listener_certificate_0"
      end
      if @api_client.config.client_side_validation && port > 65535
        fail ArgumentError, 'invalid value for "port" when calling PolicyInfraSitesApi.get_infra_site_listener_certificate_0, must be smaller than or equal to 65535.'
      end

      if @api_client.config.client_side_validation && port < 0
        fail ArgumentError, 'invalid value for "port" when calling PolicyInfraSitesApi.get_infra_site_listener_certificate_0, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/infra/sites/listener_certificate'

      # query parameters
      query_params = {}
      query_params[:'address'] = address
      query_params[:'port'] = port

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'TlsListenerCertificate')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraSitesApi#get_infra_site_listener_certificate_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List Sites
    # List Sites under Infra. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results (default to false)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [SiteListResult]
    def list_sites(opts = {})
      data, _status_code, _headers = list_sites_with_http_info(opts)
      data
    end

    # List Sites
    # List Sites under Infra. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(SiteListResult, Fixnum, Hash)>] SiteListResult data, response status code and response headers
    def list_sites_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraSitesApi.list_sites ...'
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyInfraSitesApi.list_sites, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyInfraSitesApi.list_sites, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/infra/sites'

      # query parameters
      query_params = {}
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'include_mark_for_delete_objects'] = opts[:'include_mark_for_delete_objects'] if !opts[:'include_mark_for_delete_objects'].nil?
      query_params[:'included_fields'] = opts[:'included_fields'] if !opts[:'included_fields'].nil?
      query_params[:'page_size'] = opts[:'page_size'] if !opts[:'page_size'].nil?
      query_params[:'sort_ascending'] = opts[:'sort_ascending'] if !opts[:'sort_ascending'].nil?
      query_params[:'sort_by'] = opts[:'sort_by'] if !opts[:'sort_by'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'SiteListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraSitesApi#list_sites\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List Sites
    # List Sites under Infra. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results (default to false)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [SiteListResult]
    def list_sites_0(opts = {})
      data, _status_code, _headers = list_sites_0_with_http_info(opts)
      data
    end

    # List Sites
    # List Sites under Infra. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(SiteListResult, Fixnum, Hash)>] SiteListResult data, response status code and response headers
    def list_sites_0_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraSitesApi.list_sites_0 ...'
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyInfraSitesApi.list_sites_0, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyInfraSitesApi.list_sites_0, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/global-infra/sites'

      # query parameters
      query_params = {}
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'include_mark_for_delete_objects'] = opts[:'include_mark_for_delete_objects'] if !opts[:'include_mark_for_delete_objects'].nil?
      query_params[:'included_fields'] = opts[:'included_fields'] if !opts[:'included_fields'].nil?
      query_params[:'page_size'] = opts[:'page_size'] if !opts[:'page_size'].nil?
      query_params[:'sort_ascending'] = opts[:'sort_ascending'] if !opts[:'sort_ascending'].nil?
      query_params[:'sort_by'] = opts[:'sort_by'] if !opts[:'sort_by'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'SiteListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraSitesApi#list_sites_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or patch Site
    # Create or patch Site under Infra. 
    # @param site_id 
    # @param site 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def patch_infra_site(site_id, site, opts = {})
      patch_infra_site_with_http_info(site_id, site, opts)
      nil
    end

    # Create or patch Site
    # Create or patch Site under Infra. 
    # @param site_id 
    # @param site 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_infra_site_with_http_info(site_id, site, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraSitesApi.patch_infra_site ...'
      end
      # verify the required parameter 'site_id' is set
      if @api_client.config.client_side_validation && site_id.nil?
        fail ArgumentError, "Missing the required parameter 'site_id' when calling PolicyInfraSitesApi.patch_infra_site"
      end
      # verify the required parameter 'site' is set
      if @api_client.config.client_side_validation && site.nil?
        fail ArgumentError, "Missing the required parameter 'site' when calling PolicyInfraSitesApi.patch_infra_site"
      end
      # resource path
      local_var_path = '/global-infra/sites/{site-id}'.sub('{' + 'site-id' + '}', site_id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(site)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraSitesApi#patch_infra_site\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or patch Site
    # Create or patch Site under Infra. 
    # @param site_id 
    # @param site 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def patch_infra_site_0(site_id, site, opts = {})
      patch_infra_site_0_with_http_info(site_id, site, opts)
      nil
    end

    # Create or patch Site
    # Create or patch Site under Infra. 
    # @param site_id 
    # @param site 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_infra_site_0_with_http_info(site_id, site, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraSitesApi.patch_infra_site_0 ...'
      end
      # verify the required parameter 'site_id' is set
      if @api_client.config.client_side_validation && site_id.nil?
        fail ArgumentError, "Missing the required parameter 'site_id' when calling PolicyInfraSitesApi.patch_infra_site_0"
      end
      # verify the required parameter 'site' is set
      if @api_client.config.client_side_validation && site.nil?
        fail ArgumentError, "Missing the required parameter 'site' when calling PolicyInfraSitesApi.patch_infra_site_0"
      end
      # resource path
      local_var_path = '/infra/sites/{site-id}'.sub('{' + 'site-id' + '}', site_id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(site)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraSitesApi#patch_infra_site_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Read a site
    # Read a site under Infra. 
    # @param site_id 
    # @param [Hash] opts the optional parameters
    # @return [Site]
    def read_site(site_id, opts = {})
      data, _status_code, _headers = read_site_with_http_info(site_id, opts)
      data
    end

    # Read a site
    # Read a site under Infra. 
    # @param site_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(Site, Fixnum, Hash)>] Site data, response status code and response headers
    def read_site_with_http_info(site_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraSitesApi.read_site ...'
      end
      # verify the required parameter 'site_id' is set
      if @api_client.config.client_side_validation && site_id.nil?
        fail ArgumentError, "Missing the required parameter 'site_id' when calling PolicyInfraSitesApi.read_site"
      end
      # resource path
      local_var_path = '/global-infra/sites/{site-id}'.sub('{' + 'site-id' + '}', site_id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'Site')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraSitesApi#read_site\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Read a site
    # Read a site under Infra. 
    # @param site_id 
    # @param [Hash] opts the optional parameters
    # @return [Site]
    def read_site_0(site_id, opts = {})
      data, _status_code, _headers = read_site_0_with_http_info(site_id, opts)
      data
    end

    # Read a site
    # Read a site under Infra. 
    # @param site_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(Site, Fixnum, Hash)>] Site data, response status code and response headers
    def read_site_0_with_http_info(site_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraSitesApi.read_site_0 ...'
      end
      # verify the required parameter 'site_id' is set
      if @api_client.config.client_side_validation && site_id.nil?
        fail ArgumentError, "Missing the required parameter 'site_id' when calling PolicyInfraSitesApi.read_site_0"
      end
      # resource path
      local_var_path = '/infra/sites/{site-id}'.sub('{' + 'site-id' + '}', site_id.to_s)

      # query parameters
      query_params = {}

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = nil
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:GET, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'Site')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraSitesApi#read_site_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
