=begin
#NSX-T Manager API

#VMware NSX-T Manager REST API

OpenAPI spec version: 2.5.1.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

require 'uri'

module NSXT
  class ManagementPlaneApiPoolManagementIpBlocksApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # Allocate or Release an IP Address from a Ip Subnet
    # Allocates or releases an IP address from the specified IP subnet. To allocate an address, include ?action=ALLOCATE in the request and a \"{}\" in the request body. When the request is successful, the response is \"allocation_id\": \"<ip-address>\", where <ip-address> is an IP address from the specified pool. To release an IP address (return it back to the pool), include ?action=RELEASE in the request and \"allocation_id\":<ip-address> in the request body, where <ip-address> is the address to be released. When the request is successful, the response is NULL. 
    # @param subnet_id IP subnet id
    # @param allocation_ip_address 
    # @param action Specifies allocate or release action
    # @param [Hash] opts the optional parameters
    # @return [AllocationIpAddress]
    def allocate_or_release_from_ip_block_subnet(subnet_id, allocation_ip_address, action, opts = {})
      data, _status_code, _headers = allocate_or_release_from_ip_block_subnet_with_http_info(subnet_id, allocation_ip_address, action, opts)
      data
    end

    # Allocate or Release an IP Address from a Ip Subnet
    # Allocates or releases an IP address from the specified IP subnet. To allocate an address, include ?action&#x3D;ALLOCATE in the request and a \&quot;{}\&quot; in the request body. When the request is successful, the response is \&quot;allocation_id\&quot;: \&quot;&lt;ip-address&gt;\&quot;, where &lt;ip-address&gt; is an IP address from the specified pool. To release an IP address (return it back to the pool), include ?action&#x3D;RELEASE in the request and \&quot;allocation_id\&quot;:&lt;ip-address&gt; in the request body, where &lt;ip-address&gt; is the address to be released. When the request is successful, the response is NULL. 
    # @param subnet_id IP subnet id
    # @param allocation_ip_address 
    # @param action Specifies allocate or release action
    # @param [Hash] opts the optional parameters
    # @return [Array<(AllocationIpAddress, Fixnum, Hash)>] AllocationIpAddress data, response status code and response headers
    def allocate_or_release_from_ip_block_subnet_with_http_info(subnet_id, allocation_ip_address, action, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagementPlaneApiPoolManagementIpBlocksApi.allocate_or_release_from_ip_block_subnet ...'
      end
      # verify the required parameter 'subnet_id' is set
      if @api_client.config.client_side_validation && subnet_id.nil?
        fail ArgumentError, "Missing the required parameter 'subnet_id' when calling ManagementPlaneApiPoolManagementIpBlocksApi.allocate_or_release_from_ip_block_subnet"
      end
      # verify the required parameter 'allocation_ip_address' is set
      if @api_client.config.client_side_validation && allocation_ip_address.nil?
        fail ArgumentError, "Missing the required parameter 'allocation_ip_address' when calling ManagementPlaneApiPoolManagementIpBlocksApi.allocate_or_release_from_ip_block_subnet"
      end
      # verify the required parameter 'action' is set
      if @api_client.config.client_side_validation && action.nil?
        fail ArgumentError, "Missing the required parameter 'action' when calling ManagementPlaneApiPoolManagementIpBlocksApi.allocate_or_release_from_ip_block_subnet"
      end
      # verify enum value
      if @api_client.config.client_side_validation && !['ALLOCATE', 'RELEASE'].include?(action)
        fail ArgumentError, "invalid value for 'action', must be one of ALLOCATE, RELEASE"
      end
      # resource path
      local_var_path = '/pools/ip-subnets/{subnet-id}'.sub('{' + 'subnet-id' + '}', subnet_id.to_s)

      # query parameters
      query_params = {}
      query_params[:'action'] = action

      # header parameters
      header_params = {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = {}

      # http body (model)
      post_body = @api_client.object_to_http_body(allocation_ip_address)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'AllocationIpAddress')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagementPlaneApiPoolManagementIpBlocksApi#allocate_or_release_from_ip_block_subnet\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create a new IP address block.
    # Creates a new IPv4 address block using the specified cidr. cidr is a required parameter. display_name & description are optional parameters 
    # @param ip_block 
    # @param [Hash] opts the optional parameters
    # @return [IpBlock]
    def create_ip_block(ip_block, opts = {})
      data, _status_code, _headers = create_ip_block_with_http_info(ip_block, opts)
      data
    end

    # Create a new IP address block.
    # Creates a new IPv4 address block using the specified cidr. cidr is a required parameter. display_name &amp; description are optional parameters 
    # @param ip_block 
    # @param [Hash] opts the optional parameters
    # @return [Array<(IpBlock, Fixnum, Hash)>] IpBlock data, response status code and response headers
    def create_ip_block_with_http_info(ip_block, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagementPlaneApiPoolManagementIpBlocksApi.create_ip_block ...'
      end
      # verify the required parameter 'ip_block' is set
      if @api_client.config.client_side_validation && ip_block.nil?
        fail ArgumentError, "Missing the required parameter 'ip_block' when calling ManagementPlaneApiPoolManagementIpBlocksApi.create_ip_block"
      end
      # resource path
      local_var_path = '/pools/ip-blocks'

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
      post_body = @api_client.object_to_http_body(ip_block)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'IpBlock')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagementPlaneApiPoolManagementIpBlocksApi#create_ip_block\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Create subnet of specified size within an IP block
    # Carves out a subnet of requested size from the specified IP block. The \"size\" parameter  and the \"block_id \" are the requireds field while invoking this API. If the IP block has sufficient resources/space to allocate a subnet of specified size, the response will contain all the details of the newly created subnet including the display_name, description, cidr & allocation_ranges. Returns a conflict error if the IP block does not have enough resources/space to allocate a subnet of the requested size. 
    # @param ip_block_subnet 
    # @param [Hash] opts the optional parameters
    # @return [IpBlockSubnet]
    def create_ip_block_subnet(ip_block_subnet, opts = {})
      data, _status_code, _headers = create_ip_block_subnet_with_http_info(ip_block_subnet, opts)
      data
    end

    # Create subnet of specified size within an IP block
    # Carves out a subnet of requested size from the specified IP block. The \&quot;size\&quot; parameter  and the \&quot;block_id \&quot; are the requireds field while invoking this API. If the IP block has sufficient resources/space to allocate a subnet of specified size, the response will contain all the details of the newly created subnet including the display_name, description, cidr &amp; allocation_ranges. Returns a conflict error if the IP block does not have enough resources/space to allocate a subnet of the requested size. 
    # @param ip_block_subnet 
    # @param [Hash] opts the optional parameters
    # @return [Array<(IpBlockSubnet, Fixnum, Hash)>] IpBlockSubnet data, response status code and response headers
    def create_ip_block_subnet_with_http_info(ip_block_subnet, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagementPlaneApiPoolManagementIpBlocksApi.create_ip_block_subnet ...'
      end
      # verify the required parameter 'ip_block_subnet' is set
      if @api_client.config.client_side_validation && ip_block_subnet.nil?
        fail ArgumentError, "Missing the required parameter 'ip_block_subnet' when calling ManagementPlaneApiPoolManagementIpBlocksApi.create_ip_block_subnet"
      end
      # resource path
      local_var_path = '/pools/ip-subnets'

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
      post_body = @api_client.object_to_http_body(ip_block_subnet)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:POST, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'IpBlockSubnet')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagementPlaneApiPoolManagementIpBlocksApi#create_ip_block_subnet\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete an IP Address Block
    # Deletes the IP address block with specified id if it exists. IP block cannot be deleted if there are allocated subnets from the block. 
    # @param block_id IP address block id
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def delete_ip_block(block_id, opts = {})
      delete_ip_block_with_http_info(block_id, opts)
      nil
    end

    # Delete an IP Address Block
    # Deletes the IP address block with specified id if it exists. IP block cannot be deleted if there are allocated subnets from the block. 
    # @param block_id IP address block id
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def delete_ip_block_with_http_info(block_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagementPlaneApiPoolManagementIpBlocksApi.delete_ip_block ...'
      end
      # verify the required parameter 'block_id' is set
      if @api_client.config.client_side_validation && block_id.nil?
        fail ArgumentError, "Missing the required parameter 'block_id' when calling ManagementPlaneApiPoolManagementIpBlocksApi.delete_ip_block"
      end
      # resource path
      local_var_path = '/pools/ip-blocks/{block-id}'.sub('{' + 'block-id' + '}', block_id.to_s)

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
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagementPlaneApiPoolManagementIpBlocksApi#delete_ip_block\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Delete subnet within an IP block
    # Deletes a subnet with specified id within a given IP address block. Deletion is allowed only when there are no allocated IP addresses from that subnet. 
    # @param subnet_id Subnet id
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def delete_ip_block_subnet(subnet_id, opts = {})
      delete_ip_block_subnet_with_http_info(subnet_id, opts)
      nil
    end

    # Delete subnet within an IP block
    # Deletes a subnet with specified id within a given IP address block. Deletion is allowed only when there are no allocated IP addresses from that subnet. 
    # @param subnet_id Subnet id
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Fixnum, Hash)>] nil, response status code and response headers
    def delete_ip_block_subnet_with_http_info(subnet_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagementPlaneApiPoolManagementIpBlocksApi.delete_ip_block_subnet ...'
      end
      # verify the required parameter 'subnet_id' is set
      if @api_client.config.client_side_validation && subnet_id.nil?
        fail ArgumentError, "Missing the required parameter 'subnet_id' when calling ManagementPlaneApiPoolManagementIpBlocksApi.delete_ip_block_subnet"
      end
      # resource path
      local_var_path = '/pools/ip-subnets/{subnet-id}'.sub('{' + 'subnet-id' + '}', subnet_id.to_s)

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
      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagementPlaneApiPoolManagementIpBlocksApi#delete_ip_block_subnet\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # List subnets within an IP block
    # Returns information about all subnets present within an IP address block. Information includes subnet's id, display_name, description, cidr and allocation ranges. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :block_id 
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [IpBlockSubnetListResult]
    def list_ip_block_subnets(opts = {})
      data, _status_code, _headers = list_ip_block_subnets_with_http_info(opts)
      data
    end

    # List subnets within an IP block
    # Returns information about all subnets present within an IP address block. Information includes subnet&#39;s id, display_name, description, cidr and allocation ranges. 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :block_id 
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(IpBlockSubnetListResult, Fixnum, Hash)>] IpBlockSubnetListResult data, response status code and response headers
    def list_ip_block_subnets_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagementPlaneApiPoolManagementIpBlocksApi.list_ip_block_subnets ...'
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling ManagementPlaneApiPoolManagementIpBlocksApi.list_ip_block_subnets, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling ManagementPlaneApiPoolManagementIpBlocksApi.list_ip_block_subnets, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/pools/ip-subnets'

      # query parameters
      query_params = {}
      query_params[:'block_id'] = opts[:'block_id'] if !opts[:'block_id'].nil?
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
        :return_type => 'IpBlockSubnetListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagementPlaneApiPoolManagementIpBlocksApi#list_ip_block_subnets\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Returns list of configured IP address blocks.
    # Returns information about configured IP address blocks. Information includes the id, display name, description & CIDR of IP address blocks 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer) (default to 1000)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [IpBlockListResult]
    def list_ip_blocks(opts = {})
      data, _status_code, _headers = list_ip_blocks_with_http_info(opts)
      data
    end

    # Returns list of configured IP address blocks.
    # Returns information about configured IP address blocks. Information includes the id, display name, description &amp; CIDR of IP address blocks 
    # @param [Hash] opts the optional parameters
    # @option opts [String] :cursor Opaque cursor to be used for getting next page of records (supplied by current result page)
    # @option opts [String] :included_fields Comma separated list of fields that should be included in query result
    # @option opts [Integer] :page_size Maximum number of results to return in this page (server may return fewer)
    # @option opts [BOOLEAN] :sort_ascending 
    # @option opts [String] :sort_by Field by which records are sorted
    # @return [Array<(IpBlockListResult, Fixnum, Hash)>] IpBlockListResult data, response status code and response headers
    def list_ip_blocks_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagementPlaneApiPoolManagementIpBlocksApi.list_ip_blocks ...'
      end
      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling ManagementPlaneApiPoolManagementIpBlocksApi.list_ip_blocks, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'page_size'].nil? && opts[:'page_size'] < 0
        fail ArgumentError, 'invalid value for "opts[:"page_size"]" when calling ManagementPlaneApiPoolManagementIpBlocksApi.list_ip_blocks, must be greater than or equal to 0.'
      end

      # resource path
      local_var_path = '/pools/ip-blocks'

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
        :return_type => 'IpBlockListResult')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagementPlaneApiPoolManagementIpBlocksApi#list_ip_blocks\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get IP address block information.
    # Returns information about the IP address block with specified id. Information includes id, display_name, description & cidr. 
    # @param block_id IP address block id
    # @param [Hash] opts the optional parameters
    # @return [IpBlock]
    def read_ip_block(block_id, opts = {})
      data, _status_code, _headers = read_ip_block_with_http_info(block_id, opts)
      data
    end

    # Get IP address block information.
    # Returns information about the IP address block with specified id. Information includes id, display_name, description &amp; cidr. 
    # @param block_id IP address block id
    # @param [Hash] opts the optional parameters
    # @return [Array<(IpBlock, Fixnum, Hash)>] IpBlock data, response status code and response headers
    def read_ip_block_with_http_info(block_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagementPlaneApiPoolManagementIpBlocksApi.read_ip_block ...'
      end
      # verify the required parameter 'block_id' is set
      if @api_client.config.client_side_validation && block_id.nil?
        fail ArgumentError, "Missing the required parameter 'block_id' when calling ManagementPlaneApiPoolManagementIpBlocksApi.read_ip_block"
      end
      # resource path
      local_var_path = '/pools/ip-blocks/{block-id}'.sub('{' + 'block-id' + '}', block_id.to_s)

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
        :return_type => 'IpBlock')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagementPlaneApiPoolManagementIpBlocksApi#read_ip_block\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Get the subnet within an IP block
    # Returns information about the subnet with specified id within a given IP address block. Information includes display_name, description, cidr and allocation_ranges. 
    # @param subnet_id Subnet id
    # @param [Hash] opts the optional parameters
    # @return [IpBlockSubnet]
    def read_ip_block_subnet(subnet_id, opts = {})
      data, _status_code, _headers = read_ip_block_subnet_with_http_info(subnet_id, opts)
      data
    end

    # Get the subnet within an IP block
    # Returns information about the subnet with specified id within a given IP address block. Information includes display_name, description, cidr and allocation_ranges. 
    # @param subnet_id Subnet id
    # @param [Hash] opts the optional parameters
    # @return [Array<(IpBlockSubnet, Fixnum, Hash)>] IpBlockSubnet data, response status code and response headers
    def read_ip_block_subnet_with_http_info(subnet_id, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagementPlaneApiPoolManagementIpBlocksApi.read_ip_block_subnet ...'
      end
      # verify the required parameter 'subnet_id' is set
      if @api_client.config.client_side_validation && subnet_id.nil?
        fail ArgumentError, "Missing the required parameter 'subnet_id' when calling ManagementPlaneApiPoolManagementIpBlocksApi.read_ip_block_subnet"
      end
      # resource path
      local_var_path = '/pools/ip-subnets/{subnet-id}'.sub('{' + 'subnet-id' + '}', subnet_id.to_s)

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
        :return_type => 'IpBlockSubnet')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagementPlaneApiPoolManagementIpBlocksApi#read_ip_block_subnet\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
    # Update an IP Address Block
    # Modifies the IP address block with specifed id. display_name, description and cidr are parameters that can be modified. If a new cidr is specified, it should contain all existing subnets in the IP block. Returns a conflict error if the IP address block cidr can not be modified due to the presence of subnets that it contains. Eg: If the IP block contains a subnet 192.168.0.1/24 and we try to change the IP block cidr to 10.1.0.1/16, it results in a conflict. 
    # @param block_id IP address block id
    # @param ip_block 
    # @param [Hash] opts the optional parameters
    # @return [IpBlock]
    def update_ip_block(block_id, ip_block, opts = {})
      data, _status_code, _headers = update_ip_block_with_http_info(block_id, ip_block, opts)
      data
    end

    # Update an IP Address Block
    # Modifies the IP address block with specifed id. display_name, description and cidr are parameters that can be modified. If a new cidr is specified, it should contain all existing subnets in the IP block. Returns a conflict error if the IP address block cidr can not be modified due to the presence of subnets that it contains. Eg: If the IP block contains a subnet 192.168.0.1/24 and we try to change the IP block cidr to 10.1.0.1/16, it results in a conflict. 
    # @param block_id IP address block id
    # @param ip_block 
    # @param [Hash] opts the optional parameters
    # @return [Array<(IpBlock, Fixnum, Hash)>] IpBlock data, response status code and response headers
    def update_ip_block_with_http_info(block_id, ip_block, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: ManagementPlaneApiPoolManagementIpBlocksApi.update_ip_block ...'
      end
      # verify the required parameter 'block_id' is set
      if @api_client.config.client_side_validation && block_id.nil?
        fail ArgumentError, "Missing the required parameter 'block_id' when calling ManagementPlaneApiPoolManagementIpBlocksApi.update_ip_block"
      end
      # verify the required parameter 'ip_block' is set
      if @api_client.config.client_side_validation && ip_block.nil?
        fail ArgumentError, "Missing the required parameter 'ip_block' when calling ManagementPlaneApiPoolManagementIpBlocksApi.update_ip_block"
      end
      # resource path
      local_var_path = '/pools/ip-blocks/{block-id}'.sub('{' + 'block-id' + '}', block_id.to_s)

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
      post_body = @api_client.object_to_http_body(ip_block)
      auth_names = ['BasicAuth']
      data, status_code, headers = @api_client.call_api(:PUT, local_var_path,
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => 'IpBlock')
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: ManagementPlaneApiPoolManagementIpBlocksApi#update_ip_block\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
