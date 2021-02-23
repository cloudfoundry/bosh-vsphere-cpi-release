=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.17

=end

require 'uri'

module NSXTPolicy
  class PolicyNetworkingConnectivityTier1GatewaysARPProxiesApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Get Tier-1 Address Resolution Protocol Proxies
    # Returns ARP proxy table for a tier-1 
    # @param tier_1_id 
    # @param locale_service_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :source Data source type.
    # @return [PolicyArpProxyTableListResult]
    def get_tier1_arp_proxies(tier_1_id, locale_service_id, opts = {})
      data, _status_code, _headers = get_tier1_arp_proxies_with_http_info(tier_1_id, locale_service_id, opts)
      data
    end

    # Get Tier-1 Address Resolution Protocol Proxies
    # Returns ARP proxy table for a tier-1 
    # @param tier_1_id 
    # @param locale_service_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :source Data source type.
    # @return [Array<(PolicyArpProxyTableListResult, Fixnum, Hash)>] PolicyArpProxyTableListResult data, response status code and response headers
    def get_tier1_arp_proxies_with_http_info(tier_1_id, locale_service_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier1GatewaysARPProxiesApi.get_tier1_arp_proxies ...'
      end
      # verify the required parameter 'tier_1_id' is set
      if @api_client.config.client_side_validation && tier_1_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_1_id' when calling PolicyNetworkingConnectivityTier1GatewaysARPProxiesApi.get_tier1_arp_proxies"
      end
      # verify the required parameter 'locale_service_id' is set
      if @api_client.config.client_side_validation && locale_service_id.nil?
        fail ArgumentError, "Missing the required parameter 'locale_service_id' when calling PolicyNetworkingConnectivityTier1GatewaysARPProxiesApi.get_tier1_arp_proxies"
      end
      if @api_client.config.client_side_validation && opts[:'source'] && !['realtime', 'cached'].include?(opts[:'source'])
        fail ArgumentError, 'invalid value for "source", must be one of realtime, cached'
      end
      # resource path
      local_var_path = '/infra/tier-1s/{tier-1-id}/locale-services/{locale-service-id}/arp-proxies'.sub('{' + 'tier-1-id' + '}', tier_1_id.to_s).sub('{' + 'locale-service-id' + '}', locale_service_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'enforcement_point_path'] = opts[:'enforcement_point_path'] if !opts[:'enforcement_point_path'].nil?
      query_params[:'source'] = opts[:'source'] if !opts[:'source'].nil?

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
        :return_type => 'PolicyArpProxyTableListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier1GatewaysARPProxiesApi#get_tier1_arp_proxies\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get Tier-1 Address Resolution Protocol Proxies
    # Returns ARP proxy table for a tier-1 
    # @param tier_1_id 
    # @param locale_service_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :source Data source type.
    # @return [PolicyArpProxyTableListResult]
    def get_tier1_arp_proxies_0(tier_1_id, locale_service_id, opts = {})
      data, _status_code, _headers = get_tier1_arp_proxies_0_with_http_info(tier_1_id, locale_service_id, opts)
      data
    end

    # Get Tier-1 Address Resolution Protocol Proxies
    # Returns ARP proxy table for a tier-1 
    # @param tier_1_id 
    # @param locale_service_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :source Data source type.
    # @return [Array<(PolicyArpProxyTableListResult, Fixnum, Hash)>] PolicyArpProxyTableListResult data, response status code and response headers
    def get_tier1_arp_proxies_0_with_http_info(tier_1_id, locale_service_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier1GatewaysARPProxiesApi.get_tier1_arp_proxies_0 ...'
      end
      # verify the required parameter 'tier_1_id' is set
      if @api_client.config.client_side_validation && tier_1_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_1_id' when calling PolicyNetworkingConnectivityTier1GatewaysARPProxiesApi.get_tier1_arp_proxies_0"
      end
      # verify the required parameter 'locale_service_id' is set
      if @api_client.config.client_side_validation && locale_service_id.nil?
        fail ArgumentError, "Missing the required parameter 'locale_service_id' when calling PolicyNetworkingConnectivityTier1GatewaysARPProxiesApi.get_tier1_arp_proxies_0"
      end
      if @api_client.config.client_side_validation && opts[:'source'] && !['realtime', 'cached'].include?(opts[:'source'])
        fail ArgumentError, 'invalid value for "source", must be one of realtime, cached'
      end
      # resource path
      local_var_path = '/global-infra/tier-1s/{tier-1-id}/locale-services/{locale-service-id}/arp-proxies'.sub('{' + 'tier-1-id' + '}', tier_1_id.to_s).sub('{' + 'locale-service-id' + '}', locale_service_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'enforcement_point_path'] = opts[:'enforcement_point_path'] if !opts[:'enforcement_point_path'].nil?
      query_params[:'source'] = opts[:'source'] if !opts[:'source'].nil?

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
        :return_type => 'PolicyArpProxyTableListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier1GatewaysARPProxiesApi#get_tier1_arp_proxies_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end