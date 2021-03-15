=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'uri'

module NSXTPolicy
  class PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Delete LBMonitorProfile and all the entities contained by this LBMonitorProfile
    # Delete the LBMonitorProfile along with all the entities contained by this LBMonitorProfile. 
    # @param lb_monitor_profile_id LBMonitorProfile ID
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :force Force delete the resource even if it is being used somewhere  (default to false)
    # @return [nil]
    def delete_lb_monitor_profile(lb_monitor_profile_id, opts = {})
      delete_lb_monitor_profile_with_http_info(lb_monitor_profile_id, opts)
      nil
    end

    # Delete LBMonitorProfile and all the entities contained by this LBMonitorProfile
    # Delete the LBMonitorProfile along with all the entities contained by this LBMonitorProfile. 
    # @param lb_monitor_profile_id LBMonitorProfile ID
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :force Force delete the resource even if it is being used somewhere 
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def delete_lb_monitor_profile_with_http_info(lb_monitor_profile_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.delete_lb_monitor_profile ...'
      end
      # verify the required parameter 'lb_monitor_profile_id' is set
      if @api_client.config.client_side_validation && lb_monitor_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'lb_monitor_profile_id' when calling PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.delete_lb_monitor_profile"
      end
      # resource path
      local_var_path = '/global-infra/lb-monitor-profiles/{lb-monitor-profile-id}'.sub('{' + 'lb-monitor-profile-id' + '}', lb_monitor_profile_id.to_s)

      # query parameters
      query_params = {}
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
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi#delete_lb_monitor_profile\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete LBMonitorProfile and all the entities contained by this LBMonitorProfile
    # Delete the LBMonitorProfile along with all the entities contained by this LBMonitorProfile. 
    # @param lb_monitor_profile_id LBMonitorProfile ID
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :force Force delete the resource even if it is being used somewhere  (default to false)
    # @return [nil]
    def delete_lb_monitor_profile_0(lb_monitor_profile_id, opts = {})
      delete_lb_monitor_profile_0_with_http_info(lb_monitor_profile_id, opts)
      nil
    end

    # Delete LBMonitorProfile and all the entities contained by this LBMonitorProfile
    # Delete the LBMonitorProfile along with all the entities contained by this LBMonitorProfile. 
    # @param lb_monitor_profile_id LBMonitorProfile ID
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :force Force delete the resource even if it is being used somewhere 
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def delete_lb_monitor_profile_0_with_http_info(lb_monitor_profile_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.delete_lb_monitor_profile_0 ...'
      end
      # verify the required parameter 'lb_monitor_profile_id' is set
      if @api_client.config.client_side_validation && lb_monitor_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'lb_monitor_profile_id' when calling PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.delete_lb_monitor_profile_0"
      end
      # resource path
      local_var_path = '/infra/lb-monitor-profiles/{lb-monitor-profile-id}'.sub('{' + 'lb-monitor-profile-id' + '}', lb_monitor_profile_id.to_s)

      # query parameters
      query_params = {}
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
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi#delete_lb_monitor_profile_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List LBMonitorProfiles for infra
    # Paginated list of all LBMonitorProfiles for infra. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results (default to false)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [LBMonitorProfileListResult]
    def list_lb_monitor_profiles(opts = {})
      data, _status_code, _headers = list_lb_monitor_profiles_with_http_info(opts)
      data
    end

    # List LBMonitorProfiles for infra
    # Paginated list of all LBMonitorProfiles for infra. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(LBMonitorProfileListResult, Fixnum, Hash)>] LBMonitorProfileListResult data, response status code and response headers
    def list_lb_monitor_profiles_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.list_lb_monitor_profiles ...'
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.list_lb_monitor_profiles, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.list_lb_monitor_profiles, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/global-infra/lb-monitor-profiles'

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
        :return_type => 'LBMonitorProfileListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi#list_lb_monitor_profiles\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List LBMonitorProfiles for infra
    # Paginated list of all LBMonitorProfiles for infra. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results (default to false)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [LBMonitorProfileListResult]
    def list_lb_monitor_profiles_0(opts = {})
      data, _status_code, _headers = list_lb_monitor_profiles_0_with_http_info(opts)
      data
    end

    # List LBMonitorProfiles for infra
    # Paginated list of all LBMonitorProfiles for infra. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(LBMonitorProfileListResult, Fixnum, Hash)>] LBMonitorProfileListResult data, response status code and response headers
    def list_lb_monitor_profiles_0_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.list_lb_monitor_profiles_0 ...'
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.list_lb_monitor_profiles_0, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.list_lb_monitor_profiles_0, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/infra/lb-monitor-profiles'

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
        :return_type => 'LBMonitorProfileListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi#list_lb_monitor_profiles_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or update a LBMonitorProfile
    # If a LBMonitorProfile with the lb-monitor-profile-id is not already present, create a new LBMonitorProfile. If it already exists, update the LBMonitorProfile. This is a full replace. 
    # @param lb_monitor_profile_id LBMonitorProfile ID
    # @param lb_monitor_profile 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def patch_lb_monitor_profile(lb_monitor_profile_id, lb_monitor_profile, opts = {})
      patch_lb_monitor_profile_with_http_info(lb_monitor_profile_id, lb_monitor_profile, opts)
      nil
    end

    # Create or update a LBMonitorProfile
    # If a LBMonitorProfile with the lb-monitor-profile-id is not already present, create a new LBMonitorProfile. If it already exists, update the LBMonitorProfile. This is a full replace. 
    # @param lb_monitor_profile_id LBMonitorProfile ID
    # @param lb_monitor_profile 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_lb_monitor_profile_with_http_info(lb_monitor_profile_id, lb_monitor_profile, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.patch_lb_monitor_profile ...'
      end
      # verify the required parameter 'lb_monitor_profile_id' is set
      if @api_client.config.client_side_validation && lb_monitor_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'lb_monitor_profile_id' when calling PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.patch_lb_monitor_profile"
      end
      # verify the required parameter 'lb_monitor_profile' is set
      if @api_client.config.client_side_validation && lb_monitor_profile.nil?
        fail ArgumentError, "Missing the required parameter 'lb_monitor_profile' when calling PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.patch_lb_monitor_profile"
      end
      # resource path
      local_var_path = '/global-infra/lb-monitor-profiles/{lb-monitor-profile-id}'.sub('{' + 'lb-monitor-profile-id' + '}', lb_monitor_profile_id.to_s)

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
      post_body = @api_client.object_to_http_body(lb_monitor_profile)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi#patch_lb_monitor_profile\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or update a LBMonitorProfile
    # If a LBMonitorProfile with the lb-monitor-profile-id is not already present, create a new LBMonitorProfile. If it already exists, update the LBMonitorProfile. This is a full replace. 
    # @param lb_monitor_profile_id LBMonitorProfile ID
    # @param lb_monitor_profile 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def patch_lb_monitor_profile_0(lb_monitor_profile_id, lb_monitor_profile, opts = {})
      patch_lb_monitor_profile_0_with_http_info(lb_monitor_profile_id, lb_monitor_profile, opts)
      nil
    end

    # Create or update a LBMonitorProfile
    # If a LBMonitorProfile with the lb-monitor-profile-id is not already present, create a new LBMonitorProfile. If it already exists, update the LBMonitorProfile. This is a full replace. 
    # @param lb_monitor_profile_id LBMonitorProfile ID
    # @param lb_monitor_profile 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_lb_monitor_profile_0_with_http_info(lb_monitor_profile_id, lb_monitor_profile, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.patch_lb_monitor_profile_0 ...'
      end
      # verify the required parameter 'lb_monitor_profile_id' is set
      if @api_client.config.client_side_validation && lb_monitor_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'lb_monitor_profile_id' when calling PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.patch_lb_monitor_profile_0"
      end
      # verify the required parameter 'lb_monitor_profile' is set
      if @api_client.config.client_side_validation && lb_monitor_profile.nil?
        fail ArgumentError, "Missing the required parameter 'lb_monitor_profile' when calling PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.patch_lb_monitor_profile_0"
      end
      # resource path
      local_var_path = '/infra/lb-monitor-profiles/{lb-monitor-profile-id}'.sub('{' + 'lb-monitor-profile-id' + '}', lb_monitor_profile_id.to_s)

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
      post_body = @api_client.object_to_http_body(lb_monitor_profile)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi#patch_lb_monitor_profile_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Read LBMonitorProfile
    # Read a LBMonitorProfile. 
    # @param lb_monitor_profile_id LBMonitorProfile ID
    # @param [Hash] opts the optional parameters
    # @return [LBMonitorProfile]
    def read_lb_monitor_profile(lb_monitor_profile_id, opts = {})
      data, _status_code, _headers = read_lb_monitor_profile_with_http_info(lb_monitor_profile_id, opts)
      data
    end

    # Read LBMonitorProfile
    # Read a LBMonitorProfile. 
    # @param lb_monitor_profile_id LBMonitorProfile ID
    # @param [Hash] opts the optional parameters
    # @return [Array<(LBMonitorProfile, Fixnum, Hash)>] LBMonitorProfile data, response status code and response headers
    def read_lb_monitor_profile_with_http_info(lb_monitor_profile_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.read_lb_monitor_profile ...'
      end
      # verify the required parameter 'lb_monitor_profile_id' is set
      if @api_client.config.client_side_validation && lb_monitor_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'lb_monitor_profile_id' when calling PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.read_lb_monitor_profile"
      end
      # resource path
      local_var_path = '/global-infra/lb-monitor-profiles/{lb-monitor-profile-id}'.sub('{' + 'lb-monitor-profile-id' + '}', lb_monitor_profile_id.to_s)

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
        :return_type => 'LBMonitorProfile')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi#read_lb_monitor_profile\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Read LBMonitorProfile
    # Read a LBMonitorProfile. 
    # @param lb_monitor_profile_id LBMonitorProfile ID
    # @param [Hash] opts the optional parameters
    # @return [LBMonitorProfile]
    def read_lb_monitor_profile_0(lb_monitor_profile_id, opts = {})
      data, _status_code, _headers = read_lb_monitor_profile_0_with_http_info(lb_monitor_profile_id, opts)
      data
    end

    # Read LBMonitorProfile
    # Read a LBMonitorProfile. 
    # @param lb_monitor_profile_id LBMonitorProfile ID
    # @param [Hash] opts the optional parameters
    # @return [Array<(LBMonitorProfile, Fixnum, Hash)>] LBMonitorProfile data, response status code and response headers
    def read_lb_monitor_profile_0_with_http_info(lb_monitor_profile_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.read_lb_monitor_profile_0 ...'
      end
      # verify the required parameter 'lb_monitor_profile_id' is set
      if @api_client.config.client_side_validation && lb_monitor_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'lb_monitor_profile_id' when calling PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.read_lb_monitor_profile_0"
      end
      # resource path
      local_var_path = '/infra/lb-monitor-profiles/{lb-monitor-profile-id}'.sub('{' + 'lb-monitor-profile-id' + '}', lb_monitor_profile_id.to_s)

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
        :return_type => 'LBMonitorProfile')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi#read_lb_monitor_profile_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or update a LBMonitorProfile
    # If a LBMonitorProfile with the lb-monitor-profile-id is not already present, create a new LBMonitorProfile. If it already exists, update the LBMonitorProfile. This is a full replace. 
    # @param lb_monitor_profile_id LBMonitorProfile ID
    # @param lb_monitor_profile 
    # @param [Hash] opts the optional parameters
    # @return [LBMonitorProfile]
    def update_lb_monitor_profile(lb_monitor_profile_id, lb_monitor_profile, opts = {})
      data, _status_code, _headers = update_lb_monitor_profile_with_http_info(lb_monitor_profile_id, lb_monitor_profile, opts)
      data
    end

    # Create or update a LBMonitorProfile
    # If a LBMonitorProfile with the lb-monitor-profile-id is not already present, create a new LBMonitorProfile. If it already exists, update the LBMonitorProfile. This is a full replace. 
    # @param lb_monitor_profile_id LBMonitorProfile ID
    # @param lb_monitor_profile 
    # @param [Hash] opts the optional parameters
    # @return [Array<(LBMonitorProfile, Fixnum, Hash)>] LBMonitorProfile data, response status code and response headers
    def update_lb_monitor_profile_with_http_info(lb_monitor_profile_id, lb_monitor_profile, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.update_lb_monitor_profile ...'
      end
      # verify the required parameter 'lb_monitor_profile_id' is set
      if @api_client.config.client_side_validation && lb_monitor_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'lb_monitor_profile_id' when calling PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.update_lb_monitor_profile"
      end
      # verify the required parameter 'lb_monitor_profile' is set
      if @api_client.config.client_side_validation && lb_monitor_profile.nil?
        fail ArgumentError, "Missing the required parameter 'lb_monitor_profile' when calling PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.update_lb_monitor_profile"
      end
      # resource path
      local_var_path = '/global-infra/lb-monitor-profiles/{lb-monitor-profile-id}'.sub('{' + 'lb-monitor-profile-id' + '}', lb_monitor_profile_id.to_s)

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
      post_body = @api_client.object_to_http_body(lb_monitor_profile)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'LBMonitorProfile')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi#update_lb_monitor_profile\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or update a LBMonitorProfile
    # If a LBMonitorProfile with the lb-monitor-profile-id is not already present, create a new LBMonitorProfile. If it already exists, update the LBMonitorProfile. This is a full replace. 
    # @param lb_monitor_profile_id LBMonitorProfile ID
    # @param lb_monitor_profile 
    # @param [Hash] opts the optional parameters
    # @return [LBMonitorProfile]
    def update_lb_monitor_profile_0(lb_monitor_profile_id, lb_monitor_profile, opts = {})
      data, _status_code, _headers = update_lb_monitor_profile_0_with_http_info(lb_monitor_profile_id, lb_monitor_profile, opts)
      data
    end

    # Create or update a LBMonitorProfile
    # If a LBMonitorProfile with the lb-monitor-profile-id is not already present, create a new LBMonitorProfile. If it already exists, update the LBMonitorProfile. This is a full replace. 
    # @param lb_monitor_profile_id LBMonitorProfile ID
    # @param lb_monitor_profile 
    # @param [Hash] opts the optional parameters
    # @return [Array<(LBMonitorProfile, Fixnum, Hash)>] LBMonitorProfile data, response status code and response headers
    def update_lb_monitor_profile_0_with_http_info(lb_monitor_profile_id, lb_monitor_profile, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.update_lb_monitor_profile_0 ...'
      end
      # verify the required parameter 'lb_monitor_profile_id' is set
      if @api_client.config.client_side_validation && lb_monitor_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'lb_monitor_profile_id' when calling PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.update_lb_monitor_profile_0"
      end
      # verify the required parameter 'lb_monitor_profile' is set
      if @api_client.config.client_side_validation && lb_monitor_profile.nil?
        fail ArgumentError, "Missing the required parameter 'lb_monitor_profile' when calling PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi.update_lb_monitor_profile_0"
      end
      # resource path
      local_var_path = '/infra/lb-monitor-profiles/{lb-monitor-profile-id}'.sub('{' + 'lb-monitor-profile-id' + '}', lb_monitor_profile_id.to_s)

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
      post_body = @api_client.object_to_http_body(lb_monitor_profile)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'LBMonitorProfile')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerProfilesLoadBalancerMonitorProfilesApi#update_lb_monitor_profile_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
