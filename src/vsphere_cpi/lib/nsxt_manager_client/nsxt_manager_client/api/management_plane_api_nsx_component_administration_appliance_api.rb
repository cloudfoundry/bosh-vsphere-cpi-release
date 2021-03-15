=begin
#NSX-T Manager API

#VMware NSX-T Manager REST API

OpenAPI spec version: 2.5.1.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'uri'

module NSXT
  class ManagementPlaneApiNsxComponentAdministrationApplianceApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # NodeMode
    # Currently only a switch from \"VMC_LOCAL\" to \"VMC\" is supported. Returns a new Node Mode, if the request successfuly changed it. 
    # @param switching_to_vmc_mode_parameters 
    # @param [Hash] opts the optional parameters
    # @return [NodeMode]
    def change_node_mode(switching_to_vmc_mode_parameters, opts = {})
      data, _status_code, _headers = change_node_mode_with_http_info(switching_to_vmc_mode_parameters, opts)
      data
    end

    # NodeMode
    # Currently only a switch from \&quot;VMC_LOCAL\&quot; to \&quot;VMC\&quot; is supported. Returns a new Node Mode, if the request successfuly changed it. 
    # @param switching_to_vmc_mode_parameters 
    # @param [Hash] opts the optional parameters
    # @return [Array<(NodeMode, Fixnum, Hash)>] NodeMode data, response status code and response headers
    def change_node_mode_with_http_info(switching_to_vmc_mode_parameters, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagementPlaneApiNsxComponentAdministrationApplianceApi.change_node_mode ...'
      end
      # verify the required parameter 'switching_to_vmc_mode_parameters' is set
      if @api_client.config.client_side_validation && switching_to_vmc_mode_parameters.nil?
        fail ArgumentError, "Missing the required parameter 'switching_to_vmc_mode_parameters' when calling ManagementPlaneApiNsxComponentAdministrationApplianceApi.change_node_mode"
      end
      # resource path
      local_var_path = '/configs/node/mode'

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
      post_body = @api_client.object_to_http_body(switching_to_vmc_mode_parameters)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'NodeMode')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagementPlaneApiNsxComponentAdministrationApplianceApi#change_node_mode\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # NodeMode
    # Returns current Node Mode. 
    # @param [Hash] opts the optional parameters
    # @return [NodeMode]
    def get_node_mode(opts = {})
      data, _status_code, _headers = get_node_mode_with_http_info(opts)
      data
    end

    # NodeMode
    # Returns current Node Mode. 
    # @param [Hash] opts the optional parameters
    # @return [Array<(NodeMode, Fixnum, Hash)>] NodeMode data, response status code and response headers
    def get_node_mode_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagementPlaneApiNsxComponentAdministrationApplianceApi.get_node_mode ...'
      end
      # resource path
      local_var_path = '/node/mode'

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
        :return_type => 'NodeMode')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagementPlaneApiNsxComponentAdministrationApplianceApi#get_node_mode\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Set the node system time
    # Set the node system time to the given time in UTC in the RFC3339 format 'yyyy-mm-ddThh:mm:ssZ'. 
    # @param node_time 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def set_node_time_set_system_time(node_time, opts = {})
      set_node_time_set_system_time_with_http_info(node_time, opts)
      nil
    end

    # Set the node system time
    # Set the node system time to the given time in UTC in the RFC3339 format &#39;yyyy-mm-ddThh:mm:ssZ&#39;. 
    # @param node_time 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def set_node_time_set_system_time_with_http_info(node_time, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagementPlaneApiNsxComponentAdministrationApplianceApi.set_node_time_set_system_time ...'
      end
      # verify the required parameter 'node_time' is set
      if @api_client.config.client_side_validation && node_time.nil?
        fail ArgumentError, "Missing the required parameter 'node_time' when calling ManagementPlaneApiNsxComponentAdministrationApplianceApi.set_node_time_set_system_time"
      end
      # resource path
      local_var_path = '/node?action=set_system_time'

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
      post_body = @api_client.object_to_http_body(node_time)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagementPlaneApiNsxComponentAdministrationApplianceApi#set_node_time_set_system_time\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
