=begin
#NSX-T Data Center Policy API

#VMware NSX-T Data Center Policy REST API

OpenAPI spec version: 3.1.0.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'uri'

module NSXTPolicy
  class PolicyNetworkingConnectivitySegmentTepTableApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Get infra segment TEP table
    # Returns TEP table for a segment 
    # @param segment_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @option opts [String] :source Data source type.
    # @option opts [String] :transport_node_id TransportNode Id
    # @return [PolicyTepListResult]
    def get_infra_segment_tep_table(segment_id, opts = {})
      data, _status_code, _headers = get_infra_segment_tep_table_with_http_info(segment_id, opts)
      data
    end

    # Get infra segment TEP table
    # Returns TEP table for a segment 
    # @param segment_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @option opts [String] :source Data source type.
    # @option opts [String] :transport_node_id TransportNode Id
    # @return [Array<(PolicyTepListResult, Fixnum, Hash)>] PolicyTepListResult data, response status code and response headers
    def get_infra_segment_tep_table_with_http_info(segment_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivitySegmentTepTableApi.get_infra_segment_tep_table ...'
      end
      # verify the required parameter 'segment_id' is set
      if @api_client.config.client_side_validation && segment_id.nil?
        fail ArgumentError, "Missing the required parameter 'segment_id' when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_infra_segment_tep_table"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_infra_segment_tep_table, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_infra_segment_tep_table, must be greater than or equal to 0.'
      end

      if @api_client.config.client_side_validation && opts[:'source'] && !['realtime', 'cached'].include?(opts[:'source'])
        fail ArgumentError, 'invalid value for "source", must be one of realtime, cached'
      end
      # resource path
      local_var_path = '/global-infra/segments/{segment-id}/tep-table'.sub('{' + 'segment-id' + '}', segment_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'enforcement_point_path'] = opts[:'enforcement_point_path'] if !opts[:'enforcement_point_path'].nil?
      query_params[:'included_fields'] = opts[:'included_fields'] if !opts[:'included_fields'].nil?
      query_params[:'page_size'] = opts[:'page_size'] if !opts[:'page_size'].nil?
      query_params[:'sort_ascending'] = opts[:'sort_ascending'] if !opts[:'sort_ascending'].nil?
      query_params[:'sort_by'] = opts[:'sort_by'] if !opts[:'sort_by'].nil?
      query_params[:'source'] = opts[:'source'] if !opts[:'source'].nil?
      query_params[:'transport_node_id'] = opts[:'transport_node_id'] if !opts[:'transport_node_id'].nil?

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
        :return_type => 'PolicyTepListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivitySegmentTepTableApi#get_infra_segment_tep_table\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get infra segment TEP table
    # Returns TEP table for a segment 
    # @param segment_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @option opts [String] :source Data source type.
    # @option opts [String] :transport_node_id TransportNode Id
    # @return [PolicyTepListResult]
    def get_infra_segment_tep_table_0(segment_id, opts = {})
      data, _status_code, _headers = get_infra_segment_tep_table_0_with_http_info(segment_id, opts)
      data
    end

    # Get infra segment TEP table
    # Returns TEP table for a segment 
    # @param segment_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @option opts [String] :source Data source type.
    # @option opts [String] :transport_node_id TransportNode Id
    # @return [Array<(PolicyTepListResult, Fixnum, Hash)>] PolicyTepListResult data, response status code and response headers
    def get_infra_segment_tep_table_0_with_http_info(segment_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivitySegmentTepTableApi.get_infra_segment_tep_table_0 ...'
      end
      # verify the required parameter 'segment_id' is set
      if @api_client.config.client_side_validation && segment_id.nil?
        fail ArgumentError, "Missing the required parameter 'segment_id' when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_infra_segment_tep_table_0"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_infra_segment_tep_table_0, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_infra_segment_tep_table_0, must be greater than or equal to 0.'
      end

      if @api_client.config.client_side_validation && opts[:'source'] && !['realtime', 'cached'].include?(opts[:'source'])
        fail ArgumentError, 'invalid value for "source", must be one of realtime, cached'
      end
      # resource path
      local_var_path = '/infra/segments/{segment-id}/tep-table'.sub('{' + 'segment-id' + '}', segment_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'enforcement_point_path'] = opts[:'enforcement_point_path'] if !opts[:'enforcement_point_path'].nil?
      query_params[:'included_fields'] = opts[:'included_fields'] if !opts[:'included_fields'].nil?
      query_params[:'page_size'] = opts[:'page_size'] if !opts[:'page_size'].nil?
      query_params[:'sort_ascending'] = opts[:'sort_ascending'] if !opts[:'sort_ascending'].nil?
      query_params[:'sort_by'] = opts[:'sort_by'] if !opts[:'sort_by'].nil?
      query_params[:'source'] = opts[:'source'] if !opts[:'source'].nil?
      query_params[:'transport_node_id'] = opts[:'transport_node_id'] if !opts[:'transport_node_id'].nil?

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
        :return_type => 'PolicyTepListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivitySegmentTepTableApi#get_infra_segment_tep_table_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get tier-1 segment TEP table in CSV
    # Returns TEP table for a segment in CSV 
    # @param segment_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :source Data source type.
    # @option opts [String] :transport_node_id TransportNode Id
    # @return [PolicyTepCsvListResult]
    def get_infra_segment_tep_table_in_csv(segment_id, opts = {})
      data, _status_code, _headers = get_infra_segment_tep_table_in_csv_with_http_info(segment_id, opts)
      data
    end

    # Get tier-1 segment TEP table in CSV
    # Returns TEP table for a segment in CSV 
    # @param segment_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :source Data source type.
    # @option opts [String] :transport_node_id TransportNode Id
    # @return [Array<(PolicyTepCsvListResult, Fixnum, Hash)>] PolicyTepCsvListResult data, response status code and response headers
    def get_infra_segment_tep_table_in_csv_with_http_info(segment_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivitySegmentTepTableApi.get_infra_segment_tep_table_in_csv ...'
      end
      # verify the required parameter 'segment_id' is set
      if @api_client.config.client_side_validation && segment_id.nil?
        fail ArgumentError, "Missing the required parameter 'segment_id' when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_infra_segment_tep_table_in_csv"
      end
      if @api_client.config.client_side_validation && opts[:'source'] && !['realtime', 'cached'].include?(opts[:'source'])
        fail ArgumentError, 'invalid value for "source", must be one of realtime, cached'
      end
      # resource path
      local_var_path = '/infra/segments/{segment-id}/tep-table?format=csv'.sub('{' + 'segment-id' + '}', segment_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'enforcement_point_path'] = opts[:'enforcement_point_path'] if !opts[:'enforcement_point_path'].nil?
      query_params[:'source'] = opts[:'source'] if !opts[:'source'].nil?
      query_params[:'transport_node_id'] = opts[:'transport_node_id'] if !opts[:'transport_node_id'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['text/csv'])
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
        :return_type => 'PolicyTepCsvListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivitySegmentTepTableApi#get_infra_segment_tep_table_in_csv\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get tier-1 segment TEP table in CSV
    # Returns TEP table for a segment in CSV 
    # @param segment_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :source Data source type.
    # @option opts [String] :transport_node_id TransportNode Id
    # @return [PolicyTepCsvListResult]
    def get_infra_segment_tep_table_in_csv_0(segment_id, opts = {})
      data, _status_code, _headers = get_infra_segment_tep_table_in_csv_0_with_http_info(segment_id, opts)
      data
    end

    # Get tier-1 segment TEP table in CSV
    # Returns TEP table for a segment in CSV 
    # @param segment_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :source Data source type.
    # @option opts [String] :transport_node_id TransportNode Id
    # @return [Array<(PolicyTepCsvListResult, Fixnum, Hash)>] PolicyTepCsvListResult data, response status code and response headers
    def get_infra_segment_tep_table_in_csv_0_with_http_info(segment_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivitySegmentTepTableApi.get_infra_segment_tep_table_in_csv_0 ...'
      end
      # verify the required parameter 'segment_id' is set
      if @api_client.config.client_side_validation && segment_id.nil?
        fail ArgumentError, "Missing the required parameter 'segment_id' when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_infra_segment_tep_table_in_csv_0"
      end
      if @api_client.config.client_side_validation && opts[:'source'] && !['realtime', 'cached'].include?(opts[:'source'])
        fail ArgumentError, 'invalid value for "source", must be one of realtime, cached'
      end
      # resource path
      local_var_path = '/global-infra/segments/{segment-id}/tep-table?format=csv'.sub('{' + 'segment-id' + '}', segment_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'enforcement_point_path'] = opts[:'enforcement_point_path'] if !opts[:'enforcement_point_path'].nil?
      query_params[:'source'] = opts[:'source'] if !opts[:'source'].nil?
      query_params[:'transport_node_id'] = opts[:'transport_node_id'] if !opts[:'transport_node_id'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['text/csv'])
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
        :return_type => 'PolicyTepCsvListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivitySegmentTepTableApi#get_infra_segment_tep_table_in_csv_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get tier-1 segment TEP table
    # Returns TEP table for a segment 
    # @param tier_1_id 
    # @param segment_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @option opts [String] :source Data source type.
    # @option opts [String] :transport_node_id TransportNode Id
    # @return [PolicyTepListResult]
    def get_tier1_segment_tep_table(tier_1_id, segment_id, opts = {})
      data, _status_code, _headers = get_tier1_segment_tep_table_with_http_info(tier_1_id, segment_id, opts)
      data
    end

    # Get tier-1 segment TEP table
    # Returns TEP table for a segment 
    # @param tier_1_id 
    # @param segment_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @option opts [String] :source Data source type.
    # @option opts [String] :transport_node_id TransportNode Id
    # @return [Array<(PolicyTepListResult, Fixnum, Hash)>] PolicyTepListResult data, response status code and response headers
    def get_tier1_segment_tep_table_with_http_info(tier_1_id, segment_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivitySegmentTepTableApi.get_tier1_segment_tep_table ...'
      end
      # verify the required parameter 'tier_1_id' is set
      if @api_client.config.client_side_validation && tier_1_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_1_id' when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_tier1_segment_tep_table"
      end
      # verify the required parameter 'segment_id' is set
      if @api_client.config.client_side_validation && segment_id.nil?
        fail ArgumentError, "Missing the required parameter 'segment_id' when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_tier1_segment_tep_table"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_tier1_segment_tep_table, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_tier1_segment_tep_table, must be greater than or equal to 0.'
      end

      if @api_client.config.client_side_validation && opts[:'source'] && !['realtime', 'cached'].include?(opts[:'source'])
        fail ArgumentError, 'invalid value for "source", must be one of realtime, cached'
      end
      # resource path
      local_var_path = '/infra/tier-1s/{tier-1-id}/segments/{segment-id}/tep-table'.sub('{' + 'tier-1-id' + '}', tier_1_id.to_s).sub('{' + 'segment-id' + '}', segment_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'enforcement_point_path'] = opts[:'enforcement_point_path'] if !opts[:'enforcement_point_path'].nil?
      query_params[:'included_fields'] = opts[:'included_fields'] if !opts[:'included_fields'].nil?
      query_params[:'page_size'] = opts[:'page_size'] if !opts[:'page_size'].nil?
      query_params[:'sort_ascending'] = opts[:'sort_ascending'] if !opts[:'sort_ascending'].nil?
      query_params[:'sort_by'] = opts[:'sort_by'] if !opts[:'sort_by'].nil?
      query_params[:'source'] = opts[:'source'] if !opts[:'source'].nil?
      query_params[:'transport_node_id'] = opts[:'transport_node_id'] if !opts[:'transport_node_id'].nil?

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
        :return_type => 'PolicyTepListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivitySegmentTepTableApi#get_tier1_segment_tep_table\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get tier-1 segment TEP table
    # Returns TEP table for a segment 
    # @param tier_1_id 
    # @param segment_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @option opts [String] :source Data source type.
    # @option opts [String] :transport_node_id TransportNode Id
    # @return [PolicyTepListResult]
    def get_tier1_segment_tep_table_0(tier_1_id, segment_id, opts = {})
      data, _status_code, _headers = get_tier1_segment_tep_table_0_with_http_info(tier_1_id, segment_id, opts)
      data
    end

    # Get tier-1 segment TEP table
    # Returns TEP table for a segment 
    # @param tier_1_id 
    # @param segment_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @option opts [String] :source Data source type.
    # @option opts [String] :transport_node_id TransportNode Id
    # @return [Array<(PolicyTepListResult, Fixnum, Hash)>] PolicyTepListResult data, response status code and response headers
    def get_tier1_segment_tep_table_0_with_http_info(tier_1_id, segment_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivitySegmentTepTableApi.get_tier1_segment_tep_table_0 ...'
      end
      # verify the required parameter 'tier_1_id' is set
      if @api_client.config.client_side_validation && tier_1_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_1_id' when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_tier1_segment_tep_table_0"
      end
      # verify the required parameter 'segment_id' is set
      if @api_client.config.client_side_validation && segment_id.nil?
        fail ArgumentError, "Missing the required parameter 'segment_id' when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_tier1_segment_tep_table_0"
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_tier1_segment_tep_table_0, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_tier1_segment_tep_table_0, must be greater than or equal to 0.'
      end

      if @api_client.config.client_side_validation && opts[:'source'] && !['realtime', 'cached'].include?(opts[:'source'])
        fail ArgumentError, 'invalid value for "source", must be one of realtime, cached'
      end
      # resource path
      local_var_path = '/global-infra/tier-1s/{tier-1-id}/segments/{segment-id}/tep-table'.sub('{' + 'tier-1-id' + '}', tier_1_id.to_s).sub('{' + 'segment-id' + '}', segment_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'enforcement_point_path'] = opts[:'enforcement_point_path'] if !opts[:'enforcement_point_path'].nil?
      query_params[:'included_fields'] = opts[:'included_fields'] if !opts[:'included_fields'].nil?
      query_params[:'page_size'] = opts[:'page_size'] if !opts[:'page_size'].nil?
      query_params[:'sort_ascending'] = opts[:'sort_ascending'] if !opts[:'sort_ascending'].nil?
      query_params[:'sort_by'] = opts[:'sort_by'] if !opts[:'sort_by'].nil?
      query_params[:'source'] = opts[:'source'] if !opts[:'source'].nil?
      query_params[:'transport_node_id'] = opts[:'transport_node_id'] if !opts[:'transport_node_id'].nil?

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
        :return_type => 'PolicyTepListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivitySegmentTepTableApi#get_tier1_segment_tep_table_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get tier-1 segment TEP table in CSV
    # Returns TEP table for a segment in CSV 
    # @param tier_1_id 
    # @param segment_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :source Data source type.
    # @option opts [String] :transport_node_id TransportNode Id
    # @return [PolicyTepCsvListResult]
    def get_tier1_segment_tep_table_in_csv(tier_1_id, segment_id, opts = {})
      data, _status_code, _headers = get_tier1_segment_tep_table_in_csv_with_http_info(tier_1_id, segment_id, opts)
      data
    end

    # Get tier-1 segment TEP table in CSV
    # Returns TEP table for a segment in CSV 
    # @param tier_1_id 
    # @param segment_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :source Data source type.
    # @option opts [String] :transport_node_id TransportNode Id
    # @return [Array<(PolicyTepCsvListResult, Fixnum, Hash)>] PolicyTepCsvListResult data, response status code and response headers
    def get_tier1_segment_tep_table_in_csv_with_http_info(tier_1_id, segment_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivitySegmentTepTableApi.get_tier1_segment_tep_table_in_csv ...'
      end
      # verify the required parameter 'tier_1_id' is set
      if @api_client.config.client_side_validation && tier_1_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_1_id' when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_tier1_segment_tep_table_in_csv"
      end
      # verify the required parameter 'segment_id' is set
      if @api_client.config.client_side_validation && segment_id.nil?
        fail ArgumentError, "Missing the required parameter 'segment_id' when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_tier1_segment_tep_table_in_csv"
      end
      if @api_client.config.client_side_validation && opts[:'source'] && !['realtime', 'cached'].include?(opts[:'source'])
        fail ArgumentError, 'invalid value for "source", must be one of realtime, cached'
      end
      # resource path
      local_var_path = '/global-infra/tier-1s/{tier-1-id}/segments/{segment-id}/tep-table?format=csv'.sub('{' + 'tier-1-id' + '}', tier_1_id.to_s).sub('{' + 'segment-id' + '}', segment_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'enforcement_point_path'] = opts[:'enforcement_point_path'] if !opts[:'enforcement_point_path'].nil?
      query_params[:'source'] = opts[:'source'] if !opts[:'source'].nil?
      query_params[:'transport_node_id'] = opts[:'transport_node_id'] if !opts[:'transport_node_id'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['text/csv'])
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
        :return_type => 'PolicyTepCsvListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivitySegmentTepTableApi#get_tier1_segment_tep_table_in_csv\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get tier-1 segment TEP table in CSV
    # Returns TEP table for a segment in CSV 
    # @param tier_1_id 
    # @param segment_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :source Data source type.
    # @option opts [String] :transport_node_id TransportNode Id
    # @return [PolicyTepCsvListResult]
    def get_tier1_segment_tep_table_in_csv_0(tier_1_id, segment_id, opts = {})
      data, _status_code, _headers = get_tier1_segment_tep_table_in_csv_0_with_http_info(tier_1_id, segment_id, opts)
      data
    end

    # Get tier-1 segment TEP table in CSV
    # Returns TEP table for a segment in CSV 
    # @param tier_1_id 
    # @param segment_id 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :enforcement_point_path String Path of the enforcement point
    # @option opts [String] :source Data source type.
    # @option opts [String] :transport_node_id TransportNode Id
    # @return [Array<(PolicyTepCsvListResult, Fixnum, Hash)>] PolicyTepCsvListResult data, response status code and response headers
    def get_tier1_segment_tep_table_in_csv_0_with_http_info(tier_1_id, segment_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PolicyNetworkingConnectivitySegmentTepTableApi.get_tier1_segment_tep_table_in_csv_0 ...'
      end
      # verify the required parameter 'tier_1_id' is set
      if @api_client.config.client_side_validation && tier_1_id.nil?
        fail ArgumentError, "Missing the required parameter 'tier_1_id' when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_tier1_segment_tep_table_in_csv_0"
      end
      # verify the required parameter 'segment_id' is set
      if @api_client.config.client_side_validation && segment_id.nil?
        fail ArgumentError, "Missing the required parameter 'segment_id' when calling PolicyNetworkingConnectivitySegmentTepTableApi.get_tier1_segment_tep_table_in_csv_0"
      end
      if @api_client.config.client_side_validation && opts[:'source'] && !['realtime', 'cached'].include?(opts[:'source'])
        fail ArgumentError, 'invalid value for "source", must be one of realtime, cached'
      end
      # resource path
      local_var_path = '/infra/tier-1s/{tier-1-id}/segments/{segment-id}/tep-table?format=csv'.sub('{' + 'tier-1-id' + '}', tier_1_id.to_s).sub('{' + 'segment-id' + '}', segment_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'enforcement_point_path'] = opts[:'enforcement_point_path'] if !opts[:'enforcement_point_path'].nil?
      query_params[:'source'] = opts[:'source'] if !opts[:'source'].nil?
      query_params[:'transport_node_id'] = opts[:'transport_node_id'] if !opts[:'transport_node_id'].nil?

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['text/csv'])
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
        :return_type => 'PolicyTepCsvListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PolicyNetworkingConnectivitySegmentTepTableApi#get_tier1_segment_tep_table_in_csv_0\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
