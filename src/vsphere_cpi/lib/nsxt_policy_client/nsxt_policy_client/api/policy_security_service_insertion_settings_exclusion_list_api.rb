=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.17

=end

require 'uri'

module NSXTPolicy
  class PolicySecurityServiceInsertionSettingsExclusionListApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Read service insertion exclude list
    # Read exclude list for service insertion 
    # @param [Hash] opts the optional parameters
    # @return [PolicySIExcludeList]
    def get_si_exclude_list(opts = {})
      data, _status_code, _headers = get_si_exclude_list_with_http_info(opts)
      data
    end

    # Read service insertion exclude list
    # Read exclude list for service insertion 
    # @param [Hash] opts the optional parameters
    # @return [Array<(PolicySIExcludeList, Fixnum, Hash)>] PolicySIExcludeList data, response status code and response headers
    def get_si_exclude_list_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicySecurityServiceInsertionSettingsExclusionListApi.get_si_exclude_list ...'
      end
      # resource path
      local_var_path = '/infra/settings/service-insertion/security/exclude-list'

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
        :return_type => 'PolicySIExcludeList')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicySecurityServiceInsertionSettingsExclusionListApi#get_si_exclude_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Read service insertion exclude list
    # Read exclude list for service insertion 
    # @param [Hash] opts the optional parameters
    # @return [PolicySIExcludeList]
    def get_si_exclude_list_0(opts = {})
      data, _status_code, _headers = get_si_exclude_list_0_with_http_info(opts)
      data
    end

    # Read service insertion exclude list
    # Read exclude list for service insertion 
    # @param [Hash] opts the optional parameters
    # @return [Array<(PolicySIExcludeList, Fixnum, Hash)>] PolicySIExcludeList data, response status code and response headers
    def get_si_exclude_list_0_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicySecurityServiceInsertionSettingsExclusionListApi.get_si_exclude_list_0 ...'
      end
      # resource path
      local_var_path = '/global-infra/settings/service-insertion/security/exclude-list'

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
        :return_type => 'PolicySIExcludeList')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicySecurityServiceInsertionSettingsExclusionListApi#get_si_exclude_list_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Patch service insertion exclusion list for security policy
    # Patch service insertion exclusion list for security policy. 
    # @param policy_si_exclude_list 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def patch_si_exclude_list(policy_si_exclude_list, opts = {})
      patch_si_exclude_list_with_http_info(policy_si_exclude_list, opts)
      nil
    end

    # Patch service insertion exclusion list for security policy
    # Patch service insertion exclusion list for security policy. 
    # @param policy_si_exclude_list 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_si_exclude_list_with_http_info(policy_si_exclude_list, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicySecurityServiceInsertionSettingsExclusionListApi.patch_si_exclude_list ...'
      end
      # verify the required parameter 'policy_si_exclude_list' is set
      if @api_client.config.client_side_validation && policy_si_exclude_list.nil?
        fail ArgumentError, "Missing the required parameter 'policy_si_exclude_list' when calling PolicySecurityServiceInsertionSettingsExclusionListApi.patch_si_exclude_list"
      end
      # resource path
      local_var_path = '/infra/settings/service-insertion/security/exclude-list'

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
      post_body = @api_client.object_to_http_body(policy_si_exclude_list)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicySecurityServiceInsertionSettingsExclusionListApi#patch_si_exclude_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Patch service insertion exclusion list for security policy
    # Patch service insertion exclusion list for security policy. 
    # @param policy_si_exclude_list 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def patch_si_exclude_list_0(policy_si_exclude_list, opts = {})
      patch_si_exclude_list_0_with_http_info(policy_si_exclude_list, opts)
      nil
    end

    # Patch service insertion exclusion list for security policy
    # Patch service insertion exclusion list for security policy. 
    # @param policy_si_exclude_list 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_si_exclude_list_0_with_http_info(policy_si_exclude_list, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicySecurityServiceInsertionSettingsExclusionListApi.patch_si_exclude_list_0 ...'
      end
      # verify the required parameter 'policy_si_exclude_list' is set
      if @api_client.config.client_side_validation && policy_si_exclude_list.nil?
        fail ArgumentError, "Missing the required parameter 'policy_si_exclude_list' when calling PolicySecurityServiceInsertionSettingsExclusionListApi.patch_si_exclude_list_0"
      end
      # resource path
      local_var_path = '/global-infra/settings/service-insertion/security/exclude-list'

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
      post_body = @api_client.object_to_http_body(policy_si_exclude_list)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicySecurityServiceInsertionSettingsExclusionListApi#patch_si_exclude_list_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Update service insertion exclusion list
    # Update the exclusion list for service insertion policy 
    # @param policy_si_exclude_list 
    # @param [Hash] opts the optional parameters
    # @return [PolicySIExcludeList]
    def update_si_exclude_list(policy_si_exclude_list, opts = {})
      data, _status_code, _headers = update_si_exclude_list_with_http_info(policy_si_exclude_list, opts)
      data
    end

    # Update service insertion exclusion list
    # Update the exclusion list for service insertion policy 
    # @param policy_si_exclude_list 
    # @param [Hash] opts the optional parameters
    # @return [Array<(PolicySIExcludeList, Fixnum, Hash)>] PolicySIExcludeList data, response status code and response headers
    def update_si_exclude_list_with_http_info(policy_si_exclude_list, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicySecurityServiceInsertionSettingsExclusionListApi.update_si_exclude_list ...'
      end
      # verify the required parameter 'policy_si_exclude_list' is set
      if @api_client.config.client_side_validation && policy_si_exclude_list.nil?
        fail ArgumentError, "Missing the required parameter 'policy_si_exclude_list' when calling PolicySecurityServiceInsertionSettingsExclusionListApi.update_si_exclude_list"
      end
      # resource path
      local_var_path = '/infra/settings/service-insertion/security/exclude-list'

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
      post_body = @api_client.object_to_http_body(policy_si_exclude_list)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'PolicySIExcludeList')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicySecurityServiceInsertionSettingsExclusionListApi#update_si_exclude_list\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Update service insertion exclusion list
    # Update the exclusion list for service insertion policy 
    # @param policy_si_exclude_list 
    # @param [Hash] opts the optional parameters
    # @return [PolicySIExcludeList]
    def update_si_exclude_list_0(policy_si_exclude_list, opts = {})
      data, _status_code, _headers = update_si_exclude_list_0_with_http_info(policy_si_exclude_list, opts)
      data
    end

    # Update service insertion exclusion list
    # Update the exclusion list for service insertion policy 
    # @param policy_si_exclude_list 
    # @param [Hash] opts the optional parameters
    # @return [Array<(PolicySIExcludeList, Fixnum, Hash)>] PolicySIExcludeList data, response status code and response headers
    def update_si_exclude_list_0_with_http_info(policy_si_exclude_list, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicySecurityServiceInsertionSettingsExclusionListApi.update_si_exclude_list_0 ...'
      end
      # verify the required parameter 'policy_si_exclude_list' is set
      if @api_client.config.client_side_validation && policy_si_exclude_list.nil?
        fail ArgumentError, "Missing the required parameter 'policy_si_exclude_list' when calling PolicySecurityServiceInsertionSettingsExclusionListApi.update_si_exclude_list_0"
      end
      # resource path
      local_var_path = '/global-infra/settings/service-insertion/security/exclude-list'

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
      post_body = @api_client.object_to_http_body(policy_si_exclude_list)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'PolicySIExcludeList')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicySecurityServiceInsertionSettingsExclusionListApi#update_si_exclude_list_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
