=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.17

=end

require 'uri'

module NSXTPolicy
  class PolicyInfraDomainsDomainDeploymentMapsApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Create a new Domain Deployment Map under infra
    # If the passed Domain Deployment Map does not already exist, create a new Domain Deployment Map. If it already exist, replace it. 
    # @param domain_id 
    # @param domain_deployment_map_id 
    # @param domain_deployment_map 
    # @param [Hash] opts the optional parameters
    # @return [DomainDeploymentMap]
    def create_or_update_domain_deployment_map_for_infra(domain_id, domain_deployment_map_id, domain_deployment_map, opts = {})
      data, _status_code, _headers = create_or_update_domain_deployment_map_for_infra_with_http_info(domain_id, domain_deployment_map_id, domain_deployment_map, opts)
      data
    end

    # Create a new Domain Deployment Map under infra
    # If the passed Domain Deployment Map does not already exist, create a new Domain Deployment Map. If it already exist, replace it. 
    # @param domain_id 
    # @param domain_deployment_map_id 
    # @param domain_deployment_map 
    # @param [Hash] opts the optional parameters
    # @return [Array<(DomainDeploymentMap, Fixnum, Hash)>] DomainDeploymentMap data, response status code and response headers
    def create_or_update_domain_deployment_map_for_infra_with_http_info(domain_id, domain_deployment_map_id, domain_deployment_map, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraDomainsDomainDeploymentMapsApi.create_or_update_domain_deployment_map_for_infra ...'
      end
      # verify the required parameter 'domain_id' is set
      if @api_client.config.client_side_validation && domain_id.nil?
        fail ArgumentError, "Missing the required parameter 'domain_id' when calling PolicyInfraDomainsDomainDeploymentMapsApi.create_or_update_domain_deployment_map_for_infra"
      end
      # verify the required parameter 'domain_deployment_map_id' is set
      if @api_client.config.client_side_validation && domain_deployment_map_id.nil?
        fail ArgumentError, "Missing the required parameter 'domain_deployment_map_id' when calling PolicyInfraDomainsDomainDeploymentMapsApi.create_or_update_domain_deployment_map_for_infra"
      end
      # verify the required parameter 'domain_deployment_map' is set
      if @api_client.config.client_side_validation && domain_deployment_map.nil?
        fail ArgumentError, "Missing the required parameter 'domain_deployment_map' when calling PolicyInfraDomainsDomainDeploymentMapsApi.create_or_update_domain_deployment_map_for_infra"
      end
      # resource path
      local_var_path = '/infra/domains/{domain-id}/domain-deployment-maps/{domain-deployment-map-id}'.sub('{' + 'domain-id' + '}', domain_id.to_s).sub('{' + 'domain-deployment-map-id' + '}', domain_deployment_map_id.to_s)

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
      post_body = @api_client.object_to_http_body(domain_deployment_map)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'DomainDeploymentMap')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraDomainsDomainDeploymentMapsApi#create_or_update_domain_deployment_map_for_infra\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create a new Domain Deployment Map under infra
    # If the passed Domain Deployment Map does not already exist, create a new Domain Deployment Map. If it already exist, replace it. 
    # @param domain_id 
    # @param domain_deployment_map_id 
    # @param domain_deployment_map 
    # @param [Hash] opts the optional parameters
    # @return [DomainDeploymentMap]
    def create_or_update_domain_deployment_map_for_infra_0(domain_id, domain_deployment_map_id, domain_deployment_map, opts = {})
      data, _status_code, _headers = create_or_update_domain_deployment_map_for_infra_0_with_http_info(domain_id, domain_deployment_map_id, domain_deployment_map, opts)
      data
    end

    # Create a new Domain Deployment Map under infra
    # If the passed Domain Deployment Map does not already exist, create a new Domain Deployment Map. If it already exist, replace it. 
    # @param domain_id 
    # @param domain_deployment_map_id 
    # @param domain_deployment_map 
    # @param [Hash] opts the optional parameters
    # @return [Array<(DomainDeploymentMap, Fixnum, Hash)>] DomainDeploymentMap data, response status code and response headers
    def create_or_update_domain_deployment_map_for_infra_0_with_http_info(domain_id, domain_deployment_map_id, domain_deployment_map, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraDomainsDomainDeploymentMapsApi.create_or_update_domain_deployment_map_for_infra_0 ...'
      end
      # verify the required parameter 'domain_id' is set
      if @api_client.config.client_side_validation && domain_id.nil?
        fail ArgumentError, "Missing the required parameter 'domain_id' when calling PolicyInfraDomainsDomainDeploymentMapsApi.create_or_update_domain_deployment_map_for_infra_0"
      end
      # verify the required parameter 'domain_deployment_map_id' is set
      if @api_client.config.client_side_validation && domain_deployment_map_id.nil?
        fail ArgumentError, "Missing the required parameter 'domain_deployment_map_id' when calling PolicyInfraDomainsDomainDeploymentMapsApi.create_or_update_domain_deployment_map_for_infra_0"
      end
      # verify the required parameter 'domain_deployment_map' is set
      if @api_client.config.client_side_validation && domain_deployment_map.nil?
        fail ArgumentError, "Missing the required parameter 'domain_deployment_map' when calling PolicyInfraDomainsDomainDeploymentMapsApi.create_or_update_domain_deployment_map_for_infra_0"
      end
      # resource path
      local_var_path = '/global-infra/domains/{domain-id}/domain-deployment-maps/{domain-deployment-map-id}'.sub('{' + 'domain-id' + '}', domain_id.to_s).sub('{' + 'domain-deployment-map-id' + '}', domain_deployment_map_id.to_s)

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
      post_body = @api_client.object_to_http_body(domain_deployment_map)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'DomainDeploymentMap')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraDomainsDomainDeploymentMapsApi#create_or_update_domain_deployment_map_for_infra_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete Domain Deployment Map
    # Delete Domain Deployment Map
    # @param domain_id 
    # @param domain_deployment_map_id 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def delete_domain_deployment_map(domain_id, domain_deployment_map_id, opts = {})
      delete_domain_deployment_map_with_http_info(domain_id, domain_deployment_map_id, opts)
      nil
    end

    # Delete Domain Deployment Map
    # Delete Domain Deployment Map
    # @param domain_id 
    # @param domain_deployment_map_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def delete_domain_deployment_map_with_http_info(domain_id, domain_deployment_map_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraDomainsDomainDeploymentMapsApi.delete_domain_deployment_map ...'
      end
      # verify the required parameter 'domain_id' is set
      if @api_client.config.client_side_validation && domain_id.nil?
        fail ArgumentError, "Missing the required parameter 'domain_id' when calling PolicyInfraDomainsDomainDeploymentMapsApi.delete_domain_deployment_map"
      end
      # verify the required parameter 'domain_deployment_map_id' is set
      if @api_client.config.client_side_validation && domain_deployment_map_id.nil?
        fail ArgumentError, "Missing the required parameter 'domain_deployment_map_id' when calling PolicyInfraDomainsDomainDeploymentMapsApi.delete_domain_deployment_map"
      end
      # resource path
      local_var_path = '/infra/domains/{domain-id}/domain-deployment-maps/{domain-deployment-map-id}'.sub('{' + 'domain-id' + '}', domain_id.to_s).sub('{' + 'domain-deployment-map-id' + '}', domain_deployment_map_id.to_s)

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
        @api_client.config.logger.debug "API called: PolicyInfraDomainsDomainDeploymentMapsApi#delete_domain_deployment_map\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete Domain Deployment Map
    # Delete Domain Deployment Map
    # @param domain_id 
    # @param domain_deployment_map_id 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def delete_domain_deployment_map_0(domain_id, domain_deployment_map_id, opts = {})
      delete_domain_deployment_map_0_with_http_info(domain_id, domain_deployment_map_id, opts)
      nil
    end

    # Delete Domain Deployment Map
    # Delete Domain Deployment Map
    # @param domain_id 
    # @param domain_deployment_map_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def delete_domain_deployment_map_0_with_http_info(domain_id, domain_deployment_map_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraDomainsDomainDeploymentMapsApi.delete_domain_deployment_map_0 ...'
      end
      # verify the required parameter 'domain_id' is set
      if @api_client.config.client_side_validation && domain_id.nil?
        fail ArgumentError, "Missing the required parameter 'domain_id' when calling PolicyInfraDomainsDomainDeploymentMapsApi.delete_domain_deployment_map_0"
      end
      # verify the required parameter 'domain_deployment_map_id' is set
      if @api_client.config.client_side_validation && domain_deployment_map_id.nil?
        fail ArgumentError, "Missing the required parameter 'domain_deployment_map_id' when calling PolicyInfraDomainsDomainDeploymentMapsApi.delete_domain_deployment_map_0"
      end
      # resource path
      local_var_path = '/global-infra/domains/{domain-id}/domain-deployment-maps/{domain-deployment-map-id}'.sub('{' + 'domain-id' + '}', domain_id.to_s).sub('{' + 'domain-deployment-map-id' + '}', domain_deployment_map_id.to_s)

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
        @api_client.config.logger.debug "API called: PolicyInfraDomainsDomainDeploymentMapsApi#delete_domain_deployment_map_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List Domain Deployment maps for infra
    # Paginated list of all Domain Deployment Entries for infra. 
    # @param domain_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results (default to false)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [DomainDeploymentMapListResult]
    def list_domain_deployment_maps_for_infra(domain_id, opts = {})
      data, _status_code, _headers = list_domain_deployment_maps_for_infra_with_http_info(domain_id, opts)
      data
    end

    # List Domain Deployment maps for infra
    # Paginated list of all Domain Deployment Entries for infra. 
    # @param domain_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(DomainDeploymentMapListResult, Fixnum, Hash)>] DomainDeploymentMapListResult data, response status code and response headers
    def list_domain_deployment_maps_for_infra_with_http_info(domain_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraDomainsDomainDeploymentMapsApi.list_domain_deployment_maps_for_infra ...'
      end
      # verify the required parameter 'domain_id' is set
      if @api_client.config.client_side_validation && domain_id.nil?
        fail ArgumentError, "Missing the required parameter 'domain_id' when calling PolicyInfraDomainsDomainDeploymentMapsApi.list_domain_deployment_maps_for_infra"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyInfraDomainsDomainDeploymentMapsApi.list_domain_deployment_maps_for_infra, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyInfraDomainsDomainDeploymentMapsApi.list_domain_deployment_maps_for_infra, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/infra/domains/{domain-id}/domain-deployment-maps'.sub('{' + 'domain-id' + '}', domain_id.to_s)

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
        :return_type => 'DomainDeploymentMapListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraDomainsDomainDeploymentMapsApi#list_domain_deployment_maps_for_infra\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List Domain Deployment maps for infra
    # Paginated list of all Domain Deployment Entries for infra. 
    # @param domain_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results (default to false)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [DomainDeploymentMapListResult]
    def list_domain_deployment_maps_for_infra_0(domain_id, opts = {})
      data, _status_code, _headers = list_domain_deployment_maps_for_infra_0_with_http_info(domain_id, opts)
      data
    end

    # List Domain Deployment maps for infra
    # Paginated list of all Domain Deployment Entries for infra. 
    # @param domain_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(DomainDeploymentMapListResult, Fixnum, Hash)>] DomainDeploymentMapListResult data, response status code and response headers
    def list_domain_deployment_maps_for_infra_0_with_http_info(domain_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraDomainsDomainDeploymentMapsApi.list_domain_deployment_maps_for_infra_0 ...'
      end
      # verify the required parameter 'domain_id' is set
      if @api_client.config.client_side_validation && domain_id.nil?
        fail ArgumentError, "Missing the required parameter 'domain_id' when calling PolicyInfraDomainsDomainDeploymentMapsApi.list_domain_deployment_maps_for_infra_0"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyInfraDomainsDomainDeploymentMapsApi.list_domain_deployment_maps_for_infra_0, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyInfraDomainsDomainDeploymentMapsApi.list_domain_deployment_maps_for_infra_0, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/global-infra/domains/{domain-id}/domain-deployment-maps'.sub('{' + 'domain-id' + '}', domain_id.to_s)

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
        :return_type => 'DomainDeploymentMapListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraDomainsDomainDeploymentMapsApi#list_domain_deployment_maps_for_infra_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Patch Domain Deployment Map under infra
    # If the passed Domain Deployment Map does not already exist, create a new Domain Deployment Map. If it already exist, patch it. 
    # @param domain_id 
    # @param domain_deployment_map_id 
    # @param domain_deployment_map 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def patch_domain_deployment_map_for_infra(domain_id, domain_deployment_map_id, domain_deployment_map, opts = {})
      patch_domain_deployment_map_for_infra_with_http_info(domain_id, domain_deployment_map_id, domain_deployment_map, opts)
      nil
    end

    # Patch Domain Deployment Map under infra
    # If the passed Domain Deployment Map does not already exist, create a new Domain Deployment Map. If it already exist, patch it. 
    # @param domain_id 
    # @param domain_deployment_map_id 
    # @param domain_deployment_map 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_domain_deployment_map_for_infra_with_http_info(domain_id, domain_deployment_map_id, domain_deployment_map, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraDomainsDomainDeploymentMapsApi.patch_domain_deployment_map_for_infra ...'
      end
      # verify the required parameter 'domain_id' is set
      if @api_client.config.client_side_validation && domain_id.nil?
        fail ArgumentError, "Missing the required parameter 'domain_id' when calling PolicyInfraDomainsDomainDeploymentMapsApi.patch_domain_deployment_map_for_infra"
      end
      # verify the required parameter 'domain_deployment_map_id' is set
      if @api_client.config.client_side_validation && domain_deployment_map_id.nil?
        fail ArgumentError, "Missing the required parameter 'domain_deployment_map_id' when calling PolicyInfraDomainsDomainDeploymentMapsApi.patch_domain_deployment_map_for_infra"
      end
      # verify the required parameter 'domain_deployment_map' is set
      if @api_client.config.client_side_validation && domain_deployment_map.nil?
        fail ArgumentError, "Missing the required parameter 'domain_deployment_map' when calling PolicyInfraDomainsDomainDeploymentMapsApi.patch_domain_deployment_map_for_infra"
      end
      # resource path
      local_var_path = '/infra/domains/{domain-id}/domain-deployment-maps/{domain-deployment-map-id}'.sub('{' + 'domain-id' + '}', domain_id.to_s).sub('{' + 'domain-deployment-map-id' + '}', domain_deployment_map_id.to_s)

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
      post_body = @api_client.object_to_http_body(domain_deployment_map)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraDomainsDomainDeploymentMapsApi#patch_domain_deployment_map_for_infra\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Patch Domain Deployment Map under infra
    # If the passed Domain Deployment Map does not already exist, create a new Domain Deployment Map. If it already exist, patch it. 
    # @param domain_id 
    # @param domain_deployment_map_id 
    # @param domain_deployment_map 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def patch_domain_deployment_map_for_infra_0(domain_id, domain_deployment_map_id, domain_deployment_map, opts = {})
      patch_domain_deployment_map_for_infra_0_with_http_info(domain_id, domain_deployment_map_id, domain_deployment_map, opts)
      nil
    end

    # Patch Domain Deployment Map under infra
    # If the passed Domain Deployment Map does not already exist, create a new Domain Deployment Map. If it already exist, patch it. 
    # @param domain_id 
    # @param domain_deployment_map_id 
    # @param domain_deployment_map 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_domain_deployment_map_for_infra_0_with_http_info(domain_id, domain_deployment_map_id, domain_deployment_map, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraDomainsDomainDeploymentMapsApi.patch_domain_deployment_map_for_infra_0 ...'
      end
      # verify the required parameter 'domain_id' is set
      if @api_client.config.client_side_validation && domain_id.nil?
        fail ArgumentError, "Missing the required parameter 'domain_id' when calling PolicyInfraDomainsDomainDeploymentMapsApi.patch_domain_deployment_map_for_infra_0"
      end
      # verify the required parameter 'domain_deployment_map_id' is set
      if @api_client.config.client_side_validation && domain_deployment_map_id.nil?
        fail ArgumentError, "Missing the required parameter 'domain_deployment_map_id' when calling PolicyInfraDomainsDomainDeploymentMapsApi.patch_domain_deployment_map_for_infra_0"
      end
      # verify the required parameter 'domain_deployment_map' is set
      if @api_client.config.client_side_validation && domain_deployment_map.nil?
        fail ArgumentError, "Missing the required parameter 'domain_deployment_map' when calling PolicyInfraDomainsDomainDeploymentMapsApi.patch_domain_deployment_map_for_infra_0"
      end
      # resource path
      local_var_path = '/global-infra/domains/{domain-id}/domain-deployment-maps/{domain-deployment-map-id}'.sub('{' + 'domain-id' + '}', domain_id.to_s).sub('{' + 'domain-deployment-map-id' + '}', domain_deployment_map_id.to_s)

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
      post_body = @api_client.object_to_http_body(domain_deployment_map)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraDomainsDomainDeploymentMapsApi#patch_domain_deployment_map_for_infra_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Read a DomainDeploymentMap
    # Read a Domain Deployment Map 
    # @param domain_id 
    # @param domain_deployment_map_id 
    # @param [Hash] opts the optional parameters
    # @return [DomainDeploymentMap]
    def read_domain_deployment_map_for_infra(domain_id, domain_deployment_map_id, opts = {})
      data, _status_code, _headers = read_domain_deployment_map_for_infra_with_http_info(domain_id, domain_deployment_map_id, opts)
      data
    end

    # Read a DomainDeploymentMap
    # Read a Domain Deployment Map 
    # @param domain_id 
    # @param domain_deployment_map_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(DomainDeploymentMap, Fixnum, Hash)>] DomainDeploymentMap data, response status code and response headers
    def read_domain_deployment_map_for_infra_with_http_info(domain_id, domain_deployment_map_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraDomainsDomainDeploymentMapsApi.read_domain_deployment_map_for_infra ...'
      end
      # verify the required parameter 'domain_id' is set
      if @api_client.config.client_side_validation && domain_id.nil?
        fail ArgumentError, "Missing the required parameter 'domain_id' when calling PolicyInfraDomainsDomainDeploymentMapsApi.read_domain_deployment_map_for_infra"
      end
      # verify the required parameter 'domain_deployment_map_id' is set
      if @api_client.config.client_side_validation && domain_deployment_map_id.nil?
        fail ArgumentError, "Missing the required parameter 'domain_deployment_map_id' when calling PolicyInfraDomainsDomainDeploymentMapsApi.read_domain_deployment_map_for_infra"
      end
      # resource path
      local_var_path = '/infra/domains/{domain-id}/domain-deployment-maps/{domain-deployment-map-id}'.sub('{' + 'domain-id' + '}', domain_id.to_s).sub('{' + 'domain-deployment-map-id' + '}', domain_deployment_map_id.to_s)

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
        :return_type => 'DomainDeploymentMap')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraDomainsDomainDeploymentMapsApi#read_domain_deployment_map_for_infra\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Read a DomainDeploymentMap
    # Read a Domain Deployment Map 
    # @param domain_id 
    # @param domain_deployment_map_id 
    # @param [Hash] opts the optional parameters
    # @return [DomainDeploymentMap]
    def read_domain_deployment_map_for_infra_0(domain_id, domain_deployment_map_id, opts = {})
      data, _status_code, _headers = read_domain_deployment_map_for_infra_0_with_http_info(domain_id, domain_deployment_map_id, opts)
      data
    end

    # Read a DomainDeploymentMap
    # Read a Domain Deployment Map 
    # @param domain_id 
    # @param domain_deployment_map_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(DomainDeploymentMap, Fixnum, Hash)>] DomainDeploymentMap data, response status code and response headers
    def read_domain_deployment_map_for_infra_0_with_http_info(domain_id, domain_deployment_map_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyInfraDomainsDomainDeploymentMapsApi.read_domain_deployment_map_for_infra_0 ...'
      end
      # verify the required parameter 'domain_id' is set
      if @api_client.config.client_side_validation && domain_id.nil?
        fail ArgumentError, "Missing the required parameter 'domain_id' when calling PolicyInfraDomainsDomainDeploymentMapsApi.read_domain_deployment_map_for_infra_0"
      end
      # verify the required parameter 'domain_deployment_map_id' is set
      if @api_client.config.client_side_validation && domain_deployment_map_id.nil?
        fail ArgumentError, "Missing the required parameter 'domain_deployment_map_id' when calling PolicyInfraDomainsDomainDeploymentMapsApi.read_domain_deployment_map_for_infra_0"
      end
      # resource path
      local_var_path = '/global-infra/domains/{domain-id}/domain-deployment-maps/{domain-deployment-map-id}'.sub('{' + 'domain-id' + '}', domain_id.to_s).sub('{' + 'domain-deployment-map-id' + '}', domain_deployment_map_id.to_s)

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
        :return_type => 'DomainDeploymentMap')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyInfraDomainsDomainDeploymentMapsApi#read_domain_deployment_map_for_infra_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
