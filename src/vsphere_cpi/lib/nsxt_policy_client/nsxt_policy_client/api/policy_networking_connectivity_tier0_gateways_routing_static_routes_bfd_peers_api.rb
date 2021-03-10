=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.17

=end

require 'uri'

module NSXTPolicy
  class PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Delete this StaticRouteBfdPeer and all the entities contained by it.
    # Delete this StaticRouteBfdPeer and all the entities contained by it.
    # @param tier_0_id Tier-0 ID
    # @param bfd_peer_id BFD peer ID
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def delete_static_route_bfd_peer(tier_0_id, bfd_peer_id, opts = {})
      delete_static_route_bfd_peer_with_http_info(tier_0_id, bfd_peer_id, opts)
      nil
    end

    # Delete this StaticRouteBfdPeer and all the entities contained by it.
    # Delete this StaticRouteBfdPeer and all the entities contained by it.
    # @param tier_0_id Tier-0 ID
    # @param bfd_peer_id BFD peer ID
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def delete_static_route_bfd_peer_with_http_info(tier_0_id, bfd_peer_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.delete_static_route_bfd_peer ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.delete_static_route_bfd_peer"
      end
      # verify the required parameter 'bfd_peer_id' is set
      if @api_client.config.client_side_validation && bfd_peer_id.nil?
        fail ArgumentError, "Missing the required parameter 'bfd_peer_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.delete_static_route_bfd_peer"
      end
      # resource path
      local_var_path = '/infra/tier-0s/{tier-0-id}/static-routes/bfd-peers/{bfd-peer-id}'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s).sub('{' + 'bfd-peer-id' + '}', bfd_peer_id.to_s)

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
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi#delete_static_route_bfd_peer\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete this StaticRouteBfdPeer and all the entities contained by it.
    # Delete this StaticRouteBfdPeer and all the entities contained by it.
    # @param tier_0_id Tier-0 ID
    # @param bfd_peer_id BFD peer ID
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def delete_static_route_bfd_peer_0(tier_0_id, bfd_peer_id, opts = {})
      delete_static_route_bfd_peer_0_with_http_info(tier_0_id, bfd_peer_id, opts)
      nil
    end

    # Delete this StaticRouteBfdPeer and all the entities contained by it.
    # Delete this StaticRouteBfdPeer and all the entities contained by it.
    # @param tier_0_id Tier-0 ID
    # @param bfd_peer_id BFD peer ID
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def delete_static_route_bfd_peer_0_with_http_info(tier_0_id, bfd_peer_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.delete_static_route_bfd_peer_0 ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.delete_static_route_bfd_peer_0"
      end
      # verify the required parameter 'bfd_peer_id' is set
      if @api_client.config.client_side_validation && bfd_peer_id.nil?
        fail ArgumentError, "Missing the required parameter 'bfd_peer_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.delete_static_route_bfd_peer_0"
      end
      # resource path
      local_var_path = '/global-infra/tier-0s/{tier-0-id}/static-routes/bfd-peers/{bfd-peer-id}'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s).sub('{' + 'bfd-peer-id' + '}', bfd_peer_id.to_s)

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
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi#delete_static_route_bfd_peer_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List StaticRouteBfdPeers
    # Paginated list of all StaticRouteBfdPeers. 
    # @param tier_0_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results (default to false)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [StaticRouteBfdPeerListResult]
    def list_static_route_bfd_peer(tier_0_id, opts = {})
      data, _status_code, _headers = list_static_route_bfd_peer_with_http_info(tier_0_id, opts)
      data
    end

    # List StaticRouteBfdPeers
    # Paginated list of all StaticRouteBfdPeers. 
    # @param tier_0_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(StaticRouteBfdPeerListResult, Fixnum, Hash)>] StaticRouteBfdPeerListResult data, response status code and response headers
    def list_static_route_bfd_peer_with_http_info(tier_0_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.list_static_route_bfd_peer ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.list_static_route_bfd_peer"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.list_static_route_bfd_peer, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.list_static_route_bfd_peer, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/infra/tier-0s/{tier-0-id}/static-routes/bfd-peers'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s)

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
        :return_type => 'StaticRouteBfdPeerListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi#list_static_route_bfd_peer\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List StaticRouteBfdPeers
    # Paginated list of all StaticRouteBfdPeers. 
    # @param tier_0_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results (default to false)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [StaticRouteBfdPeerListResult]
    def list_static_route_bfd_peer_0(tier_0_id, opts = {})
      data, _status_code, _headers = list_static_route_bfd_peer_0_with_http_info(tier_0_id, opts)
      data
    end

    # List StaticRouteBfdPeers
    # Paginated list of all StaticRouteBfdPeers. 
    # @param tier_0_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(StaticRouteBfdPeerListResult, Fixnum, Hash)>] StaticRouteBfdPeerListResult data, response status code and response headers
    def list_static_route_bfd_peer_0_with_http_info(tier_0_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.list_static_route_bfd_peer_0 ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.list_static_route_bfd_peer_0"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.list_static_route_bfd_peer_0, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.list_static_route_bfd_peer_0, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/global-infra/tier-0s/{tier-0-id}/static-routes/bfd-peers'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s)

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
        :return_type => 'StaticRouteBfdPeerListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi#list_static_route_bfd_peer_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or update a StaticRouteBfdPeer
    # If a StaticRouteBfdPeer with the bfd-peer-id is not already present, create a new StaticRouteBfdPeer. If it already exists, update the StaticRouteBfdPeer. This is a full replace. 
    # @param tier_0_id Tier-0 ID
    # @param bfd_peer_id BFD peer ID
    # @param static_route_bfd_peer 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def patch_static_route_bfd_peer(tier_0_id, bfd_peer_id, static_route_bfd_peer, opts = {})
      patch_static_route_bfd_peer_with_http_info(tier_0_id, bfd_peer_id, static_route_bfd_peer, opts)
      nil
    end

    # Create or update a StaticRouteBfdPeer
    # If a StaticRouteBfdPeer with the bfd-peer-id is not already present, create a new StaticRouteBfdPeer. If it already exists, update the StaticRouteBfdPeer. This is a full replace. 
    # @param tier_0_id Tier-0 ID
    # @param bfd_peer_id BFD peer ID
    # @param static_route_bfd_peer 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_static_route_bfd_peer_with_http_info(tier_0_id, bfd_peer_id, static_route_bfd_peer, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.patch_static_route_bfd_peer ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.patch_static_route_bfd_peer"
      end
      # verify the required parameter 'bfd_peer_id' is set
      if @api_client.config.client_side_validation && bfd_peer_id.nil?
        fail ArgumentError, "Missing the required parameter 'bfd_peer_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.patch_static_route_bfd_peer"
      end
      # verify the required parameter 'static_route_bfd_peer' is set
      if @api_client.config.client_side_validation && static_route_bfd_peer.nil?
        fail ArgumentError, "Missing the required parameter 'static_route_bfd_peer' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.patch_static_route_bfd_peer"
      end
      # resource path
      local_var_path = '/infra/tier-0s/{tier-0-id}/static-routes/bfd-peers/{bfd-peer-id}'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s).sub('{' + 'bfd-peer-id' + '}', bfd_peer_id.to_s)

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
      post_body = @api_client.object_to_http_body(static_route_bfd_peer)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi#patch_static_route_bfd_peer\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or update a StaticRouteBfdPeer
    # If a StaticRouteBfdPeer with the bfd-peer-id is not already present, create a new StaticRouteBfdPeer. If it already exists, update the StaticRouteBfdPeer. This is a full replace. 
    # @param tier_0_id Tier-0 ID
    # @param bfd_peer_id BFD peer ID
    # @param static_route_bfd_peer 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def patch_static_route_bfd_peer_0(tier_0_id, bfd_peer_id, static_route_bfd_peer, opts = {})
      patch_static_route_bfd_peer_0_with_http_info(tier_0_id, bfd_peer_id, static_route_bfd_peer, opts)
      nil
    end

    # Create or update a StaticRouteBfdPeer
    # If a StaticRouteBfdPeer with the bfd-peer-id is not already present, create a new StaticRouteBfdPeer. If it already exists, update the StaticRouteBfdPeer. This is a full replace. 
    # @param tier_0_id Tier-0 ID
    # @param bfd_peer_id BFD peer ID
    # @param static_route_bfd_peer 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_static_route_bfd_peer_0_with_http_info(tier_0_id, bfd_peer_id, static_route_bfd_peer, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.patch_static_route_bfd_peer_0 ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.patch_static_route_bfd_peer_0"
      end
      # verify the required parameter 'bfd_peer_id' is set
      if @api_client.config.client_side_validation && bfd_peer_id.nil?
        fail ArgumentError, "Missing the required parameter 'bfd_peer_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.patch_static_route_bfd_peer_0"
      end
      # verify the required parameter 'static_route_bfd_peer' is set
      if @api_client.config.client_side_validation && static_route_bfd_peer.nil?
        fail ArgumentError, "Missing the required parameter 'static_route_bfd_peer' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.patch_static_route_bfd_peer_0"
      end
      # resource path
      local_var_path = '/global-infra/tier-0s/{tier-0-id}/static-routes/bfd-peers/{bfd-peer-id}'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s).sub('{' + 'bfd-peer-id' + '}', bfd_peer_id.to_s)

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
      post_body = @api_client.object_to_http_body(static_route_bfd_peer)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi#patch_static_route_bfd_peer_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Read a StaticRouteBfdPeer
    # Read a StaticRouteBfdPeer with the bfd-peer-id. 
    # @param tier_0_id Tier-0 ID
    # @param bfd_peer_id BFD peer ID
    # @param [Hash] opts the optional parameters
    # @return [StaticRouteBfdPeer]
    def read_static_route_bfd_peer(tier_0_id, bfd_peer_id, opts = {})
      data, _status_code, _headers = read_static_route_bfd_peer_with_http_info(tier_0_id, bfd_peer_id, opts)
      data
    end

    # Read a StaticRouteBfdPeer
    # Read a StaticRouteBfdPeer with the bfd-peer-id. 
    # @param tier_0_id Tier-0 ID
    # @param bfd_peer_id BFD peer ID
    # @param [Hash] opts the optional parameters
    # @return [Array<(StaticRouteBfdPeer, Fixnum, Hash)>] StaticRouteBfdPeer data, response status code and response headers
    def read_static_route_bfd_peer_with_http_info(tier_0_id, bfd_peer_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.read_static_route_bfd_peer ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.read_static_route_bfd_peer"
      end
      # verify the required parameter 'bfd_peer_id' is set
      if @api_client.config.client_side_validation && bfd_peer_id.nil?
        fail ArgumentError, "Missing the required parameter 'bfd_peer_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.read_static_route_bfd_peer"
      end
      # resource path
      local_var_path = '/infra/tier-0s/{tier-0-id}/static-routes/bfd-peers/{bfd-peer-id}'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s).sub('{' + 'bfd-peer-id' + '}', bfd_peer_id.to_s)

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
        :return_type => 'StaticRouteBfdPeer')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi#read_static_route_bfd_peer\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Read a StaticRouteBfdPeer
    # Read a StaticRouteBfdPeer with the bfd-peer-id. 
    # @param tier_0_id Tier-0 ID
    # @param bfd_peer_id BFD peer ID
    # @param [Hash] opts the optional parameters
    # @return [StaticRouteBfdPeer]
    def read_static_route_bfd_peer_0(tier_0_id, bfd_peer_id, opts = {})
      data, _status_code, _headers = read_static_route_bfd_peer_0_with_http_info(tier_0_id, bfd_peer_id, opts)
      data
    end

    # Read a StaticRouteBfdPeer
    # Read a StaticRouteBfdPeer with the bfd-peer-id. 
    # @param tier_0_id Tier-0 ID
    # @param bfd_peer_id BFD peer ID
    # @param [Hash] opts the optional parameters
    # @return [Array<(StaticRouteBfdPeer, Fixnum, Hash)>] StaticRouteBfdPeer data, response status code and response headers
    def read_static_route_bfd_peer_0_with_http_info(tier_0_id, bfd_peer_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.read_static_route_bfd_peer_0 ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.read_static_route_bfd_peer_0"
      end
      # verify the required parameter 'bfd_peer_id' is set
      if @api_client.config.client_side_validation && bfd_peer_id.nil?
        fail ArgumentError, "Missing the required parameter 'bfd_peer_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.read_static_route_bfd_peer_0"
      end
      # resource path
      local_var_path = '/global-infra/tier-0s/{tier-0-id}/static-routes/bfd-peers/{bfd-peer-id}'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s).sub('{' + 'bfd-peer-id' + '}', bfd_peer_id.to_s)

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
        :return_type => 'StaticRouteBfdPeer')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi#read_static_route_bfd_peer_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or update a StaticRouteBfdPeer
    # If a StaticRouteBfdPeer with the bfd-peer-id is not already present, create a new StaticRouteBfdPeer. If it already exists, update the StaticRouteBfdPeer. This operation will fully replace the object. 
    # @param tier_0_id Tier-0 ID
    # @param bfd_peer_id BFD peer ID
    # @param static_route_bfd_peer 
    # @param [Hash] opts the optional parameters
    # @return [StaticRouteBfdPeer]
    def update_static_route_bfd_peer(tier_0_id, bfd_peer_id, static_route_bfd_peer, opts = {})
      data, _status_code, _headers = update_static_route_bfd_peer_with_http_info(tier_0_id, bfd_peer_id, static_route_bfd_peer, opts)
      data
    end

    # Create or update a StaticRouteBfdPeer
    # If a StaticRouteBfdPeer with the bfd-peer-id is not already present, create a new StaticRouteBfdPeer. If it already exists, update the StaticRouteBfdPeer. This operation will fully replace the object. 
    # @param tier_0_id Tier-0 ID
    # @param bfd_peer_id BFD peer ID
    # @param static_route_bfd_peer 
    # @param [Hash] opts the optional parameters
    # @return [Array<(StaticRouteBfdPeer, Fixnum, Hash)>] StaticRouteBfdPeer data, response status code and response headers
    def update_static_route_bfd_peer_with_http_info(tier_0_id, bfd_peer_id, static_route_bfd_peer, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.update_static_route_bfd_peer ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.update_static_route_bfd_peer"
      end
      # verify the required parameter 'bfd_peer_id' is set
      if @api_client.config.client_side_validation && bfd_peer_id.nil?
        fail ArgumentError, "Missing the required parameter 'bfd_peer_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.update_static_route_bfd_peer"
      end
      # verify the required parameter 'static_route_bfd_peer' is set
      if @api_client.config.client_side_validation && static_route_bfd_peer.nil?
        fail ArgumentError, "Missing the required parameter 'static_route_bfd_peer' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.update_static_route_bfd_peer"
      end
      # resource path
      local_var_path = '/infra/tier-0s/{tier-0-id}/static-routes/bfd-peers/{bfd-peer-id}'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s).sub('{' + 'bfd-peer-id' + '}', bfd_peer_id.to_s)

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
      post_body = @api_client.object_to_http_body(static_route_bfd_peer)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'StaticRouteBfdPeer')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi#update_static_route_bfd_peer\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or update a StaticRouteBfdPeer
    # If a StaticRouteBfdPeer with the bfd-peer-id is not already present, create a new StaticRouteBfdPeer. If it already exists, update the StaticRouteBfdPeer. This operation will fully replace the object. 
    # @param tier_0_id Tier-0 ID
    # @param bfd_peer_id BFD peer ID
    # @param static_route_bfd_peer 
    # @param [Hash] opts the optional parameters
    # @return [StaticRouteBfdPeer]
    def update_static_route_bfd_peer_0(tier_0_id, bfd_peer_id, static_route_bfd_peer, opts = {})
      data, _status_code, _headers = update_static_route_bfd_peer_0_with_http_info(tier_0_id, bfd_peer_id, static_route_bfd_peer, opts)
      data
    end

    # Create or update a StaticRouteBfdPeer
    # If a StaticRouteBfdPeer with the bfd-peer-id is not already present, create a new StaticRouteBfdPeer. If it already exists, update the StaticRouteBfdPeer. This operation will fully replace the object. 
    # @param tier_0_id Tier-0 ID
    # @param bfd_peer_id BFD peer ID
    # @param static_route_bfd_peer 
    # @param [Hash] opts the optional parameters
    # @return [Array<(StaticRouteBfdPeer, Fixnum, Hash)>] StaticRouteBfdPeer data, response status code and response headers
    def update_static_route_bfd_peer_0_with_http_info(tier_0_id, bfd_peer_id, static_route_bfd_peer, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.update_static_route_bfd_peer_0 ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.update_static_route_bfd_peer_0"
      end
      # verify the required parameter 'bfd_peer_id' is set
      if @api_client.config.client_side_validation && bfd_peer_id.nil?
        fail ArgumentError, "Missing the required parameter 'bfd_peer_id' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.update_static_route_bfd_peer_0"
      end
      # verify the required parameter 'static_route_bfd_peer' is set
      if @api_client.config.client_side_validation && static_route_bfd_peer.nil?
        fail ArgumentError, "Missing the required parameter 'static_route_bfd_peer' when calling PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi.update_static_route_bfd_peer_0"
      end
      # resource path
      local_var_path = '/global-infra/tier-0s/{tier-0-id}/static-routes/bfd-peers/{bfd-peer-id}'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s).sub('{' + 'bfd-peer-id' + '}', bfd_peer_id.to_s)

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
      post_body = @api_client.object_to_http_body(static_route_bfd_peer)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'StaticRouteBfdPeer')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysRoutingStaticRoutesBFDPeersApi#update_static_route_bfd_peer_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
