=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'uri'

module NSXTPolicy
  class PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Create or Replace QoS profile.
    # Create or Replace QoS profile. 
    # @param qos_profile_id QoS profile Id
    # @param qo_s_profile 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object (default to false)
    # @return [QoSProfile]
    def create_or_replace_qo_s_profile(qos_profile_id, qo_s_profile, opts = {})
      data, _status_code, _headers = create_or_replace_qo_s_profile_with_http_info(qos_profile_id, qo_s_profile, opts)
      data
    end

    # Create or Replace QoS profile.
    # Create or Replace QoS profile. 
    # @param qos_profile_id QoS profile Id
    # @param qo_s_profile 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object
    # @return [Array<(QoSProfile, Fixnum, Hash)>] QoSProfile data, response status code and response headers
    def create_or_replace_qo_s_profile_with_http_info(qos_profile_id, qo_s_profile, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.create_or_replace_qo_s_profile ...'
      end
      # verify the required parameter 'qos_profile_id' is set
      if @api_client.config.client_side_validation && qos_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'qos_profile_id' when calling PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.create_or_replace_qo_s_profile"
      end
      # verify the required parameter 'qo_s_profile' is set
      if @api_client.config.client_side_validation && qo_s_profile.nil?
        fail ArgumentError, "Missing the required parameter 'qo_s_profile' when calling PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.create_or_replace_qo_s_profile"
      end
      # resource path
      local_var_path = '/global-infra/qos-profiles/{qos-profile-id}'.sub('{' + 'qos-profile-id' + '}', qos_profile_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'override'] = opts[:'override'] if !opts[:'override'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(qo_s_profile)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'QoSProfile')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi#create_or_replace_qo_s_profile\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or Replace QoS profile.
    # Create or Replace QoS profile. 
    # @param qos_profile_id QoS profile Id
    # @param qo_s_profile 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object (default to false)
    # @return [QoSProfile]
    def create_or_replace_qo_s_profile_0(qos_profile_id, qo_s_profile, opts = {})
      data, _status_code, _headers = create_or_replace_qo_s_profile_0_with_http_info(qos_profile_id, qo_s_profile, opts)
      data
    end

    # Create or Replace QoS profile.
    # Create or Replace QoS profile. 
    # @param qos_profile_id QoS profile Id
    # @param qo_s_profile 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object
    # @return [Array<(QoSProfile, Fixnum, Hash)>] QoSProfile data, response status code and response headers
    def create_or_replace_qo_s_profile_0_with_http_info(qos_profile_id, qo_s_profile, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.create_or_replace_qo_s_profile_0 ...'
      end
      # verify the required parameter 'qos_profile_id' is set
      if @api_client.config.client_side_validation && qos_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'qos_profile_id' when calling PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.create_or_replace_qo_s_profile_0"
      end
      # verify the required parameter 'qo_s_profile' is set
      if @api_client.config.client_side_validation && qo_s_profile.nil?
        fail ArgumentError, "Missing the required parameter 'qo_s_profile' when calling PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.create_or_replace_qo_s_profile_0"
      end
      # resource path
      local_var_path = '/infra/qos-profiles/{qos-profile-id}'.sub('{' + 'qos-profile-id' + '}', qos_profile_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'override'] = opts[:'override'] if !opts[:'override'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(qo_s_profile)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'QoSProfile')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi#create_or_replace_qo_s_profile_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete QoS profile
    # API will delete QoS profile. 
    # @param qos_profile_id QoS profile Id
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object (default to false)
    # @return [nil]
    def delete_qo_s_profile(qos_profile_id, opts = {})
      delete_qo_s_profile_with_http_info(qos_profile_id, opts)
      nil
    end

    # Delete QoS profile
    # API will delete QoS profile. 
    # @param qos_profile_id QoS profile Id
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def delete_qo_s_profile_with_http_info(qos_profile_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.delete_qo_s_profile ...'
      end
      # verify the required parameter 'qos_profile_id' is set
      if @api_client.config.client_side_validation && qos_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'qos_profile_id' when calling PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.delete_qo_s_profile"
      end
      # resource path
      local_var_path = '/global-infra/qos-profiles/{qos-profile-id}'.sub('{' + 'qos-profile-id' + '}', qos_profile_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'override'] = opts[:'override'] if !opts[:'override'].nil?

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
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi#delete_qo_s_profile\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete QoS profile
    # API will delete QoS profile. 
    # @param qos_profile_id QoS profile Id
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object (default to false)
    # @return [nil]
    def delete_qo_s_profile_0(qos_profile_id, opts = {})
      delete_qo_s_profile_0_with_http_info(qos_profile_id, opts)
      nil
    end

    # Delete QoS profile
    # API will delete QoS profile. 
    # @param qos_profile_id QoS profile Id
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def delete_qo_s_profile_0_with_http_info(qos_profile_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.delete_qo_s_profile_0 ...'
      end
      # verify the required parameter 'qos_profile_id' is set
      if @api_client.config.client_side_validation && qos_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'qos_profile_id' when calling PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.delete_qo_s_profile_0"
      end
      # resource path
      local_var_path = '/infra/qos-profiles/{qos-profile-id}'.sub('{' + 'qos-profile-id' + '}', qos_profile_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'override'] = opts[:'override'] if !opts[:'override'].nil?

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
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi#delete_qo_s_profile_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List QoS Profiles
    # API will list all QoS profiles. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [QoSProfileListResult]
    def list_qo_s_profiles(opts = {})
      data, _status_code, _headers = list_qo_s_profiles_with_http_info(opts)
      data
    end

    # List QoS Profiles
    # API will list all QoS profiles. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(QoSProfileListResult, Fixnum, Hash)>] QoSProfileListResult data, response status code and response headers
    def list_qo_s_profiles_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.list_qo_s_profiles ...'
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.list_qo_s_profiles, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.list_qo_s_profiles, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/global-infra/qos-profiles'

      # query parameters
      query_params = {}
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
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
        :return_type => 'QoSProfileListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi#list_qo_s_profiles\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List QoS Profiles
    # API will list all QoS profiles. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [QoSProfileListResult]
    def list_qo_s_profiles_0(opts = {})
      data, _status_code, _headers = list_qo_s_profiles_0_with_http_info(opts)
      data
    end

    # List QoS Profiles
    # API will list all QoS profiles. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(QoSProfileListResult, Fixnum, Hash)>] QoSProfileListResult data, response status code and response headers
    def list_qo_s_profiles_0_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.list_qo_s_profiles_0 ...'
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.list_qo_s_profiles_0, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.list_qo_s_profiles_0, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/infra/qos-profiles'

      # query parameters
      query_params = {}
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
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
        :return_type => 'QoSProfileListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi#list_qo_s_profiles_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Patch QoS profile.
    # Create a new QoS profile if the QoS profile with given id does not already exist. If the QoS profile with the given id already exists, patch with the existing QoS profile. 
    # @param qos_profile_id QoS profile Id
    # @param qo_s_profile 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object (default to false)
    # @return [nil]
    def patch_qo_s_profile(qos_profile_id, qo_s_profile, opts = {})
      patch_qo_s_profile_with_http_info(qos_profile_id, qo_s_profile, opts)
      nil
    end

    # Patch QoS profile.
    # Create a new QoS profile if the QoS profile with given id does not already exist. If the QoS profile with the given id already exists, patch with the existing QoS profile. 
    # @param qos_profile_id QoS profile Id
    # @param qo_s_profile 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_qo_s_profile_with_http_info(qos_profile_id, qo_s_profile, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.patch_qo_s_profile ...'
      end
      # verify the required parameter 'qos_profile_id' is set
      if @api_client.config.client_side_validation && qos_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'qos_profile_id' when calling PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.patch_qo_s_profile"
      end
      # verify the required parameter 'qo_s_profile' is set
      if @api_client.config.client_side_validation && qo_s_profile.nil?
        fail ArgumentError, "Missing the required parameter 'qo_s_profile' when calling PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.patch_qo_s_profile"
      end
      # resource path
      local_var_path = '/global-infra/qos-profiles/{qos-profile-id}'.sub('{' + 'qos-profile-id' + '}', qos_profile_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'override'] = opts[:'override'] if !opts[:'override'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(qo_s_profile)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi#patch_qo_s_profile\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Patch QoS profile.
    # Create a new QoS profile if the QoS profile with given id does not already exist. If the QoS profile with the given id already exists, patch with the existing QoS profile. 
    # @param qos_profile_id QoS profile Id
    # @param qo_s_profile 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object (default to false)
    # @return [nil]
    def patch_qo_s_profile_0(qos_profile_id, qo_s_profile, opts = {})
      patch_qo_s_profile_0_with_http_info(qos_profile_id, qo_s_profile, opts)
      nil
    end

    # Patch QoS profile.
    # Create a new QoS profile if the QoS profile with given id does not already exist. If the QoS profile with the given id already exists, patch with the existing QoS profile. 
    # @param qos_profile_id QoS profile Id
    # @param qo_s_profile 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_qo_s_profile_0_with_http_info(qos_profile_id, qo_s_profile, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.patch_qo_s_profile_0 ...'
      end
      # verify the required parameter 'qos_profile_id' is set
      if @api_client.config.client_side_validation && qos_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'qos_profile_id' when calling PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.patch_qo_s_profile_0"
      end
      # verify the required parameter 'qo_s_profile' is set
      if @api_client.config.client_side_validation && qo_s_profile.nil?
        fail ArgumentError, "Missing the required parameter 'qo_s_profile' when calling PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.patch_qo_s_profile_0"
      end
      # resource path
      local_var_path = '/infra/qos-profiles/{qos-profile-id}'.sub('{' + 'qos-profile-id' + '}', qos_profile_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'override'] = opts[:'override'] if !opts[:'override'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(qo_s_profile)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi#patch_qo_s_profile_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Details of QoS profile 
    # API will return details of QoS profile. 
    # @param qos_profile_id QoS profile Id
    # @param [Hash] opts the optional parameters
    # @return [QoSProfile]
    def read_qo_s_profile(qos_profile_id, opts = {})
      data, _status_code, _headers = read_qo_s_profile_with_http_info(qos_profile_id, opts)
      data
    end

    # Details of QoS profile 
    # API will return details of QoS profile. 
    # @param qos_profile_id QoS profile Id
    # @param [Hash] opts the optional parameters
    # @return [Array<(QoSProfile, Fixnum, Hash)>] QoSProfile data, response status code and response headers
    def read_qo_s_profile_with_http_info(qos_profile_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.read_qo_s_profile ...'
      end
      # verify the required parameter 'qos_profile_id' is set
      if @api_client.config.client_side_validation && qos_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'qos_profile_id' when calling PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.read_qo_s_profile"
      end
      # resource path
      local_var_path = '/global-infra/qos-profiles/{qos-profile-id}'.sub('{' + 'qos-profile-id' + '}', qos_profile_id.to_s)

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
        :return_type => 'QoSProfile')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi#read_qo_s_profile\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Details of QoS profile 
    # API will return details of QoS profile. 
    # @param qos_profile_id QoS profile Id
    # @param [Hash] opts the optional parameters
    # @return [QoSProfile]
    def read_qo_s_profile_0(qos_profile_id, opts = {})
      data, _status_code, _headers = read_qo_s_profile_0_with_http_info(qos_profile_id, opts)
      data
    end

    # Details of QoS profile 
    # API will return details of QoS profile. 
    # @param qos_profile_id QoS profile Id
    # @param [Hash] opts the optional parameters
    # @return [Array<(QoSProfile, Fixnum, Hash)>] QoSProfile data, response status code and response headers
    def read_qo_s_profile_0_with_http_info(qos_profile_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.read_qo_s_profile_0 ...'
      end
      # verify the required parameter 'qos_profile_id' is set
      if @api_client.config.client_side_validation && qos_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'qos_profile_id' when calling PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi.read_qo_s_profile_0"
      end
      # resource path
      local_var_path = '/infra/qos-profiles/{qos-profile-id}'.sub('{' + 'qos-profile-id' + '}', qos_profile_id.to_s)

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
        :return_type => 'QoSProfile')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivitySegmentsSegmentProfilesQOSProfilesApi#read_qo_s_profile_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
