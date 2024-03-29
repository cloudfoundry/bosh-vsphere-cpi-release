=begin
#NSX-T Manager API

#VMware NSX-T Manager REST API

OpenAPI spec version: 2.5.1.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'uri'

module NSXT
  class ManagementPlaneApiFabricVifsApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Return the List of Virtual Network Interfaces (VIFs)
    # Returns information about all VIFs. A virtual network interface aggregates network interfaces into a logical interface unit that is indistinuishable from a physical network interface. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :host_id Id of the host where this vif is located.
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [String] :lport_attachment_id LPort Attachment Id of the virtual network interface.
    # @option opts [String] :owner_vm_id External id of the virtual machine.
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @option opts [String] :vm_id External id of the virtual machine.
    # @return [VirtualNetworkInterfaceListResult]
    def list_vifs(opts = {})
      data, _status_code, _headers = list_vifs_with_http_info(opts)
      data
    end

    # Return the List of Virtual Network Interfaces (VIFs)
    # Returns information about all VIFs. A virtual network interface aggregates network interfaces into a logical interface unit that is indistinuishable from a physical network interface. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :host_id Id of the host where this vif is located.
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [String] :lport_attachment_id LPort Attachment Id of the virtual network interface.
    # @option opts [String] :owner_vm_id External id of the virtual machine.
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @option opts [String] :vm_id External id of the virtual machine.
    # @return [Array<(VirtualNetworkInterfaceListResult, Fixnum, Hash)>] VirtualNetworkInterfaceListResult data, response status code and response headers
    def list_vifs_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagementPlaneApiFabricVifsApi.list_vifs ...'
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling ManagementPlaneApiFabricVifsApi.list_vifs, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling ManagementPlaneApiFabricVifsApi.list_vifs, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/fabric/vifs'

      # query parameters
      query_params = {}
      query_params[:'cursor'] = opts[:'cursor'] if !opts[:'cursor'].nil?
      query_params[:'host_id'] = opts[:'host_id'] if !opts[:'host_id'].nil?
      query_params[:'included_fields'] = opts[:'included_fields'] if !opts[:'included_fields'].nil?
      query_params[:'lport_attachment_id'] = opts[:'lport_attachment_id'] if !opts[:'lport_attachment_id'].nil?
      query_params[:'owner_vm_id'] = opts[:'owner_vm_id'] if !opts[:'owner_vm_id'].nil?
      query_params[:'page_size'] = opts[:'page_size'] if !opts[:'page_size'].nil?
      query_params[:'sort_ascending'] = opts[:'sort_ascending'] if !opts[:'sort_ascending'].nil?
      query_params[:'sort_by'] = opts[:'sort_by'] if !opts[:'sort_by'].nil?
      query_params[:'vm_id'] = opts[:'vm_id'] if !opts[:'vm_id'].nil?

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
        :return_type => 'VirtualNetworkInterfaceListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagementPlaneApiFabricVifsApi#list_vifs\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
