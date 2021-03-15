=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'uri'

module NSXTPolicy
  class PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Create or update a route map
    # If a route map with the route-map-id is not already present, create a new route map. If it already exists, replace the route map instance with the new object. 
    # @param tier_0_id 
    # @param route_map_id 
    # @param tier0_route_map 
    # @param [Hash] opts the optional parameters
    # @return [Tier0RouteMap]
    def create_or_replace_route_map(tier_0_id, route_map_id, tier0_route_map, opts = {})
      data, _status_code, _headers = create_or_replace_route_map_with_http_info(tier_0_id, route_map_id, tier0_route_map, opts)
      data
    end

    # Create or update a route map
    # If a route map with the route-map-id is not already present, create a new route map. If it already exists, replace the route map instance with the new object. 
    # @param tier_0_id 
    # @param route_map_id 
    # @param tier0_route_map 
    # @param [Hash] opts the optional parameters
    # @return [Array<(Tier0RouteMap, Fixnum, Hash)>] Tier0RouteMap data, response status code and response headers
    def create_or_replace_route_map_with_http_info(tier_0_id, route_map_id, tier0_route_map, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.create_or_replace_route_map ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.create_or_replace_route_map"
      end
      # verify the required parameter 'route_map_id' is set
      if @api_client.config.client_side_validation && route_map_id.nil?
        fail ArgumentError, "Missing the required parameter 'route_map_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.create_or_replace_route_map"
      end
      # verify the required parameter 'tier0_route_map' is set
      if @api_client.config.client_side_validation && tier0_route_map.nil?
        fail ArgumentError, "Missing the required parameter 'tier0_route_map' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.create_or_replace_route_map"
      end
      # resource path
      local_var_path = '/global-infra/tier-0s/{tier-0-id}/route-maps/{route-map-id}'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s).sub('{' + 'route-map-id' + '}', route_map_id.to_s)

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
      post_body = @api_client.object_to_http_body(tier0_route_map)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'Tier0RouteMap')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi#create_or_replace_route_map\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or update a route map
    # If a route map with the route-map-id is not already present, create a new route map. If it already exists, replace the route map instance with the new object. 
    # @param tier_0_id 
    # @param route_map_id 
    # @param tier0_route_map 
    # @param [Hash] opts the optional parameters
    # @return [Tier0RouteMap]
    def create_or_replace_route_map_0(tier_0_id, route_map_id, tier0_route_map, opts = {})
      data, _status_code, _headers = create_or_replace_route_map_0_with_http_info(tier_0_id, route_map_id, tier0_route_map, opts)
      data
    end

    # Create or update a route map
    # If a route map with the route-map-id is not already present, create a new route map. If it already exists, replace the route map instance with the new object. 
    # @param tier_0_id 
    # @param route_map_id 
    # @param tier0_route_map 
    # @param [Hash] opts the optional parameters
    # @return [Array<(Tier0RouteMap, Fixnum, Hash)>] Tier0RouteMap data, response status code and response headers
    def create_or_replace_route_map_0_with_http_info(tier_0_id, route_map_id, tier0_route_map, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.create_or_replace_route_map_0 ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.create_or_replace_route_map_0"
      end
      # verify the required parameter 'route_map_id' is set
      if @api_client.config.client_side_validation && route_map_id.nil?
        fail ArgumentError, "Missing the required parameter 'route_map_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.create_or_replace_route_map_0"
      end
      # verify the required parameter 'tier0_route_map' is set
      if @api_client.config.client_side_validation && tier0_route_map.nil?
        fail ArgumentError, "Missing the required parameter 'tier0_route_map' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.create_or_replace_route_map_0"
      end
      # resource path
      local_var_path = '/infra/tier-0s/{tier-0-id}/route-maps/{route-map-id}'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s).sub('{' + 'route-map-id' + '}', route_map_id.to_s)

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
      post_body = @api_client.object_to_http_body(tier0_route_map)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'Tier0RouteMap')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi#create_or_replace_route_map_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Read a route map
    # Read a route map
    # @param tier_0_id 
    # @param route_map_id 
    # @param [Hash] opts the optional parameters
    # @return [Tier0RouteMap]
    def get_route_map(tier_0_id, route_map_id, opts = {})
      data, _status_code, _headers = get_route_map_with_http_info(tier_0_id, route_map_id, opts)
      data
    end

    # Read a route map
    # Read a route map
    # @param tier_0_id 
    # @param route_map_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(Tier0RouteMap, Fixnum, Hash)>] Tier0RouteMap data, response status code and response headers
    def get_route_map_with_http_info(tier_0_id, route_map_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.get_route_map ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.get_route_map"
      end
      # verify the required parameter 'route_map_id' is set
      if @api_client.config.client_side_validation && route_map_id.nil?
        fail ArgumentError, "Missing the required parameter 'route_map_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.get_route_map"
      end
      # resource path
      local_var_path = '/global-infra/tier-0s/{tier-0-id}/route-maps/{route-map-id}'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s).sub('{' + 'route-map-id' + '}', route_map_id.to_s)

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
        :return_type => 'Tier0RouteMap')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi#get_route_map\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Read a route map
    # Read a route map
    # @param tier_0_id 
    # @param route_map_id 
    # @param [Hash] opts the optional parameters
    # @return [Tier0RouteMap]
    def get_route_map_0(tier_0_id, route_map_id, opts = {})
      data, _status_code, _headers = get_route_map_0_with_http_info(tier_0_id, route_map_id, opts)
      data
    end

    # Read a route map
    # Read a route map
    # @param tier_0_id 
    # @param route_map_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(Tier0RouteMap, Fixnum, Hash)>] Tier0RouteMap data, response status code and response headers
    def get_route_map_0_with_http_info(tier_0_id, route_map_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.get_route_map_0 ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.get_route_map_0"
      end
      # verify the required parameter 'route_map_id' is set
      if @api_client.config.client_side_validation && route_map_id.nil?
        fail ArgumentError, "Missing the required parameter 'route_map_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.get_route_map_0"
      end
      # resource path
      local_var_path = '/infra/tier-0s/{tier-0-id}/route-maps/{route-map-id}'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s).sub('{' + 'route-map-id' + '}', route_map_id.to_s)

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
        :return_type => 'Tier0RouteMap')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi#get_route_map_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List route maps
    # Paginated list of all route maps under a tier-0 
    # @param tier_0_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results (default to false)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Tier0RouteMapListResult]
    def list_all_route_maps(tier_0_id, opts = {})
      data, _status_code, _headers = list_all_route_maps_with_http_info(tier_0_id, opts)
      data
    end

    # List route maps
    # Paginated list of all route maps under a tier-0 
    # @param tier_0_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(Tier0RouteMapListResult, Fixnum, Hash)>] Tier0RouteMapListResult data, response status code and response headers
    def list_all_route_maps_with_http_info(tier_0_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.list_all_route_maps ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.list_all_route_maps"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.list_all_route_maps, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.list_all_route_maps, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/global-infra/tier-0s/{tier-0-id}/route-maps'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s)

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
        :return_type => 'Tier0RouteMapListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi#list_all_route_maps\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List route maps
    # Paginated list of all route maps under a tier-0 
    # @param tier_0_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results (default to false)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Tier0RouteMapListResult]
    def list_all_route_maps_0(tier_0_id, opts = {})
      data, _status_code, _headers = list_all_route_maps_0_with_http_info(tier_0_id, opts)
      data
    end

    # List route maps
    # Paginated list of all route maps under a tier-0 
    # @param tier_0_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(Tier0RouteMapListResult, Fixnum, Hash)>] Tier0RouteMapListResult data, response status code and response headers
    def list_all_route_maps_0_with_http_info(tier_0_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.list_all_route_maps_0 ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.list_all_route_maps_0"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.list_all_route_maps_0, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.list_all_route_maps_0, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/infra/tier-0s/{tier-0-id}/route-maps'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s)

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
        :return_type => 'Tier0RouteMapListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi#list_all_route_maps_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or update a route map
    # If a route map with the route-map-id is not already present, create a new route map. If it already exists, update the route map for specified attributes. 
    # @param tier_0_id 
    # @param route_map_id 
    # @param tier0_route_map 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def patch_route_map(tier_0_id, route_map_id, tier0_route_map, opts = {})
      patch_route_map_with_http_info(tier_0_id, route_map_id, tier0_route_map, opts)
      nil
    end

    # Create or update a route map
    # If a route map with the route-map-id is not already present, create a new route map. If it already exists, update the route map for specified attributes. 
    # @param tier_0_id 
    # @param route_map_id 
    # @param tier0_route_map 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_route_map_with_http_info(tier_0_id, route_map_id, tier0_route_map, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.patch_route_map ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.patch_route_map"
      end
      # verify the required parameter 'route_map_id' is set
      if @api_client.config.client_side_validation && route_map_id.nil?
        fail ArgumentError, "Missing the required parameter 'route_map_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.patch_route_map"
      end
      # verify the required parameter 'tier0_route_map' is set
      if @api_client.config.client_side_validation && tier0_route_map.nil?
        fail ArgumentError, "Missing the required parameter 'tier0_route_map' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.patch_route_map"
      end
      # resource path
      local_var_path = '/global-infra/tier-0s/{tier-0-id}/route-maps/{route-map-id}'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s).sub('{' + 'route-map-id' + '}', route_map_id.to_s)

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
      post_body = @api_client.object_to_http_body(tier0_route_map)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi#patch_route_map\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or update a route map
    # If a route map with the route-map-id is not already present, create a new route map. If it already exists, update the route map for specified attributes. 
    # @param tier_0_id 
    # @param route_map_id 
    # @param tier0_route_map 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def patch_route_map_0(tier_0_id, route_map_id, tier0_route_map, opts = {})
      patch_route_map_0_with_http_info(tier_0_id, route_map_id, tier0_route_map, opts)
      nil
    end

    # Create or update a route map
    # If a route map with the route-map-id is not already present, create a new route map. If it already exists, update the route map for specified attributes. 
    # @param tier_0_id 
    # @param route_map_id 
    # @param tier0_route_map 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_route_map_0_with_http_info(tier_0_id, route_map_id, tier0_route_map, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.patch_route_map_0 ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.patch_route_map_0"
      end
      # verify the required parameter 'route_map_id' is set
      if @api_client.config.client_side_validation && route_map_id.nil?
        fail ArgumentError, "Missing the required parameter 'route_map_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.patch_route_map_0"
      end
      # verify the required parameter 'tier0_route_map' is set
      if @api_client.config.client_side_validation && tier0_route_map.nil?
        fail ArgumentError, "Missing the required parameter 'tier0_route_map' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.patch_route_map_0"
      end
      # resource path
      local_var_path = '/infra/tier-0s/{tier-0-id}/route-maps/{route-map-id}'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s).sub('{' + 'route-map-id' + '}', route_map_id.to_s)

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
      post_body = @api_client.object_to_http_body(tier0_route_map)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi#patch_route_map_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete a route map
    # Delete a route map
    # @param tier_0_id 
    # @param route_map_id 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def remove_route_map(tier_0_id, route_map_id, opts = {})
      remove_route_map_with_http_info(tier_0_id, route_map_id, opts)
      nil
    end

    # Delete a route map
    # Delete a route map
    # @param tier_0_id 
    # @param route_map_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def remove_route_map_with_http_info(tier_0_id, route_map_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.remove_route_map ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.remove_route_map"
      end
      # verify the required parameter 'route_map_id' is set
      if @api_client.config.client_side_validation && route_map_id.nil?
        fail ArgumentError, "Missing the required parameter 'route_map_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.remove_route_map"
      end
      # resource path
      local_var_path = '/global-infra/tier-0s/{tier-0-id}/route-maps/{route-map-id}'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s).sub('{' + 'route-map-id' + '}', route_map_id.to_s)

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
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi#remove_route_map\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete a route map
    # Delete a route map
    # @param tier_0_id 
    # @param route_map_id 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def remove_route_map_0(tier_0_id, route_map_id, opts = {})
      remove_route_map_0_with_http_info(tier_0_id, route_map_id, opts)
      nil
    end

    # Delete a route map
    # Delete a route map
    # @param tier_0_id 
    # @param route_map_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def remove_route_map_0_with_http_info(tier_0_id, route_map_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.remove_route_map_0 ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.remove_route_map_0"
      end
      # verify the required parameter 'route_map_id' is set
      if @api_client.config.client_side_validation && route_map_id.nil?
        fail ArgumentError, "Missing the required parameter 'route_map_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi.remove_route_map_0"
      end
      # resource path
      local_var_path = '/infra/tier-0s/{tier-0-id}/route-maps/{route-map-id}'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s).sub('{' + 'route-map-id' + '}', route_map_id.to_s)

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
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingRouteMapsApi#remove_route_map_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
