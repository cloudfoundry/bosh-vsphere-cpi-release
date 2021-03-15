=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'uri'

module NSXTPolicy
  class PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Create or update IPv6 DAD profile
    # If profile with the dad-profile-id is not already present, create a new IPv6 DAD profile instance. If it already exists, replace the IPv6 DAD profile instance with this object. 
    # @param dad_profile_id 
    # @param ipv6_dad_profile 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object (default to false)
    # @return [Ipv6DadProfile]
    def create_or_replace_ipv6_dad_profile(dad_profile_id, ipv6_dad_profile, opts = {})
      data, _status_code, _headers = create_or_replace_ipv6_dad_profile_with_http_info(dad_profile_id, ipv6_dad_profile, opts)
      data
    end

    # Create or update IPv6 DAD profile
    # If profile with the dad-profile-id is not already present, create a new IPv6 DAD profile instance. If it already exists, replace the IPv6 DAD profile instance with this object. 
    # @param dad_profile_id 
    # @param ipv6_dad_profile 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object
    # @return [Array<(Ipv6DadProfile, Fixnum, Hash)>] Ipv6DadProfile data, response status code and response headers
    def create_or_replace_ipv6_dad_profile_with_http_info(dad_profile_id, ipv6_dad_profile, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.create_or_replace_ipv6_dad_profile ...'
      end
      # verify the required parameter 'dad_profile_id' is set
      if @api_client.config.client_side_validation && dad_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'dad_profile_id' when calling PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.create_or_replace_ipv6_dad_profile"
      end
      # verify the required parameter 'ipv6_dad_profile' is set
      if @api_client.config.client_side_validation && ipv6_dad_profile.nil?
        fail ArgumentError, "Missing the required parameter 'ipv6_dad_profile' when calling PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.create_or_replace_ipv6_dad_profile"
      end
      # resource path
      local_var_path = '/infra/ipv6-dad-profiles/{dad-profile-id}'.sub('{' + 'dad-profile-id' + '}', dad_profile_id.to_s)

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
      post_body = @api_client.object_to_http_body(ipv6_dad_profile)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'Ipv6DadProfile')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi#create_or_replace_ipv6_dad_profile\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or update IPv6 DAD profile
    # If profile with the dad-profile-id is not already present, create a new IPv6 DAD profile instance. If it already exists, replace the IPv6 DAD profile instance with this object. 
    # @param dad_profile_id 
    # @param ipv6_dad_profile 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object (default to false)
    # @return [Ipv6DadProfile]
    def create_or_replace_ipv6_dad_profile_0(dad_profile_id, ipv6_dad_profile, opts = {})
      data, _status_code, _headers = create_or_replace_ipv6_dad_profile_0_with_http_info(dad_profile_id, ipv6_dad_profile, opts)
      data
    end

    # Create or update IPv6 DAD profile
    # If profile with the dad-profile-id is not already present, create a new IPv6 DAD profile instance. If it already exists, replace the IPv6 DAD profile instance with this object. 
    # @param dad_profile_id 
    # @param ipv6_dad_profile 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object
    # @return [Array<(Ipv6DadProfile, Fixnum, Hash)>] Ipv6DadProfile data, response status code and response headers
    def create_or_replace_ipv6_dad_profile_0_with_http_info(dad_profile_id, ipv6_dad_profile, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.create_or_replace_ipv6_dad_profile_0 ...'
      end
      # verify the required parameter 'dad_profile_id' is set
      if @api_client.config.client_side_validation && dad_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'dad_profile_id' when calling PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.create_or_replace_ipv6_dad_profile_0"
      end
      # verify the required parameter 'ipv6_dad_profile' is set
      if @api_client.config.client_side_validation && ipv6_dad_profile.nil?
        fail ArgumentError, "Missing the required parameter 'ipv6_dad_profile' when calling PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.create_or_replace_ipv6_dad_profile_0"
      end
      # resource path
      local_var_path = '/global-infra/ipv6-dad-profiles/{dad-profile-id}'.sub('{' + 'dad-profile-id' + '}', dad_profile_id.to_s)

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
      post_body = @api_client.object_to_http_body(ipv6_dad_profile)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'Ipv6DadProfile')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi#create_or_replace_ipv6_dad_profile_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete IPv6 DAD profile
    # Delete IPv6 DAD profile
    # @param dad_profile_id 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object (default to false)
    # @return [nil]
    def delete_ipv6_dad_profile(dad_profile_id, opts = {})
      delete_ipv6_dad_profile_with_http_info(dad_profile_id, opts)
      nil
    end

    # Delete IPv6 DAD profile
    # Delete IPv6 DAD profile
    # @param dad_profile_id 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def delete_ipv6_dad_profile_with_http_info(dad_profile_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.delete_ipv6_dad_profile ...'
      end
      # verify the required parameter 'dad_profile_id' is set
      if @api_client.config.client_side_validation && dad_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'dad_profile_id' when calling PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.delete_ipv6_dad_profile"
      end
      # resource path
      local_var_path = '/infra/ipv6-dad-profiles/{dad-profile-id}'.sub('{' + 'dad-profile-id' + '}', dad_profile_id.to_s)

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
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi#delete_ipv6_dad_profile\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete IPv6 DAD profile
    # Delete IPv6 DAD profile
    # @param dad_profile_id 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object (default to false)
    # @return [nil]
    def delete_ipv6_dad_profile_0(dad_profile_id, opts = {})
      delete_ipv6_dad_profile_0_with_http_info(dad_profile_id, opts)
      nil
    end

    # Delete IPv6 DAD profile
    # Delete IPv6 DAD profile
    # @param dad_profile_id 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def delete_ipv6_dad_profile_0_with_http_info(dad_profile_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.delete_ipv6_dad_profile_0 ...'
      end
      # verify the required parameter 'dad_profile_id' is set
      if @api_client.config.client_side_validation && dad_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'dad_profile_id' when calling PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.delete_ipv6_dad_profile_0"
      end
      # resource path
      local_var_path = '/global-infra/ipv6-dad-profiles/{dad-profile-id}'.sub('{' + 'dad-profile-id' + '}', dad_profile_id.to_s)

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
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi#delete_ipv6_dad_profile_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List all IPv6 DAD profiles
    # Paginated list of all IPv6 DAD profile instances 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results (default to false)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Ipv6DadProfileListResult]
    def list_ipv6_dad_profiles(opts = {})
      data, _status_code, _headers = list_ipv6_dad_profiles_with_http_info(opts)
      data
    end

    # List all IPv6 DAD profiles
    # Paginated list of all IPv6 DAD profile instances 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(Ipv6DadProfileListResult, Fixnum, Hash)>] Ipv6DadProfileListResult data, response status code and response headers
    def list_ipv6_dad_profiles_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.list_ipv6_dad_profiles ...'
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.list_ipv6_dad_profiles, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.list_ipv6_dad_profiles, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/infra/ipv6-dad-profiles'

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
        :return_type => 'Ipv6DadProfileListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi#list_ipv6_dad_profiles\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List all IPv6 DAD profiles
    # Paginated list of all IPv6 DAD profile instances 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results (default to false)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Ipv6DadProfileListResult]
    def list_ipv6_dad_profiles_0(opts = {})
      data, _status_code, _headers = list_ipv6_dad_profiles_0_with_http_info(opts)
      data
    end

    # List all IPv6 DAD profiles
    # Paginated list of all IPv6 DAD profile instances 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(Ipv6DadProfileListResult, Fixnum, Hash)>] Ipv6DadProfileListResult data, response status code and response headers
    def list_ipv6_dad_profiles_0_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.list_ipv6_dad_profiles_0 ...'
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.list_ipv6_dad_profiles_0, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.list_ipv6_dad_profiles_0, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/global-infra/ipv6-dad-profiles'

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
        :return_type => 'Ipv6DadProfileListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi#list_ipv6_dad_profiles_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or update IPv6 DAD profile
    # If profile with the dad-profile-id is not already present, create a new IPv6 DAD profile instance. If it already exists, update the IPv6 DAD profile instance with specified attributes. 
    # @param dad_profile_id 
    # @param ipv6_dad_profile 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object (default to false)
    # @return [nil]
    def patch_ipv6_dad_profile(dad_profile_id, ipv6_dad_profile, opts = {})
      patch_ipv6_dad_profile_with_http_info(dad_profile_id, ipv6_dad_profile, opts)
      nil
    end

    # Create or update IPv6 DAD profile
    # If profile with the dad-profile-id is not already present, create a new IPv6 DAD profile instance. If it already exists, update the IPv6 DAD profile instance with specified attributes. 
    # @param dad_profile_id 
    # @param ipv6_dad_profile 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_ipv6_dad_profile_with_http_info(dad_profile_id, ipv6_dad_profile, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.patch_ipv6_dad_profile ...'
      end
      # verify the required parameter 'dad_profile_id' is set
      if @api_client.config.client_side_validation && dad_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'dad_profile_id' when calling PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.patch_ipv6_dad_profile"
      end
      # verify the required parameter 'ipv6_dad_profile' is set
      if @api_client.config.client_side_validation && ipv6_dad_profile.nil?
        fail ArgumentError, "Missing the required parameter 'ipv6_dad_profile' when calling PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.patch_ipv6_dad_profile"
      end
      # resource path
      local_var_path = '/infra/ipv6-dad-profiles/{dad-profile-id}'.sub('{' + 'dad-profile-id' + '}', dad_profile_id.to_s)

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
      post_body = @api_client.object_to_http_body(ipv6_dad_profile)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi#patch_ipv6_dad_profile\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create or update IPv6 DAD profile
    # If profile with the dad-profile-id is not already present, create a new IPv6 DAD profile instance. If it already exists, update the IPv6 DAD profile instance with specified attributes. 
    # @param dad_profile_id 
    # @param ipv6_dad_profile 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object (default to false)
    # @return [nil]
    def patch_ipv6_dad_profile_0(dad_profile_id, ipv6_dad_profile, opts = {})
      patch_ipv6_dad_profile_0_with_http_info(dad_profile_id, ipv6_dad_profile, opts)
      nil
    end

    # Create or update IPv6 DAD profile
    # If profile with the dad-profile-id is not already present, create a new IPv6 DAD profile instance. If it already exists, update the IPv6 DAD profile instance with specified attributes. 
    # @param dad_profile_id 
    # @param ipv6_dad_profile 
    # @param [Hash] opts the optional parameters
    # @option opts [BOOLEAN] :override Locally override the global object
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_ipv6_dad_profile_0_with_http_info(dad_profile_id, ipv6_dad_profile, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.patch_ipv6_dad_profile_0 ...'
      end
      # verify the required parameter 'dad_profile_id' is set
      if @api_client.config.client_side_validation && dad_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'dad_profile_id' when calling PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.patch_ipv6_dad_profile_0"
      end
      # verify the required parameter 'ipv6_dad_profile' is set
      if @api_client.config.client_side_validation && ipv6_dad_profile.nil?
        fail ArgumentError, "Missing the required parameter 'ipv6_dad_profile' when calling PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.patch_ipv6_dad_profile_0"
      end
      # resource path
      local_var_path = '/global-infra/ipv6-dad-profiles/{dad-profile-id}'.sub('{' + 'dad-profile-id' + '}', dad_profile_id.to_s)

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
      post_body = @api_client.object_to_http_body(ipv6_dad_profile)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi#patch_ipv6_dad_profile_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Read IPv6 DAD profile
    # Read IPv6 DAD profile
    # @param dad_profile_id 
    # @param [Hash] opts the optional parameters
    # @return [Ipv6DadProfile]
    def read_ipv6_dad_profile(dad_profile_id, opts = {})
      data, _status_code, _headers = read_ipv6_dad_profile_with_http_info(dad_profile_id, opts)
      data
    end

    # Read IPv6 DAD profile
    # Read IPv6 DAD profile
    # @param dad_profile_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(Ipv6DadProfile, Fixnum, Hash)>] Ipv6DadProfile data, response status code and response headers
    def read_ipv6_dad_profile_with_http_info(dad_profile_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.read_ipv6_dad_profile ...'
      end
      # verify the required parameter 'dad_profile_id' is set
      if @api_client.config.client_side_validation && dad_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'dad_profile_id' when calling PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.read_ipv6_dad_profile"
      end
      # resource path
      local_var_path = '/infra/ipv6-dad-profiles/{dad-profile-id}'.sub('{' + 'dad-profile-id' + '}', dad_profile_id.to_s)

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
        :return_type => 'Ipv6DadProfile')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi#read_ipv6_dad_profile\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Read IPv6 DAD profile
    # Read IPv6 DAD profile
    # @param dad_profile_id 
    # @param [Hash] opts the optional parameters
    # @return [Ipv6DadProfile]
    def read_ipv6_dad_profile_0(dad_profile_id, opts = {})
      data, _status_code, _headers = read_ipv6_dad_profile_0_with_http_info(dad_profile_id, opts)
      data
    end

    # Read IPv6 DAD profile
    # Read IPv6 DAD profile
    # @param dad_profile_id 
    # @param [Hash] opts the optional parameters
    # @return [Array<(Ipv6DadProfile, Fixnum, Hash)>] Ipv6DadProfile data, response status code and response headers
    def read_ipv6_dad_profile_0_with_http_info(dad_profile_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.read_ipv6_dad_profile_0 ...'
      end
      # verify the required parameter 'dad_profile_id' is set
      if @api_client.config.client_side_validation && dad_profile_id.nil?
        fail ArgumentError, "Missing the required parameter 'dad_profile_id' when calling PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi.read_ipv6_dad_profile_0"
      end
      # resource path
      local_var_path = '/global-infra/ipv6-dad-profiles/{dad-profile-id}'.sub('{' + 'dad-profile-id' + '}', dad_profile_id.to_s)

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
        :return_type => 'Ipv6DadProfile')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingNetworkingProfilesIPV6DADProfilesApi#read_ipv6_dad_profile_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
