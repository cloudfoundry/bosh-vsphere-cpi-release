=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'uri'

module NSXTPolicy
  class PolicyNetworkingConnectivityTier1GatewaysRoutingStateApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Get Tier1 state
    # Returns 
    # @param tier_1_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :enforcement_point_path Enforcement point path
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [String] :interface_path Interface path for interface specific state such as IPv6 DAD state
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Tier1GatewayState]
    def get_tier1_state(tier_1_id, opts = {})
      data, _status_code, _headers = get_tier1_state_with_http_info(tier_1_id, opts)
      data
    end

    # Get Tier1 state
    # Returns 
    # @param tier_1_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :enforcement_point_path Enforcement point path
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [String] :interface_path Interface path for interface specific state such as IPv6 DAD state
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(Tier1GatewayState, Fixnum, Hash)>] Tier1GatewayState data, response status code and response headers
    def get_tier1_state_with_http_info(tier_1_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier1GatewaysRoutingStateApi.get_tier1_state ...'
      end
      # verify the required parameter 'tier_1_id' is set
      if @api_client.config.client_side_validation && tier_1_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_1_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStateApi.get_tier1_state"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStateApi.get_tier1_state, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStateApi.get_tier1_state, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/global-infra/tier-1s/{tier-1-id}/state'.sub('{' + 'tier-1-id' + '}', tier_1_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'enforcement_point_path'] = opts[:'enforcement_point_path'] if !opts[:'enforcement_point_path'].nil?
      query_params[:'included_fields'] = opts[:'included_fields'] if !opts[:'included_fields'].nil?
      query_params[:'interface_path'] = opts[:'interface_path'] if !opts[:'interface_path'].nil?
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
        :return_type => 'Tier1GatewayState')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier1GatewaysRoutingStateApi#get_tier1_state\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get Tier1 state
    # Returns 
    # @param tier_1_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :enforcement_point_path Enforcement point path
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [String] :interface_path Interface path for interface specific state such as IPv6 DAD state
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Tier1GatewayState]
    def get_tier1_state_0(tier_1_id, opts = {})
      data, _status_code, _headers = get_tier1_state_0_with_http_info(tier_1_id, opts)
      data
    end

    # Get Tier1 state
    # Returns 
    # @param tier_1_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :enforcement_point_path Enforcement point path
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [String] :interface_path Interface path for interface specific state such as IPv6 DAD state
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(Tier1GatewayState, Fixnum, Hash)>] Tier1GatewayState data, response status code and response headers
    def get_tier1_state_0_with_http_info(tier_1_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier1GatewaysRoutingStateApi.get_tier1_state_0 ...'
      end
      # verify the required parameter 'tier_1_id' is set
      if @api_client.config.client_side_validation && tier_1_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_1_id' when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStateApi.get_tier1_state_0"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStateApi.get_tier1_state_0, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivityTier1GatewaysRoutingStateApi.get_tier1_state_0, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/infra/tier-1s/{tier-1-id}/state'.sub('{' + 'tier-1-id' + '}', tier_1_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'enforcement_point_path'] = opts[:'enforcement_point_path'] if !opts[:'enforcement_point_path'].nil?
      query_params[:'included_fields'] = opts[:'included_fields'] if !opts[:'included_fields'].nil?
      query_params[:'interface_path'] = opts[:'interface_path'] if !opts[:'interface_path'].nil?
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
        :return_type => 'Tier1GatewayState')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier1GatewaysRoutingStateApi#get_tier1_state_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
