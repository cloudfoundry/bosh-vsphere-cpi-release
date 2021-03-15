=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'uri'

module NSXTPolicy
  class SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Update an existing LDAP identity source
    # Update the configuration of an existing LDAP identity source. You may wish to verify the new configuration using the POST /aaa/ldap-identity-sources?action=probe API before changing the configuration.
    # @param ldap_identity_source_id 
    # @param ldap_identity_source 
    # @param [Hash] opts the optional parameters
    # @return [LdapIdentitySource]
    def create_or_update_ldap_identity_source(ldap_identity_source_id, ldap_identity_source, opts = {})
      data, _status_code, _headers = create_or_update_ldap_identity_source_with_http_info(ldap_identity_source_id, ldap_identity_source, opts)
      data
    end

    # Update an existing LDAP identity source
    # Update the configuration of an existing LDAP identity source. You may wish to verify the new configuration using the POST /aaa/ldap-identity-sources?action&#x3D;probe API before changing the configuration.
    # @param ldap_identity_source_id 
    # @param ldap_identity_source 
    # @param [Hash] opts the optional parameters
    # @return [Array<(LdapIdentitySource, Fixnum, Hash)>] LdapIdentitySource data, response status code and response headers
    def create_or_update_ldap_identity_source_with_http_info(ldap_identity_source_id, ldap_identity_source, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.create_or_update_ldap_identity_source ...'
      end
      # verify the required parameter 'ldap_identity_source_id' is set
      if @api_client.config.client_side_validation && ldap_identity_source_id.nil?
        fail ArgumentError, "Missing the required parameter 'ldap_identity_source_id' when calling SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.create_or_update_ldap_identity_source"
      end
      # verify the required parameter 'ldap_identity_source' is set
      if @api_client.config.client_side_validation && ldap_identity_source.nil?
        fail ArgumentError, "Missing the required parameter 'ldap_identity_source' when calling SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.create_or_update_ldap_identity_source"
      end
      # resource path
      local_var_path = '/aaa/ldap-identity-sources/{ldap-identity-source-id}'.sub('{' + 'ldap-identity-source-id' + '}', ldap_identity_source_id.to_s)

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
      post_body = @api_client.object_to_http_body(ldap_identity_source)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'LdapIdentitySource')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi#create_or_update_ldap_identity_source\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete an LDAP identity source
    # Delete an LDAP identity source. Users defined in that source will no longer be able to access NSX.
    # @param ldap_identity_source_id 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def delete_ldap_identity_source(ldap_identity_source_id, opts = {})
      delete_ldap_identity_source_with_http_info(ldap_identity_source_id, opts)
      nil
    end

    # Delete an LDAP identity source
    # Delete an LDAP identity source. Users defined in that source will no longer be able to access NSX.
    # @param ldap_identity_source_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def delete_ldap_identity_source_with_http_info(ldap_identity_source_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.delete_ldap_identity_source ...'
      end
      # verify the required parameter 'ldap_identity_source_id' is set
      if @api_client.config.client_side_validation && ldap_identity_source_id.nil?
        fail ArgumentError, "Missing the required parameter 'ldap_identity_source_id' when calling SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.delete_ldap_identity_source"
      end
      # resource path
      local_var_path = '/aaa/ldap-identity-sources/{ldap-identity-source-id}'.sub('{' + 'ldap-identity-source-id' + '}', ldap_identity_source_id.to_s)

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
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi#delete_ldap_identity_source\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Fetch the server certificate of an LDAP server
    # Attempt to connect to an LDAP server and retrieve the server certificate it presents.
    # @param identity_source_ldap_server_endpoint 
    # @param [Hash] opts the optional parameters
    # @return [PeerCertificateChain]
    def fetch_identity_source_ldap_server_certificate_fetch_certificate(identity_source_ldap_server_endpoint, opts = {})
      data, _status_code, _headers = fetch_identity_source_ldap_server_certificate_fetch_certificate_with_http_info(identity_source_ldap_server_endpoint, opts)
      data
    end

    # Fetch the server certificate of an LDAP server
    # Attempt to connect to an LDAP server and retrieve the server certificate it presents.
    # @param identity_source_ldap_server_endpoint 
    # @param [Hash] opts the optional parameters
    # @return [Array<(PeerCertificateChain, Fixnum, Hash)>] PeerCertificateChain data, response status code and response headers
    def fetch_identity_source_ldap_server_certificate_fetch_certificate_with_http_info(identity_source_ldap_server_endpoint, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.fetch_identity_source_ldap_server_certificate_fetch_certificate ...'
      end
      # verify the required parameter 'identity_source_ldap_server_endpoint' is set
      if @api_client.config.client_side_validation && identity_source_ldap_server_endpoint.nil?
        fail ArgumentError, "Missing the required parameter 'identity_source_ldap_server_endpoint' when calling SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.fetch_identity_source_ldap_server_certificate_fetch_certificate"
      end
      # resource path
      local_var_path = '/aaa/ldap-identity-sources?action=fetch_certificate'

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
      post_body = @api_client.object_to_http_body(identity_source_ldap_server_endpoint)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'PeerCertificateChain')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi#fetch_identity_source_ldap_server_certificate_fetch_certificate\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List LDAP identity sources
    # Return a list of all configured LDAP identity sources.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [LdapIdentitySourceListResult]
    def list_ldap_identity_sources(opts = {})
      data, _status_code, _headers = list_ldap_identity_sources_with_http_info(opts)
      data
    end

    # List LDAP identity sources
    # Return a list of all configured LDAP identity sources.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(LdapIdentitySourceListResult, Fixnum, Hash)>] LdapIdentitySourceListResult data, response status code and response headers
    def list_ldap_identity_sources_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.list_ldap_identity_sources ...'
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.list_ldap_identity_sources, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.list_ldap_identity_sources, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/aaa/ldap-identity-sources'

      # query parameters
      query_params = {}
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
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
        :return_type => 'LdapIdentitySourceListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi#list_ldap_identity_sources\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Test the configuration of an existing LDAP identity source
    # Attempt to connect to an existing LDAP identity source and report any errors encountered.
    # @param ldap_identity_source_id 
    # @param [Hash] opts the optional parameters
    # @return [LdapIdentitySourceProbeResults]
    def probe_configured_ldap_identity_source_probe(ldap_identity_source_id, opts = {})
      data, _status_code, _headers = probe_configured_ldap_identity_source_probe_with_http_info(ldap_identity_source_id, opts)
      data
    end

    # Test the configuration of an existing LDAP identity source
    # Attempt to connect to an existing LDAP identity source and report any errors encountered.
    # @param ldap_identity_source_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(LdapIdentitySourceProbeResults, Fixnum, Hash)>] LdapIdentitySourceProbeResults data, response status code and response headers
    def probe_configured_ldap_identity_source_probe_with_http_info(ldap_identity_source_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.probe_configured_ldap_identity_source_probe ...'
      end
      # verify the required parameter 'ldap_identity_source_id' is set
      if @api_client.config.client_side_validation && ldap_identity_source_id.nil?
        fail ArgumentError, "Missing the required parameter 'ldap_identity_source_id' when calling SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.probe_configured_ldap_identity_source_probe"
      end
      # resource path
      local_var_path = '/aaa/ldap-identity-sources/{ldap-identity-source-id}?action=probe'.sub('{' + 'ldap-identity-source-id' + '}', ldap_identity_source_id.to_s)

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
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'LdapIdentitySourceProbeResults')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi#probe_configured_ldap_identity_source_probe\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Test an LDAP server
    # Attempt to connect to an LDAP server and ensure that the server can be contacted using the given URL and authentication credentials.
    # @param identity_source_ldap_server 
    # @param [Hash] opts the optional parameters
    # @return [IdentitySourceLdapServerProbeResult]
    def probe_identity_source_ldap_server_probe_ldap_server(identity_source_ldap_server, opts = {})
      data, _status_code, _headers = probe_identity_source_ldap_server_probe_ldap_server_with_http_info(identity_source_ldap_server, opts)
      data
    end

    # Test an LDAP server
    # Attempt to connect to an LDAP server and ensure that the server can be contacted using the given URL and authentication credentials.
    # @param identity_source_ldap_server 
    # @param [Hash] opts the optional parameters
    # @return [Array<(IdentitySourceLdapServerProbeResult, Fixnum, Hash)>] IdentitySourceLdapServerProbeResult data, response status code and response headers
    def probe_identity_source_ldap_server_probe_ldap_server_with_http_info(identity_source_ldap_server, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.probe_identity_source_ldap_server_probe_ldap_server ...'
      end
      # verify the required parameter 'identity_source_ldap_server' is set
      if @api_client.config.client_side_validation && identity_source_ldap_server.nil?
        fail ArgumentError, "Missing the required parameter 'identity_source_ldap_server' when calling SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.probe_identity_source_ldap_server_probe_ldap_server"
      end
      # resource path
      local_var_path = '/aaa/ldap-identity-sources?action=probe_ldap_server'

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
      post_body = @api_client.object_to_http_body(identity_source_ldap_server)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'IdentitySourceLdapServerProbeResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi#probe_identity_source_ldap_server_probe_ldap_server\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Probe an LDAP identity source
    # Verify that the configuration of an LDAP identity source is correct before actually creating the source.
    # @param ldap_identity_source 
    # @param [Hash] opts the optional parameters
    # @return [LdapIdentitySourceProbeResults]
    def probe_unconfigured_ldap_identity_source_probe_identity_source(ldap_identity_source, opts = {})
      data, _status_code, _headers = probe_unconfigured_ldap_identity_source_probe_identity_source_with_http_info(ldap_identity_source, opts)
      data
    end

    # Probe an LDAP identity source
    # Verify that the configuration of an LDAP identity source is correct before actually creating the source.
    # @param ldap_identity_source 
    # @param [Hash] opts the optional parameters
    # @return [Array<(LdapIdentitySourceProbeResults, Fixnum, Hash)>] LdapIdentitySourceProbeResults data, response status code and response headers
    def probe_unconfigured_ldap_identity_source_probe_identity_source_with_http_info(ldap_identity_source, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.probe_unconfigured_ldap_identity_source_probe_identity_source ...'
      end
      # verify the required parameter 'ldap_identity_source' is set
      if @api_client.config.client_side_validation && ldap_identity_source.nil?
        fail ArgumentError, "Missing the required parameter 'ldap_identity_source' when calling SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.probe_unconfigured_ldap_identity_source_probe_identity_source"
      end
      # resource path
      local_var_path = '/aaa/ldap-identity-sources?action=probe_identity_source'

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
      post_body = @api_client.object_to_http_body(ldap_identity_source)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'LdapIdentitySourceProbeResults')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi#probe_unconfigured_ldap_identity_source_probe_identity_source\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Read a single LDAP identity source
    # Return details about one LDAP identity source
    # @param ldap_identity_source_id 
    # @param [Hash] opts the optional parameters
    # @return [LdapIdentitySource]
    def read_ldap_identity_source(ldap_identity_source_id, opts = {})
      data, _status_code, _headers = read_ldap_identity_source_with_http_info(ldap_identity_source_id, opts)
      data
    end

    # Read a single LDAP identity source
    # Return details about one LDAP identity source
    # @param ldap_identity_source_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(LdapIdentitySource, Fixnum, Hash)>] LdapIdentitySource data, response status code and response headers
    def read_ldap_identity_source_with_http_info(ldap_identity_source_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.read_ldap_identity_source ...'
      end
      # verify the required parameter 'ldap_identity_source_id' is set
      if @api_client.config.client_side_validation && ldap_identity_source_id.nil?
        fail ArgumentError, "Missing the required parameter 'ldap_identity_source_id' when calling SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.read_ldap_identity_source"
      end
      # resource path
      local_var_path = '/aaa/ldap-identity-sources/{ldap-identity-source-id}'.sub('{' + 'ldap-identity-source-id' + '}', ldap_identity_source_id.to_s)

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
        :return_type => 'LdapIdentitySource')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi#read_ldap_identity_source\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Search the LDAP identity source
    # Search the LDAP identity source for users and groups that match the given filter_value. In most cases, the LDAP source performs a case-insensitive search.
    # @param ldap_identity_source_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :filter_value Search filter value
    # @return [LdapIdentitySourceSearchResultList]
    def search_ldap_identity_source(ldap_identity_source_id, opts = {})
      data, _status_code, _headers = search_ldap_identity_source_with_http_info(ldap_identity_source_id, opts)
      data
    end

    # Search the LDAP identity source
    # Search the LDAP identity source for users and groups that match the given filter_value. In most cases, the LDAP source performs a case-insensitive search.
    # @param ldap_identity_source_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :filter_value Search filter value
    # @return [Array<(LdapIdentitySourceSearchResultList, Fixnum, Hash)>] LdapIdentitySourceSearchResultList data, response status code and response headers
    def search_ldap_identity_source_with_http_info(ldap_identity_source_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.search_ldap_identity_source ...'
      end
      # verify the required parameter 'ldap_identity_source_id' is set
      if @api_client.config.client_side_validation && ldap_identity_source_id.nil?
        fail ArgumentError, "Missing the required parameter 'ldap_identity_source_id' when calling SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi.search_ldap_identity_source"
      end
      # resource path
      local_var_path = '/aaa/ldap-identity-sources/{ldap-identity-source-id}/search'.sub('{' + 'ldap-identity-source-id' + '}', ldap_identity_source_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'filter_value'] = opts[:'filter_value'] if !opts[:'filter_value'].nil?

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
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'LdapIdentitySourceSearchResultList')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: SystemAdministrationSettingsUserManagementLDAPIdentitySourcesApi#search_ldap_identity_source\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
