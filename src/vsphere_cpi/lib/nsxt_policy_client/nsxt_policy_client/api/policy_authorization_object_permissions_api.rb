=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'uri'

module NSXTPolicy
  class PolicyAuthorizationObjectPermissionsApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Delete object-permissions entries
    # Delete object-permissions entries
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results (default to false)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [BOOLEAN] :inheritance_disabled Does children of this object inherit this rule (default to false)
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [String] :path_prefix Path prefix
    # @option opts [String] :role_name Role name
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [nil]
    def delete_object_permissions(opts = {})
      delete_object_permissions_with_http_info(opts)
      nil
    end

    # Delete object-permissions entries
    # Delete object-permissions entries
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [BOOLEAN] :inheritance_disabled Does children of this object inherit this rule
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [String] :path_prefix Path prefix
    # @option opts [String] :role_name Role name
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def delete_object_permissions_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyAuthorizationObjectPermissionsApi.delete_object_permissions ...'
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyAuthorizationObjectPermissionsApi.delete_object_permissions, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyAuthorizationObjectPermissionsApi.delete_object_permissions, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/aaa/object-permissions'

      # query parameters
      query_params = {}
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'include_mark_for_delete_objects'] = opts[:'include_mark_for_delete_objects'] if !opts[:'include_mark_for_delete_objects'].nil?
      query_params[:'included_fields'] = opts[:'included_fields'] if !opts[:'included_fields'].nil?
      query_params[:'inheritance_disabled'] = opts[:'inheritance_disabled'] if !opts[:'inheritance_disabled'].nil?
      query_params[:'page_size'] = opts[:'page_size'] if !opts[:'page_size'].nil?
      query_params[:'path_prefix'] = opts[:'path_prefix'] if !opts[:'path_prefix'].nil?
      query_params[:'role_name'] = opts[:'role_name'] if !opts[:'role_name'].nil?
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
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyAuthorizationObjectPermissionsApi#delete_object_permissions\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get list of Object-level RBAC entries.
    # Get list of Object-level RBAC entries.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results (default to false)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [BOOLEAN] :inheritance_disabled Does children of this object inherit this rule (default to false)
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [String] :path_prefix Path prefix
    # @option opts [String] :role_name Role name
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [ObjectRolePermissionGroupListResult]
    def get_object_permissions(opts = {})
      data, _status_code, _headers = get_object_permissions_with_http_info(opts)
      data
    end

    # Get list of Object-level RBAC entries.
    # Get list of Object-level RBAC entries.
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :include_mark_for_delete_objects Include objects that are marked for deletion in results
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [BOOLEAN] :inheritance_disabled Does children of this object inherit this rule
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [String] :path_prefix Path prefix
    # @option opts [String] :role_name Role name
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(ObjectRolePermissionGroupListResult, Fixnum, Hash)>] ObjectRolePermissionGroupListResult data, response status code and response headers
    def get_object_permissions_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyAuthorizationObjectPermissionsApi.get_object_permissions ...'
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyAuthorizationObjectPermissionsApi.get_object_permissions, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyAuthorizationObjectPermissionsApi.get_object_permissions, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/aaa/object-permissions'

      # query parameters
      query_params = {}
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'include_mark_for_delete_objects'] = opts[:'include_mark_for_delete_objects'] if !opts[:'include_mark_for_delete_objects'].nil?
      query_params[:'included_fields'] = opts[:'included_fields'] if !opts[:'included_fields'].nil?
      query_params[:'inheritance_disabled'] = opts[:'inheritance_disabled'] if !opts[:'inheritance_disabled'].nil?
      query_params[:'page_size'] = opts[:'page_size'] if !opts[:'page_size'].nil?
      query_params[:'path_prefix'] = opts[:'path_prefix'] if !opts[:'path_prefix'].nil?
      query_params[:'role_name'] = opts[:'role_name'] if !opts[:'role_name'].nil?
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
        :return_type => 'ObjectRolePermissionGroupListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyAuthorizationObjectPermissionsApi#get_object_permissions\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get effective object permissions to object specified by path for current user.
    # Returns none if user doesn't have access or feature_name from required request parameter is empty/invalid/doesn't match with object-path provided. 
    # @param feature_name Feature name
    # @param object_path Exact object Policy path
    # @param [Hash] opts the optional parameters
    # @return [PathPermissionGroup]
    def get_path_permissions(feature_name, object_path, opts = {})
      data, _status_code, _headers = get_path_permissions_with_http_info(feature_name, object_path, opts)
      data
    end

    # Get effective object permissions to object specified by path for current user.
    # Returns none if user doesn&#39;t have access or feature_name from required request parameter is empty/invalid/doesn&#39;t match with object-path provided. 
    # @param feature_name Feature name
    # @param object_path Exact object Policy path
    # @param [Hash] opts the optional parameters
    # @return [Array<(PathPermissionGroup, Fixnum, Hash)>] PathPermissionGroup data, response status code and response headers
    def get_path_permissions_with_http_info(feature_name, object_path, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyAuthorizationObjectPermissionsApi.get_path_permissions ...'
      end
      # verify the required parameter 'feature_name' is set
      if @api_client.config.client_side_validation && feature_name.nil?
        fail ArgumentError, "Missing the required parameter 'feature_name' when calling PolicyAuthorizationObjectPermissionsApi.get_path_permissions"
      end
      # verify the required parameter 'object_path' is set
      if @api_client.config.client_side_validation && object_path.nil?
        fail ArgumentError, "Missing the required parameter 'object_path' when calling PolicyAuthorizationObjectPermissionsApi.get_path_permissions"
      end
      # resource path
      local_var_path = '/aaa/effective-permissions'

      # query parameters
      query_params = {}
      query_params[:'feature_name'] = feature_name
      query_params[:'object_path'] = object_path

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
        :return_type => 'PathPermissionGroup')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyAuthorizationObjectPermissionsApi#get_path_permissions\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create/update object permission mappings
    # Create/update object permission mappings
    # @param object_role_permission_group 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def update_object_permissions(object_role_permission_group, opts = {})
      update_object_permissions_with_http_info(object_role_permission_group, opts)
      nil
    end

    # Create/update object permission mappings
    # Create/update object permission mappings
    # @param object_role_permission_group 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def update_object_permissions_with_http_info(object_role_permission_group, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyAuthorizationObjectPermissionsApi.update_object_permissions ...'
      end
      # verify the required parameter 'object_role_permission_group' is set
      if @api_client.config.client_side_validation && object_role_permission_group.nil?
        fail ArgumentError, "Missing the required parameter 'object_role_permission_group' when calling PolicyAuthorizationObjectPermissionsApi.update_object_permissions"
      end
      # resource path
      local_var_path = '/aaa/object-permissions'

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
      post_body = @api_client.object_to_http_body(object_role_permission_group)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyAuthorizationObjectPermissionsApi#update_object_permissions\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
