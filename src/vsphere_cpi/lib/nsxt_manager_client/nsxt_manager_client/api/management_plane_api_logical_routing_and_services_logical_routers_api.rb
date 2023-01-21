=begin
#NSX-T Manager API

#VMware NSX-T Manager REST API

OpenAPI spec version: 2.5.1.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'uri'

module NSXT
  class ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Create a Logical Router
    # Creates a logical router. The required parameters are router_type (TIER0 or TIER1) and edge_cluster_id (TIER0 only). Optional parameters include internal and external transit network addresses. 
    # @param logical_router 
    # @param [Hash] opts the optional parameters
    # @return [LogicalRouter]
    def create_logical_router(logical_router, opts = {})
      data, _status_code, _headers = create_logical_router_with_http_info(logical_router, opts)
      data
    end

    # Create a Logical Router
    # Creates a logical router. The required parameters are router_type (TIER0 or TIER1) and edge_cluster_id (TIER0 only). Optional parameters include internal and external transit network addresses. 
    # @param logical_router 
    # @param [Hash] opts the optional parameters
    # @return [Array<(LogicalRouter, Fixnum, Hash)>] LogicalRouter data, response status code and response headers
    def create_logical_router_with_http_info(logical_router, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi.create_logical_router ...'
      end
      # verify the required parameter 'logical_router' is set
      if @api_client.config.client_side_validation && logical_router.nil?
        fail ArgumentError, "Missing the required parameter 'logical_router' when calling ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi.create_logical_router"
      end
      # resource path
      local_var_path = '/logical-routers'

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
      post_body = @api_client.object_to_http_body(logical_router)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'LogicalRouter')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi#create_logical_router\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete a Logical Router
    # Deletes the specified logical router. You must delete associated logical router ports before you can delete a logical router. Otherwise use force delete which will delete all related ports and other entities associated with that LR. To force delete logical router pass force=true in query param. 
    # @param logical_router_id 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :cascade_delete_linked_ports Flag to specify whether to delete related logical switch ports (default to false)
    # @option opts [BOOLEAN] :force Force delete the resource even if it is being used somewhere  (default to false)
    # @return [nil]
    def delete_logical_router(logical_router_id, opts = {})
      delete_logical_router_with_http_info(logical_router_id, opts)
      nil
    end

    # Delete a Logical Router
    # Deletes the specified logical router. You must delete associated logical router ports before you can delete a logical router. Otherwise use force delete which will delete all related ports and other entities associated with that LR. To force delete logical router pass force&#x3D;true in query param. 
    # @param logical_router_id 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :cascade_delete_linked_ports Flag to specify whether to delete related logical switch ports
    # @option opts [BOOLEAN] :force Force delete the resource even if it is being used somewhere 
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def delete_logical_router_with_http_info(logical_router_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi.delete_logical_router ...'
      end
      # verify the required parameter 'logical_router_id' is set
      if @api_client.config.client_side_validation && logical_router_id.nil?
        fail ArgumentError, "Missing the required parameter 'logical_router_id' when calling ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi.delete_logical_router"
      end
      # resource path
      local_var_path = '/logical-routers/{logical-router-id}'.sub('{' + 'logical-router-id' + '}', logical_router_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'cascade_delete_linked_ports'] = opts[:'cascade_delete_linked_ports'] if !opts[:'cascade_delete_linked_ports'].nil?
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
        @api_client.config.logger.debug "API called: ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi#delete_logical_router\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List Logical Routers
    # Returns information about all logical routers, including the UUID, internal and external transit network addresses, and the router type (TIER0 or TIER1). You can get information for only TIER0 routers or only the TIER1 routers by including the router_type query parameter. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [String] :router_type Type of Logical Router
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [LogicalRouterListResult]
    def list_logical_routers(opts = {})
      data, _status_code, _headers = list_logical_routers_with_http_info(opts)
      data
    end

    # List Logical Routers
    # Returns information about all logical routers, including the UUID, internal and external transit network addresses, and the router type (TIER0 or TIER1). You can get information for only TIER0 routers or only the TIER1 routers by including the router_type query parameter. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [String] :router_type Type of Logical Router
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(LogicalRouterListResult, Fixnum, Hash)>] LogicalRouterListResult data, response status code and response headers
    def list_logical_routers_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi.list_logical_routers ...'
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi.list_logical_routers, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi.list_logical_routers, must be greater than or equal to 0.'
      end

      if @api_client.config.client_side_validation && opts[:'router_type'] && !['TIER0', 'TIER1'].include?(opts[:'router_type'])
        fail ArgumentError, 'invalid value for "router_type", must be one of TIER0, TIER1'
      end
      # resource path
      local_var_path = '/logical-routers'

      # query parameters
      query_params = {}
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'included_fields'] = opts[:'included_fields'] if !opts[:'included_fields'].nil?
      query_params[:'page_size'] = opts[:'page_size'] if !opts[:'page_size'].nil?
      query_params[:'router_type'] = opts[:'router_type'] if !opts[:'router_type'].nil?
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
        :return_type => 'LogicalRouterListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi#list_logical_routers\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Read Logical Router
    # Returns information about the specified logical router.
    # @param logical_router_id 
    # @param [Hash] opts the optional parameters
    # @return [LogicalRouter]
    def read_logical_router(logical_router_id, opts = {})
      data, _status_code, _headers = read_logical_router_with_http_info(logical_router_id, opts)
      data
    end

    # Read Logical Router
    # Returns information about the specified logical router.
    # @param logical_router_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(LogicalRouter, Fixnum, Hash)>] LogicalRouter data, response status code and response headers
    def read_logical_router_with_http_info(logical_router_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi.read_logical_router ...'
      end
      # verify the required parameter 'logical_router_id' is set
      if @api_client.config.client_side_validation && logical_router_id.nil?
        fail ArgumentError, "Missing the required parameter 'logical_router_id' when calling ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi.read_logical_router"
      end
      # resource path
      local_var_path = '/logical-routers/{logical-router-id}'.sub('{' + 'logical-router-id' + '}', logical_router_id.to_s)

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
        :return_type => 'LogicalRouter')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi#read_logical_router\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Update a Logical Router
    # Modifies the specified logical router. Modifiable attributes include the internal_transit_network, external_transit_networks, and edge_cluster_id (for TIER0 routers). 
    # @param logical_router_id 
    # @param logical_router 
    # @param [Hash] opts the optional parameters
    # @return [LogicalRouter]
    def update_logical_router(logical_router_id, logical_router, opts = {})
      data, _status_code, _headers = update_logical_router_with_http_info(logical_router_id, logical_router, opts)
      data
    end

    # Update a Logical Router
    # Modifies the specified logical router. Modifiable attributes include the internal_transit_network, external_transit_networks, and edge_cluster_id (for TIER0 routers). 
    # @param logical_router_id 
    # @param logical_router 
    # @param [Hash] opts the optional parameters
    # @return [Array<(LogicalRouter, Fixnum, Hash)>] LogicalRouter data, response status code and response headers
    def update_logical_router_with_http_info(logical_router_id, logical_router, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi.update_logical_router ...'
      end
      # verify the required parameter 'logical_router_id' is set
      if @api_client.config.client_side_validation && logical_router_id.nil?
        fail ArgumentError, "Missing the required parameter 'logical_router_id' when calling ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi.update_logical_router"
      end
      # verify the required parameter 'logical_router' is set
      if @api_client.config.client_side_validation && logical_router.nil?
        fail ArgumentError, "Missing the required parameter 'logical_router' when calling ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi.update_logical_router"
      end
      # resource path
      local_var_path = '/logical-routers/{logical-router-id}'.sub('{' + 'logical-router-id' + '}', logical_router_id.to_s)

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
      post_body = @api_client.object_to_http_body(logical_router)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'LogicalRouter')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagementPlaneApiLogicalRoutingAndServicesLogicalRoutersApi#update_logical_router\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
