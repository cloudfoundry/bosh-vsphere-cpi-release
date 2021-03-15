=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'uri'

module NSXTPolicy
  class PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Create or Update evpn configuration
    # Create or update evpn configuration. 
    # @param tier_0_id tier0 id
    # @param evpn_config 
    # @param [Hash] opts the optional parameters
    # @return [EvpnConfig]
    def create_or_update_evpn_config(tier_0_id, evpn_config, opts = {})
      data, _status_code, _headers = create_or_update_evpn_config_with_http_info(tier_0_id, evpn_config, opts)
      data
    end

    # Create or Update evpn configuration
    # Create or update evpn configuration. 
    # @param tier_0_id tier0 id
    # @param evpn_config 
    # @param [Hash] opts the optional parameters
    # @return [Array<(EvpnConfig, Fixnum, Hash)>] EvpnConfig data, response status code and response headers
    def create_or_update_evpn_config_with_http_info(tier_0_id, evpn_config, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi.create_or_update_evpn_config ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi.create_or_update_evpn_config"
      end
      # verify the required parameter 'evpn_config' is set
      if @api_client.config.client_side_validation && evpn_config.nil?
        fail ArgumentError, "Missing the required parameter 'evpn_config' when calling PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi.create_or_update_evpn_config"
      end
      # resource path
      local_var_path = '/infra/tier-0s/{tier-0-id}/evpn'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s)

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
      post_body = @api_client.object_to_http_body(evpn_config)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'EvpnConfig')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi#create_or_update_evpn_config\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or Update evpn configuration
    # Create or update evpn configuration. 
    # @param tier_0_id tier0 id
    # @param evpn_config 
    # @param [Hash] opts the optional parameters
    # @return [EvpnConfig]
    def create_or_update_evpn_config_0(tier_0_id, evpn_config, opts = {})
      data, _status_code, _headers = create_or_update_evpn_config_0_with_http_info(tier_0_id, evpn_config, opts)
      data
    end

    # Create or Update evpn configuration
    # Create or update evpn configuration. 
    # @param tier_0_id tier0 id
    # @param evpn_config 
    # @param [Hash] opts the optional parameters
    # @return [Array<(EvpnConfig, Fixnum, Hash)>] EvpnConfig data, response status code and response headers
    def create_or_update_evpn_config_0_with_http_info(tier_0_id, evpn_config, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi.create_or_update_evpn_config_0 ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi.create_or_update_evpn_config_0"
      end
      # verify the required parameter 'evpn_config' is set
      if @api_client.config.client_side_validation && evpn_config.nil?
        fail ArgumentError, "Missing the required parameter 'evpn_config' when calling PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi.create_or_update_evpn_config_0"
      end
      # resource path
      local_var_path = '/global-infra/tier-0s/{tier-0-id}/evpn'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s)

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
      post_body = @api_client.object_to_http_body(evpn_config)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'EvpnConfig')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi#create_or_update_evpn_config_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or Update evpn configuration
    # Create a evpn configuration if it is not already present, otherwise update the evpn configuration. 
    # @param tier_0_id tier0 id
    # @param evpn_config 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def patch_evpn_config(tier_0_id, evpn_config, opts = {})
      patch_evpn_config_with_http_info(tier_0_id, evpn_config, opts)
      nil
    end

    # Create or Update evpn configuration
    # Create a evpn configuration if it is not already present, otherwise update the evpn configuration. 
    # @param tier_0_id tier0 id
    # @param evpn_config 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_evpn_config_with_http_info(tier_0_id, evpn_config, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi.patch_evpn_config ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi.patch_evpn_config"
      end
      # verify the required parameter 'evpn_config' is set
      if @api_client.config.client_side_validation && evpn_config.nil?
        fail ArgumentError, "Missing the required parameter 'evpn_config' when calling PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi.patch_evpn_config"
      end
      # resource path
      local_var_path = '/infra/tier-0s/{tier-0-id}/evpn'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s)

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
      post_body = @api_client.object_to_http_body(evpn_config)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi#patch_evpn_config\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or Update evpn configuration
    # Create a evpn configuration if it is not already present, otherwise update the evpn configuration. 
    # @param tier_0_id tier0 id
    # @param evpn_config 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def patch_evpn_config_0(tier_0_id, evpn_config, opts = {})
      patch_evpn_config_0_with_http_info(tier_0_id, evpn_config, opts)
      nil
    end

    # Create or Update evpn configuration
    # Create a evpn configuration if it is not already present, otherwise update the evpn configuration. 
    # @param tier_0_id tier0 id
    # @param evpn_config 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_evpn_config_0_with_http_info(tier_0_id, evpn_config, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi.patch_evpn_config_0 ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi.patch_evpn_config_0"
      end
      # verify the required parameter 'evpn_config' is set
      if @api_client.config.client_side_validation && evpn_config.nil?
        fail ArgumentError, "Missing the required parameter 'evpn_config' when calling PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi.patch_evpn_config_0"
      end
      # resource path
      local_var_path = '/global-infra/tier-0s/{tier-0-id}/evpn'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s)

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
      post_body = @api_client.object_to_http_body(evpn_config)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi#patch_evpn_config_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Read Evpn Configuration
    # Read Evpn Configuration. 
    # @param tier_0_id tier0 id
    # @param [Hash] opts the optional parameters
    # @return [EvpnConfig]
    def read_evpn_config(tier_0_id, opts = {})
      data, _status_code, _headers = read_evpn_config_with_http_info(tier_0_id, opts)
      data
    end

    # Read Evpn Configuration
    # Read Evpn Configuration. 
    # @param tier_0_id tier0 id
    # @param [Hash] opts the optional parameters
    # @return [Array<(EvpnConfig, Fixnum, Hash)>] EvpnConfig data, response status code and response headers
    def read_evpn_config_with_http_info(tier_0_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi.read_evpn_config ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi.read_evpn_config"
      end
      # resource path
      local_var_path = '/infra/tier-0s/{tier-0-id}/evpn'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s)

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
        :return_type => 'EvpnConfig')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi#read_evpn_config\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Read Evpn Configuration
    # Read Evpn Configuration. 
    # @param tier_0_id tier0 id
    # @param [Hash] opts the optional parameters
    # @return [EvpnConfig]
    def read_evpn_config_0(tier_0_id, opts = {})
      data, _status_code, _headers = read_evpn_config_0_with_http_info(tier_0_id, opts)
      data
    end

    # Read Evpn Configuration
    # Read Evpn Configuration. 
    # @param tier_0_id tier0 id
    # @param [Hash] opts the optional parameters
    # @return [Array<(EvpnConfig, Fixnum, Hash)>] EvpnConfig data, response status code and response headers
    def read_evpn_config_0_with_http_info(tier_0_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi.read_evpn_config_0 ...'
      end
      # verify the required parameter 'tier_0_id' is set
      if @api_client.config.client_side_validation && tier_0_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_0_id' when calling PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi.read_evpn_config_0"
      end
      # resource path
      local_var_path = '/global-infra/tier-0s/{tier-0-id}/evpn'.sub('{' + 'tier-0-id' + '}', tier_0_id.to_s)

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
        :return_type => 'EvpnConfig')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivityTier0GatewaysEVPNSettingEVPNConfigurationApi#read_evpn_config_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
