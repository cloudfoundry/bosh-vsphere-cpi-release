=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.17

=end

require 'uri'

module NSXTPolicy
  class PolicyCapacityDashboardApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Returns capacity usage data for NSX objects
    # Returns capacity usage data for NSX objects
    # @param [Hash] opts the optional parameters
    # @option opts [String] :category 
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :force  (default to true)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [CapacityUsageResponse]
    def get_policy_capacity_dashboard_usage(opts = {})
      data, _status_code, _headers = get_policy_capacity_dashboard_usage_with_http_info(opts)
      data
    end

    # Returns capacity usage data for NSX objects
    # Returns capacity usage data for NSX objects
    # @param [Hash] opts the optional parameters
    # @option opts [String] :category 
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :force 
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(CapacityUsageResponse, Fixnum, Hash)>] CapacityUsageResponse data, response status code and response headers
    def get_policy_capacity_dashboard_usage_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyCapacityDashboardApi.get_policy_capacity_dashboard_usage ...'
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyCapacityDashboardApi.get_policy_capacity_dashboard_usage, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyCapacityDashboardApi.get_policy_capacity_dashboard_usage, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/global-infra/capacity/dashboard/usage'

      # query parameters
      query_params = {}
      query_params[:'category'] = opts[:'category'] if !opts[:'category'].nil?
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'force'] = opts[:'force'] if !opts[:'force'].nil?
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
        :return_type => 'CapacityUsageResponse')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyCapacityDashboardApi#get_policy_capacity_dashboard_usage\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Returns capacity usage data for NSX objects
    # Returns capacity usage data for NSX objects
    # @param [Hash] opts the optional parameters
    # @option opts [String] :category 
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :force  (default to true)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [CapacityUsageResponse]
    def get_policy_capacity_dashboard_usage_0(opts = {})
      data, _status_code, _headers = get_policy_capacity_dashboard_usage_0_with_http_info(opts)
      data
    end

    # Returns capacity usage data for NSX objects
    # Returns capacity usage data for NSX objects
    # @param [Hash] opts the optional parameters
    # @option opts [String] :category 
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [BOOLEAN] :force 
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(CapacityUsageResponse, Fixnum, Hash)>] CapacityUsageResponse data, response status code and response headers
    def get_policy_capacity_dashboard_usage_0_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyCapacityDashboardApi.get_policy_capacity_dashboard_usage_0 ...'
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyCapacityDashboardApi.get_policy_capacity_dashboard_usage_0, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyCapacityDashboardApi.get_policy_capacity_dashboard_usage_0, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/infra/capacity/dashboard/usage'

      # query parameters
      query_params = {}
      query_params[:'category'] = opts[:'category'] if !opts[:'category'].nil?
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'force'] = opts[:'force'] if !opts[:'force'].nil?
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
        :return_type => 'CapacityUsageResponse')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyCapacityDashboardApi#get_policy_capacity_dashboard_usage_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Returns warning threshold(s) set for NSX Objects.
    # Returns warning threshold(s) set for NSX Objects.
    # @param [Hash] opts the optional parameters
    # @return [CapacityThresholdList]
    def get_policy_capacity_thresholds(opts = {})
      data, _status_code, _headers = get_policy_capacity_thresholds_with_http_info(opts)
      data
    end

    # Returns warning threshold(s) set for NSX Objects.
    # Returns warning threshold(s) set for NSX Objects.
    # @param [Hash] opts the optional parameters
    # @return [Array<(CapacityThresholdList, Fixnum, Hash)>] CapacityThresholdList data, response status code and response headers
    def get_policy_capacity_thresholds_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyCapacityDashboardApi.get_policy_capacity_thresholds ...'
      end
      # resource path
      local_var_path = '/global-infra/capacity/threshold'

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
        :return_type => 'CapacityThresholdList')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyCapacityDashboardApi#get_policy_capacity_thresholds\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Returns warning threshold(s) set for NSX Objects.
    # Returns warning threshold(s) set for NSX Objects.
    # @param [Hash] opts the optional parameters
    # @return [CapacityThresholdList]
    def get_policy_capacity_thresholds_0(opts = {})
      data, _status_code, _headers = get_policy_capacity_thresholds_0_with_http_info(opts)
      data
    end

    # Returns warning threshold(s) set for NSX Objects.
    # Returns warning threshold(s) set for NSX Objects.
    # @param [Hash] opts the optional parameters
    # @return [Array<(CapacityThresholdList, Fixnum, Hash)>] CapacityThresholdList data, response status code and response headers
    def get_policy_capacity_thresholds_0_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyCapacityDashboardApi.get_policy_capacity_thresholds_0 ...'
      end
      # resource path
      local_var_path = '/infra/capacity/threshold'

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
        :return_type => 'CapacityThresholdList')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyCapacityDashboardApi#get_policy_capacity_thresholds_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Returns capacity usage data for NSX objects
    # Returns capacity usage data for NSX objects
    # @param [Hash] opts the optional parameters
    # @option opts [String] :category 
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [PolicyCapacityUsageResponse]
    def get_policy_capacity_usage(opts = {})
      data, _status_code, _headers = get_policy_capacity_usage_with_http_info(opts)
      data
    end

    # Returns capacity usage data for NSX objects
    # Returns capacity usage data for NSX objects
    # @param [Hash] opts the optional parameters
    # @option opts [String] :category 
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(PolicyCapacityUsageResponse, Fixnum, Hash)>] PolicyCapacityUsageResponse data, response status code and response headers
    def get_policy_capacity_usage_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyCapacityDashboardApi.get_policy_capacity_usage ...'
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyCapacityDashboardApi.get_policy_capacity_usage, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyCapacityDashboardApi.get_policy_capacity_usage, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/global-infra/capacity/usage'

      # query parameters
      query_params = {}
      query_params[:'category'] = opts[:'category'] if !opts[:'category'].nil?
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
        :return_type => 'PolicyCapacityUsageResponse')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyCapacityDashboardApi#get_policy_capacity_usage\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Returns capacity usage data for NSX objects
    # Returns capacity usage data for NSX objects
    # @param [Hash] opts the optional parameters
    # @option opts [String] :category 
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [PolicyCapacityUsageResponse]
    def get_policy_capacity_usage_0(opts = {})
      data, _status_code, _headers = get_policy_capacity_usage_0_with_http_info(opts)
      data
    end

    # Returns capacity usage data for NSX objects
    # Returns capacity usage data for NSX objects
    # @param [Hash] opts the optional parameters
    # @option opts [String] :category 
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(PolicyCapacityUsageResponse, Fixnum, Hash)>] PolicyCapacityUsageResponse data, response status code and response headers
    def get_policy_capacity_usage_0_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyCapacityDashboardApi.get_policy_capacity_usage_0 ...'
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyCapacityDashboardApi.get_policy_capacity_usage_0, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyCapacityDashboardApi.get_policy_capacity_usage_0, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/infra/capacity/usage'

      # query parameters
      query_params = {}
      query_params[:'category'] = opts[:'category'] if !opts[:'category'].nil?
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
        :return_type => 'PolicyCapacityUsageResponse')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyCapacityDashboardApi#get_policy_capacity_usage_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Updates the thresholds for specified NSX Objects.
    # Updates the warning threshold(s) for NSX Objects specified, does not modify thresholds for any other objects. 
    # @param capacity_threshold 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def patch_policy_capacity_thresholds(capacity_threshold, opts = {})
      patch_policy_capacity_thresholds_with_http_info(capacity_threshold, opts)
      nil
    end

    # Updates the thresholds for specified NSX Objects.
    # Updates the warning threshold(s) for NSX Objects specified, does not modify thresholds for any other objects. 
    # @param capacity_threshold 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_policy_capacity_thresholds_with_http_info(capacity_threshold, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyCapacityDashboardApi.patch_policy_capacity_thresholds ...'
      end
      # verify the required parameter 'capacity_threshold' is set
      if @api_client.config.client_side_validation && capacity_threshold.nil?
        fail ArgumentError, "Missing the required parameter 'capacity_threshold' when calling PolicyCapacityDashboardApi.patch_policy_capacity_thresholds"
      end
      # resource path
      local_var_path = '/global-infra/capacity/threshold'

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
      post_body = @api_client.object_to_http_body(capacity_threshold)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyCapacityDashboardApi#patch_policy_capacity_thresholds\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Updates the thresholds for specified NSX Objects.
    # Updates the warning threshold(s) for NSX Objects specified, does not modify thresholds for any other objects. 
    # @param capacity_threshold 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def patch_policy_capacity_thresholds_0(capacity_threshold, opts = {})
      patch_policy_capacity_thresholds_0_with_http_info(capacity_threshold, opts)
      nil
    end

    # Updates the thresholds for specified NSX Objects.
    # Updates the warning threshold(s) for NSX Objects specified, does not modify thresholds for any other objects. 
    # @param capacity_threshold 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def patch_policy_capacity_thresholds_0_with_http_info(capacity_threshold, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyCapacityDashboardApi.patch_policy_capacity_thresholds_0 ...'
      end
      # verify the required parameter 'capacity_threshold' is set
      if @api_client.config.client_side_validation && capacity_threshold.nil?
        fail ArgumentError, "Missing the required parameter 'capacity_threshold' when calling PolicyCapacityDashboardApi.patch_policy_capacity_thresholds_0"
      end
      # resource path
      local_var_path = '/infra/capacity/threshold'

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
      post_body = @api_client.object_to_http_body(capacity_threshold)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PATCH, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyCapacityDashboardApi#patch_policy_capacity_thresholds_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Updates the warning threshold(s) for NSX Objects.
    # Updates the warning threshold(s) for NSX Objects specified, and returns new threshold(s). Threshold list in the request must contain value for GLOBAL_DEFAULT threshold_type which represents global thresholds. 
    # @param capacity_threshold_list 
    # @param [Hash] opts the optional parameters
    # @return [CapacityThresholdList]
    def update_policy_capacity_thresholds(capacity_threshold_list, opts = {})
      data, _status_code, _headers = update_policy_capacity_thresholds_with_http_info(capacity_threshold_list, opts)
      data
    end

    # Updates the warning threshold(s) for NSX Objects.
    # Updates the warning threshold(s) for NSX Objects specified, and returns new threshold(s). Threshold list in the request must contain value for GLOBAL_DEFAULT threshold_type which represents global thresholds. 
    # @param capacity_threshold_list 
    # @param [Hash] opts the optional parameters
    # @return [Array<(CapacityThresholdList, Fixnum, Hash)>] CapacityThresholdList data, response status code and response headers
    def update_policy_capacity_thresholds_with_http_info(capacity_threshold_list, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyCapacityDashboardApi.update_policy_capacity_thresholds ...'
      end
      # verify the required parameter 'capacity_threshold_list' is set
      if @api_client.config.client_side_validation && capacity_threshold_list.nil?
        fail ArgumentError, "Missing the required parameter 'capacity_threshold_list' when calling PolicyCapacityDashboardApi.update_policy_capacity_thresholds"
      end
      # resource path
      local_var_path = '/global-infra/capacity/threshold'

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
      post_body = @api_client.object_to_http_body(capacity_threshold_list)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'CapacityThresholdList')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyCapacityDashboardApi#update_policy_capacity_thresholds\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Updates the warning threshold(s) for NSX Objects.
    # Updates the warning threshold(s) for NSX Objects specified, and returns new threshold(s). Threshold list in the request must contain value for GLOBAL_DEFAULT threshold_type which represents global thresholds. 
    # @param capacity_threshold_list 
    # @param [Hash] opts the optional parameters
    # @return [CapacityThresholdList]
    def update_policy_capacity_thresholds_0(capacity_threshold_list, opts = {})
      data, _status_code, _headers = update_policy_capacity_thresholds_0_with_http_info(capacity_threshold_list, opts)
      data
    end

    # Updates the warning threshold(s) for NSX Objects.
    # Updates the warning threshold(s) for NSX Objects specified, and returns new threshold(s). Threshold list in the request must contain value for GLOBAL_DEFAULT threshold_type which represents global thresholds. 
    # @param capacity_threshold_list 
    # @param [Hash] opts the optional parameters
    # @return [Array<(CapacityThresholdList, Fixnum, Hash)>] CapacityThresholdList data, response status code and response headers
    def update_policy_capacity_thresholds_0_with_http_info(capacity_threshold_list, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyCapacityDashboardApi.update_policy_capacity_thresholds_0 ...'
      end
      # verify the required parameter 'capacity_threshold_list' is set
      if @api_client.config.client_side_validation && capacity_threshold_list.nil?
        fail ArgumentError, "Missing the required parameter 'capacity_threshold_list' when calling PolicyCapacityDashboardApi.update_policy_capacity_thresholds_0"
      end
      # resource path
      local_var_path = '/infra/capacity/threshold'

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
      post_body = @api_client.object_to_http_body(capacity_threshold_list)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'CapacityThresholdList')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyCapacityDashboardApi#update_policy_capacity_thresholds_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
