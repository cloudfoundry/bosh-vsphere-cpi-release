=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'uri'

module NSXTPolicy
  class PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Create or update a Tier-1 static routes
    # If static routes for route-id are not already present, create static routes. If it already exists, replace the static routes for route-id. 
    # @param tier_1_id 
    # @param route_id 
    # @param static_routes 
    # @param [Hash] opts the optional parameters
    # @return [StaticRoutes]
    def create_or_replace_tier1_static_routes(tier_1_id, route_id, static_routes, opts = {})
      data, _status_code, _headers = create_or_replace_tier1_static_routes_with_http_info(tier_1_id, route_id, static_routes, opts)
      data
    end

    # Create or update a Tier-1 static routes
    # If static routes for route-id are not already present, create static routes. If it already exists, replace the static routes for route-id. 
    # @param tier_1_id 
    # @param route_id 
    # @param static_routes 
    # @param [Hash] opts the optional parameters
    # @return [Array<(StaticRoutes, Fixnum, Hash)>] StaticRoutes data, response status code and response headers
    def create_or_replace_tier1_static_routes_with_http_info(tier_1_id, route_id, static_routes, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.create_or_replace_tier1_static_routes ...'
      end
      # verify the required parameter 'tier_1_id' is set
      if @api_client.config.client_side_validation && tier_1_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_1_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.create_or_replace_tier1_static_routes"
      end
      # verify the required parameter 'route_id' is set
      if @api_client.config.client_side_validation && route_id.nil?
        fail ArgumentError, "Missing the required parameter 'route_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.create_or_replace_tier1_static_routes"
      end
      # verify the required parameter 'static_routes' is set
      if @api_client.config.client_side_validation && static_routes.nil?
        fail ArgumentError, "Missing the required parameter 'static_routes' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.create_or_replace_tier1_static_routes"
      end
      # resource path
      local_var_path = '/infra/tier-1s/{tier-1-id}/static-routes/{route-id}'.sub('{' + 'tier-1-id' + '}', tier_1_id.to_s).sub('{' + 'route-id' + '}', route_id.to_s)

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
      post_body = @api_client.object_to_http_body(static_routes)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'StaticRoutes')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi#create_or_replace_tier1_static_routes\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or update a Tier-1 static routes
    # If static routes for route-id are not already present, create static routes. If it already exists, replace the static routes for route-id. 
    # @param tier_1_id 
    # @param route_id 
    # @param static_routes 
    # @param [Hash] opts the optional parameters
    # @return [StaticRoutes]
    def create_or_replace_tier1_static_routes_0(tier_1_id, route_id, static_routes, opts = {})
      data, _status_code, _headers = create_or_replace_tier1_static_routes_0_with_http_info(tier_1_id, route_id, static_routes, opts)
      data
    end

    # Create or update a Tier-1 static routes
    # If static routes for route-id are not already present, create static routes. If it already exists, replace the static routes for route-id. 
    # @param tier_1_id 
    # @param route_id 
    # @param static_routes 
    # @param [Hash] opts the optional parameters
    # @return [Array<(StaticRoutes, Fixnum, Hash)>] StaticRoutes data, response status code and response headers
    def create_or_replace_tier1_static_routes_0_with_http_info(tier_1_id, route_id, static_routes, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.create_or_replace_tier1_static_routes_0 ...'
      end
      # verify the required parameter 'tier_1_id' is set
      if @api_client.config.client_side_validation && tier_1_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_1_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.create_or_replace_tier1_static_routes_0"
      end
      # verify the required parameter 'route_id' is set
      if @api_client.config.client_side_validation && route_id.nil?
        fail ArgumentError, "Missing the required parameter 'route_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.create_or_replace_tier1_static_routes_0"
      end
      # verify the required parameter 'static_routes' is set
      if @api_client.config.client_side_validation && static_routes.nil?
        fail ArgumentError, "Missing the required parameter 'static_routes' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.create_or_replace_tier1_static_routes_0"
      end
      # resource path
      local_var_path = '/global-infra/tier-1s/{tier-1-id}/static-routes/{route-id}'.sub('{' + 'tier-1-id' + '}', tier_1_id.to_s).sub('{' + 'route-id' + '}', route_id.to_s)

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
      post_body = @api_client.object_to_http_body(static_routes)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'StaticRoutes')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi#create_or_replace_tier1_static_routes_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete Tier-1 static routes
    # Delete Tier-1 static routes
    # @param tier_1_id 
    # @param route_id 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def delete_tier1_static_routes(tier_1_id, route_id, opts = {})
      delete_tier1_static_routes_with_http_info(tier_1_id, route_id, opts)
      nil
    end

    # Delete Tier-1 static routes
    # Delete Tier-1 static routes
    # @param tier_1_id 
    # @param route_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def delete_tier1_static_routes_with_http_info(tier_1_id, route_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.delete_tier1_static_routes ...'
      end
      # verify the required parameter 'tier_1_id' is set
      if @api_client.config.client_side_validation && tier_1_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_1_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.delete_tier1_static_routes"
      end
      # verify the required parameter 'route_id' is set
      if @api_client.config.client_side_validation && route_id.nil?
        fail ArgumentError, "Missing the required parameter 'route_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.delete_tier1_static_routes"
      end
      # resource path
      local_var_path = '/infra/tier-1s/{tier-1-id}/static-routes/{route-id}'.sub('{' + 'tier-1-id' + '}', tier_1_id.to_s).sub('{' + 'route-id' + '}', route_id.to_s)

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
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi#delete_tier1_static_routes\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete Tier-1 static routes
    # Delete Tier-1 static routes
    # @param tier_1_id 
    # @param route_id 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def delete_tier1_static_routes_0(tier_1_id, route_id, opts = {})
      delete_tier1_static_routes_0_with_http_info(tier_1_id, route_id, opts)
      nil
    end

    # Delete Tier-1 static routes
    # Delete Tier-1 static routes
    # @param tier_1_id 
    # @param route_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def delete_tier1_static_routes_0_with_http_info(tier_1_id, route_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.delete_tier1_static_routes_0 ...'
      end
      # verify the required parameter 'tier_1_id' is set
      if @api_client.config.client_side_validation && tier_1_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_1_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.delete_tier1_static_routes_0"
      end
      # verify the required parameter 'route_id' is set
      if @api_client.config.client_side_validation && route_id.nil?
        fail ArgumentError, "Missing the required parameter 'route_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.delete_tier1_static_routes_0"
      end
      # resource path
      local_var_path = '/global-infra/tier-1s/{tier-1-id}/static-routes/{route-id}'.sub('{' + 'tier-1-id' + '}', tier_1_id.to_s).sub('{' + 'route-id' + '}', route_id.to_s)

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
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi#delete_tier1_static_routes_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List Tier-1 Static Routes
    # Paginated list of all Tier-1 Static Routes 
    # @param tier_1_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results (default to false)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [StaticRoutesListResult]
    def list_tier1_static_routes(tier_1_id, opts = {})
      data, _status_code, _headers = list_tier1_static_routes_with_http_info(tier_1_id, opts)
      data
    end

    # List Tier-1 Static Routes
    # Paginated list of all Tier-1 Static Routes 
    # @param tier_1_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(StaticRoutesListResult, Fixnum, Hash)>] StaticRoutesListResult data, response status code and response headers
    def list_tier1_static_routes_with_http_info(tier_1_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.list_tier1_static_routes ...'
      end
      # verify the required parameter 'tier_1_id' is set
      if @api_client.config.client_side_validation && tier_1_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_1_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.list_tier1_static_routes"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.list_tier1_static_routes, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.list_tier1_static_routes, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/global-infra/tier-1s/{tier-1-id}/static-routes'.sub('{' + 'tier-1-id' + '}', tier_1_id.to_s)

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
        :return_type => 'StaticRoutesListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi#list_tier1_static_routes\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List Tier-1 Static Routes
    # Paginated list of all Tier-1 Static Routes 
    # @param tier_1_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results (default to false)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [StaticRoutesListResult]
    def list_tier1_static_routes_0(tier_1_id, opts = {})
      data, _status_code, _headers = list_tier1_static_routes_0_with_http_info(tier_1_id, opts)
      data
    end

    # List Tier-1 Static Routes
    # Paginated list of all Tier-1 Static Routes 
    # @param tier_1_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(StaticRoutesListResult, Fixnum, Hash)>] StaticRoutesListResult data, response status code and response headers
    def list_tier1_static_routes_0_with_http_info(tier_1_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.list_tier1_static_routes_0 ...'
      end
      # verify the required parameter 'tier_1_id' is set
      if @api_client.config.client_side_validation && tier_1_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_1_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.list_tier1_static_routes_0"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.list_tier1_static_routes_0, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.list_tier1_static_routes_0, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/infra/tier-1s/{tier-1-id}/static-routes'.sub('{' + 'tier-1-id' + '}', tier_1_id.to_s)

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
        :return_type => 'StaticRoutesListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi#list_tier1_static_routes_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or update a Tier-1 static routes
    # If static routes for route-id are not already present, create static routes. If it already exists, update static routes for route-id. 
    # @param tier_1_id 
    # @param route_id 
    # @param static_routes 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def patch_tier1_static_routes(tier_1_id, route_id, static_routes, opts = {})
      patch_tier1_static_routes_with_http_info(tier_1_id, route_id, static_routes, opts)
      nil
    end

    # Create or update a Tier-1 static routes
    # If static routes for route-id are not already present, create static routes. If it already exists, update static routes for route-id. 
    # @param tier_1_id 
    # @param route_id 
    # @param static_routes 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_tier1_static_routes_with_http_info(tier_1_id, route_id, static_routes, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.patch_tier1_static_routes ...'
      end
      # verify the required parameter 'tier_1_id' is set
      if @api_client.config.client_side_validation && tier_1_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_1_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.patch_tier1_static_routes"
      end
      # verify the required parameter 'route_id' is set
      if @api_client.config.client_side_validation && route_id.nil?
        fail ArgumentError, "Missing the required parameter 'route_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.patch_tier1_static_routes"
      end
      # verify the required parameter 'static_routes' is set
      if @api_client.config.client_side_validation && static_routes.nil?
        fail ArgumentError, "Missing the required parameter 'static_routes' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.patch_tier1_static_routes"
      end
      # resource path
      local_var_path = '/infra/tier-1s/{tier-1-id}/static-routes/{route-id}'.sub('{' + 'tier-1-id' + '}', tier_1_id.to_s).sub('{' + 'route-id' + '}', route_id.to_s)

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
      post_body = @api_client.object_to_http_body(static_routes)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi#patch_tier1_static_routes\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or update a Tier-1 static routes
    # If static routes for route-id are not already present, create static routes. If it already exists, update static routes for route-id. 
    # @param tier_1_id 
    # @param route_id 
    # @param static_routes 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def patch_tier1_static_routes_0(tier_1_id, route_id, static_routes, opts = {})
      patch_tier1_static_routes_0_with_http_info(tier_1_id, route_id, static_routes, opts)
      nil
    end

    # Create or update a Tier-1 static routes
    # If static routes for route-id are not already present, create static routes. If it already exists, update static routes for route-id. 
    # @param tier_1_id 
    # @param route_id 
    # @param static_routes 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_tier1_static_routes_0_with_http_info(tier_1_id, route_id, static_routes, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.patch_tier1_static_routes_0 ...'
      end
      # verify the required parameter 'tier_1_id' is set
      if @api_client.config.client_side_validation && tier_1_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_1_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.patch_tier1_static_routes_0"
      end
      # verify the required parameter 'route_id' is set
      if @api_client.config.client_side_validation && route_id.nil?
        fail ArgumentError, "Missing the required parameter 'route_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.patch_tier1_static_routes_0"
      end
      # verify the required parameter 'static_routes' is set
      if @api_client.config.client_side_validation && static_routes.nil?
        fail ArgumentError, "Missing the required parameter 'static_routes' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.patch_tier1_static_routes_0"
      end
      # resource path
      local_var_path = '/global-infra/tier-1s/{tier-1-id}/static-routes/{route-id}'.sub('{' + 'tier-1-id' + '}', tier_1_id.to_s).sub('{' + 'route-id' + '}', route_id.to_s)

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
      post_body = @api_client.object_to_http_body(static_routes)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi#patch_tier1_static_routes_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Read Tier-1 static routes
    # Read Tier-1 static routes
    # @param tier_1_id 
    # @param route_id 
    # @param [Hash] opts the optional parameters
    # @return [StaticRoutes]
    def read_tier1_static_routes(tier_1_id, route_id, opts = {})
      data, _status_code, _headers = read_tier1_static_routes_with_http_info(tier_1_id, route_id, opts)
      data
    end

    # Read Tier-1 static routes
    # Read Tier-1 static routes
    # @param tier_1_id 
    # @param route_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(StaticRoutes, Fixnum, Hash)>] StaticRoutes data, response status code and response headers
    def read_tier1_static_routes_with_http_info(tier_1_id, route_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.read_tier1_static_routes ...'
      end
      # verify the required parameter 'tier_1_id' is set
      if @api_client.config.client_side_validation && tier_1_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_1_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.read_tier1_static_routes"
      end
      # verify the required parameter 'route_id' is set
      if @api_client.config.client_side_validation && route_id.nil?
        fail ArgumentError, "Missing the required parameter 'route_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.read_tier1_static_routes"
      end
      # resource path
      local_var_path = '/infra/tier-1s/{tier-1-id}/static-routes/{route-id}'.sub('{' + 'tier-1-id' + '}', tier_1_id.to_s).sub('{' + 'route-id' + '}', route_id.to_s)

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
        :return_type => 'StaticRoutes')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi#read_tier1_static_routes\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Read Tier-1 static routes
    # Read Tier-1 static routes
    # @param tier_1_id 
    # @param route_id 
    # @param [Hash] opts the optional parameters
    # @return [StaticRoutes]
    def read_tier1_static_routes_0(tier_1_id, route_id, opts = {})
      data, _status_code, _headers = read_tier1_static_routes_0_with_http_info(tier_1_id, route_id, opts)
      data
    end

    # Read Tier-1 static routes
    # Read Tier-1 static routes
    # @param tier_1_id 
    # @param route_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(StaticRoutes, Fixnum, Hash)>] StaticRoutes data, response status code and response headers
    def read_tier1_static_routes_0_with_http_info(tier_1_id, route_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.read_tier1_static_routes_0 ...'
      end
      # verify the required parameter 'tier_1_id' is set
      if @api_client.config.client_side_validation && tier_1_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_1_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.read_tier1_static_routes_0"
      end
      # verify the required parameter 'route_id' is set
      if @api_client.config.client_side_validation && route_id.nil?
        fail ArgumentError, "Missing the required parameter 'route_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi.read_tier1_static_routes_0"
      end
      # resource path
      local_var_path = '/global-infra/tier-1s/{tier-1-id}/static-routes/{route-id}'.sub('{' + 'tier-1-id' + '}', tier_1_id.to_s).sub('{' + 'route-id' + '}', route_id.to_s)

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
        :return_type => 'StaticRoutes')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier1GatewaysRoutingStaticRoutesApi#read_tier1_static_routes_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
