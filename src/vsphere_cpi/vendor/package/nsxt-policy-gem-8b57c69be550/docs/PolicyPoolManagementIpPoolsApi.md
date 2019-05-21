# SwaggerClient::PolicyPoolManagementIpPoolsApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**create_or_patch_ip_address_block**](PolicyPoolManagementIpPoolsApi.md#create_or_patch_ip_address_block) | **PATCH** /infra/ip-blocks/{ip-block-id} | Create a new IPBlock
[**create_or_patch_ip_address_pool**](PolicyPoolManagementIpPoolsApi.md#create_or_patch_ip_address_pool) | **PATCH** /infra/ip-pools/{ip-pool-id} | Create a new IP address pool
[**create_or_patch_ip_address_pool_allocation**](PolicyPoolManagementIpPoolsApi.md#create_or_patch_ip_address_pool_allocation) | **PATCH** /infra/ip-pools/{ip-pool-id}/ip-allocations/{ip-allocation-id} | Records intent to allocate an IP Address from an IP Pool
[**create_or_patch_ip_address_pool_subnet**](PolicyPoolManagementIpPoolsApi.md#create_or_patch_ip_address_pool_subnet) | **PATCH** /infra/ip-pools/{ip-pool-id}/ip-subnets/{ip-subnet-id} | Create a new IP Subnet
[**create_or_replace_ip_address_block**](PolicyPoolManagementIpPoolsApi.md#create_or_replace_ip_address_block) | **PUT** /infra/ip-blocks/{ip-block-id} | Create or Replace IpAddressBlock
[**create_or_replace_ip_address_pool**](PolicyPoolManagementIpPoolsApi.md#create_or_replace_ip_address_pool) | **PUT** /infra/ip-pools/{ip-pool-id} | Create or Replace IpAddressPool
[**create_or_replace_ip_address_pool_allocation**](PolicyPoolManagementIpPoolsApi.md#create_or_replace_ip_address_pool_allocation) | **PUT** /infra/ip-pools/{ip-pool-id}/ip-allocations/{ip-allocation-id} | Records intent to allocate an IP Address from an IP Pool
[**create_or_replace_ip_address_pool_subnet**](PolicyPoolManagementIpPoolsApi.md#create_or_replace_ip_address_pool_subnet) | **PUT** /infra/ip-pools/{ip-pool-id}/ip-subnets/{ip-subnet-id} | Create a new IP Subnet
[**delete_ip_address_block**](PolicyPoolManagementIpPoolsApi.md#delete_ip_address_block) | **DELETE** /infra/ip-blocks/{ip-block-id} | Delete an IpAddressBlock
[**delete_ip_address_pool**](PolicyPoolManagementIpPoolsApi.md#delete_ip_address_pool) | **DELETE** /infra/ip-pools/{ip-pool-id} | Delete an IpAddressPool
[**delete_ip_address_pool_allocation**](PolicyPoolManagementIpPoolsApi.md#delete_ip_address_pool_allocation) | **DELETE** /infra/ip-pools/{ip-pool-id}/ip-allocations/{ip-allocation-id} | Records intent to release an IP from an IpPool.
[**delete_ip_address_pool_subnet**](PolicyPoolManagementIpPoolsApi.md#delete_ip_address_pool_subnet) | **DELETE** /infra/ip-pools/{ip-pool-id}/ip-subnets/{ip-subnet-id} | Delete an IpAddressPoolSubnet
[**list_ip_address_blocks**](PolicyPoolManagementIpPoolsApi.md#list_ip_address_blocks) | **GET** /infra/ip-blocks | List IpAddressBlocks
[**list_ip_address_pool_allocations**](PolicyPoolManagementIpPoolsApi.md#list_ip_address_pool_allocations) | **GET** /infra/ip-pools/{ip-pool-id}/ip-allocations | List IpAddressPool Allocations
[**list_ip_address_pool_subnets**](PolicyPoolManagementIpPoolsApi.md#list_ip_address_pool_subnets) | **GET** /infra/ip-pools/{ip-pool-id}/ip-subnets | List IpAddressPoolSubnets
[**list_ip_address_pools**](PolicyPoolManagementIpPoolsApi.md#list_ip_address_pools) | **GET** /infra/ip-pools | List IpAddressPools
[**read_ip_address_block**](PolicyPoolManagementIpPoolsApi.md#read_ip_address_block) | **GET** /infra/ip-blocks/{ip-block-id} | Read a IpAddressBlock
[**read_ip_address_pool**](PolicyPoolManagementIpPoolsApi.md#read_ip_address_pool) | **GET** /infra/ip-pools/{ip-pool-id} | Read an IpAddressPool
[**read_ip_address_pool_allocation**](PolicyPoolManagementIpPoolsApi.md#read_ip_address_pool_allocation) | **GET** /infra/ip-pools/{ip-pool-id}/ip-allocations/{ip-allocation-id} | Read policy IpPool allocation
[**read_ip_address_pool_subnet**](PolicyPoolManagementIpPoolsApi.md#read_ip_address_pool_subnet) | **GET** /infra/ip-pools/{ip-pool-id}/ip-subnets/{ip-subnet-id} | Read an IpAddressPoolSubnet


# **create_or_patch_ip_address_block**
> create_or_patch_ip_address_block(ip_block_id, ip_address_block)

Create a new IPBlock

Creates a new IpAddressBlock with specified ID if not already present. If IpAddressBlock of given ID is already present, then the instance is updated with specified attributes. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

ip_block_id = 'ip_block_id_example' # String | 

ip_address_block = SwaggerClient::IpAddressBlock.new # IpAddressBlock | 


begin
  #Create a new IPBlock
  api_instance.create_or_patch_ip_address_block(ip_block_id, ip_address_block)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->create_or_patch_ip_address_block: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_block_id** | **String**|  | 
 **ip_address_block** | [**IpAddressBlock**](IpAddressBlock.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_patch_ip_address_pool**
> create_or_patch_ip_address_pool(ip_pool_id, ip_address_pool)

Create a new IP address pool

Creates a new IpAddressPool with specified ID if not already present. If IpAddressPool of given ID is already present, then the instance is updated. This is a full replace. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

ip_pool_id = 'ip_pool_id_example' # String | 

ip_address_pool = SwaggerClient::IpAddressPool.new # IpAddressPool | 


begin
  #Create a new IP address pool
  api_instance.create_or_patch_ip_address_pool(ip_pool_id, ip_address_pool)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->create_or_patch_ip_address_pool: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_pool_id** | **String**|  | 
 **ip_address_pool** | [**IpAddressPool**](IpAddressPool.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_patch_ip_address_pool_allocation**
> create_or_patch_ip_address_pool_allocation(ip_pool_id, ip_allocation_id, ip_address_allocation)

Records intent to allocate an IP Address from an IP Pool

If allocation of the same ID is found, this is a no-op. If no allocation of the specified ID is found, then a new allocation is created. An allocation cannot be updated once created. When an allocation is requested from an IpAddressPool, the IP could be allocated from any subnet in the pool that has the available capacity. Request to allocate an IP will fail if no subnet was previously created. If specific IP was requested, the status of allocation is reflected in the realized state. If any IP is requested, the IP finally allocated is obtained by polling on the realized state until the allocated IP is returned in the extended attributes. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

ip_pool_id = 'ip_pool_id_example' # String | 

ip_allocation_id = 'ip_allocation_id_example' # String | 

ip_address_allocation = SwaggerClient::IpAddressAllocation.new # IpAddressAllocation | 


begin
  #Records intent to allocate an IP Address from an IP Pool
  api_instance.create_or_patch_ip_address_pool_allocation(ip_pool_id, ip_allocation_id, ip_address_allocation)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->create_or_patch_ip_address_pool_allocation: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_pool_id** | **String**|  | 
 **ip_allocation_id** | **String**|  | 
 **ip_address_allocation** | [**IpAddressAllocation**](IpAddressAllocation.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_patch_ip_address_pool_subnet**
> create_or_patch_ip_address_pool_subnet(ip_pool_id, ip_subnet_id, ip_address_pool_subnet)

Create a new IP Subnet

Creates a new IpAddressPoolSubnet with the specified ID if it does not already exist. If a IpAddressPoolSubnet of the given ID already exists, IpAddressPoolSubnet will be updated. This is a full replace. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

ip_pool_id = 'ip_pool_id_example' # String | 

ip_subnet_id = 'ip_subnet_id_example' # String | 

ip_address_pool_subnet = SwaggerClient::IpAddressPoolSubnet.new # IpAddressPoolSubnet | 


begin
  #Create a new IP Subnet
  api_instance.create_or_patch_ip_address_pool_subnet(ip_pool_id, ip_subnet_id, ip_address_pool_subnet)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->create_or_patch_ip_address_pool_subnet: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_pool_id** | **String**|  | 
 **ip_subnet_id** | **String**|  | 
 **ip_address_pool_subnet** | [**IpAddressPoolSubnet**](IpAddressPoolSubnet.md)|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_ip_address_block**
> IpAddressBlock create_or_replace_ip_address_block(ip_block_id, ip_address_block)

Create or Replace IpAddressBlock

Create a new IpAddressBlock with given ID if it does not exist. If IpAddressBlock with given ID already exists, it will update existing instance. This is a full replace. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

ip_block_id = 'ip_block_id_example' # String | 

ip_address_block = SwaggerClient::IpAddressBlock.new # IpAddressBlock | 


begin
  #Create or Replace IpAddressBlock
  result = api_instance.create_or_replace_ip_address_block(ip_block_id, ip_address_block)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->create_or_replace_ip_address_block: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_block_id** | **String**|  | 
 **ip_address_block** | [**IpAddressBlock**](IpAddressBlock.md)|  | 

### Return type

[**IpAddressBlock**](IpAddressBlock.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_ip_address_pool**
> IpAddressPool create_or_replace_ip_address_pool(ip_pool_id, ip_address_pool)

Create or Replace IpAddressPool

Create a new IpAddressPool with given ID if it does not exist. If IpAddressPool with given ID already exists, it will update existing instance. This is a full replace. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

ip_pool_id = 'ip_pool_id_example' # String | 

ip_address_pool = SwaggerClient::IpAddressPool.new # IpAddressPool | 


begin
  #Create or Replace IpAddressPool
  result = api_instance.create_or_replace_ip_address_pool(ip_pool_id, ip_address_pool)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->create_or_replace_ip_address_pool: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_pool_id** | **String**|  | 
 **ip_address_pool** | [**IpAddressPool**](IpAddressPool.md)|  | 

### Return type

[**IpAddressPool**](IpAddressPool.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_ip_address_pool_allocation**
> IpAddressAllocation create_or_replace_ip_address_pool_allocation(ip_pool_id, ip_allocation_id, ip_address_allocation)

Records intent to allocate an IP Address from an IP Pool

If allocation of the same ID is found, this is a no-op. If no allocation of the specified ID is found, then a new allocation is created. An allocation cannot be updated once created. When an IP allocation is requested from an IpAddressPool, the IP could be allocated from any subnet in the pool that has the available capacity. Request to allocate an IP will fail if no subnet was previously created. If specific IP was requested, the status of allocation is reflected in the realized state. If any IP is requested, the IP finally allocated is obtained by polling on the realized state until the allocated IP is returned in the extended attributes. An allocation cannot be updated once created. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

ip_pool_id = 'ip_pool_id_example' # String | 

ip_allocation_id = 'ip_allocation_id_example' # String | 

ip_address_allocation = SwaggerClient::IpAddressAllocation.new # IpAddressAllocation | 


begin
  #Records intent to allocate an IP Address from an IP Pool
  result = api_instance.create_or_replace_ip_address_pool_allocation(ip_pool_id, ip_allocation_id, ip_address_allocation)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->create_or_replace_ip_address_pool_allocation: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_pool_id** | **String**|  | 
 **ip_allocation_id** | **String**|  | 
 **ip_address_allocation** | [**IpAddressAllocation**](IpAddressAllocation.md)|  | 

### Return type

[**IpAddressAllocation**](IpAddressAllocation.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **create_or_replace_ip_address_pool_subnet**
> IpAddressPoolSubnet create_or_replace_ip_address_pool_subnet(ip_pool_id, ip_subnet_id, ip_address_pool_subnet)

Create a new IP Subnet

Creates a new IpAddressPoolSubnet with the specified ID if it does not already exist. If a IpAddressPoolSubnet of the given ID already exists, IpAddressPoolSubnet will be updated. This is a full replace. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

ip_pool_id = 'ip_pool_id_example' # String | 

ip_subnet_id = 'ip_subnet_id_example' # String | 

ip_address_pool_subnet = SwaggerClient::IpAddressPoolSubnet.new # IpAddressPoolSubnet | 


begin
  #Create a new IP Subnet
  result = api_instance.create_or_replace_ip_address_pool_subnet(ip_pool_id, ip_subnet_id, ip_address_pool_subnet)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->create_or_replace_ip_address_pool_subnet: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_pool_id** | **String**|  | 
 **ip_subnet_id** | **String**|  | 
 **ip_address_pool_subnet** | [**IpAddressPoolSubnet**](IpAddressPoolSubnet.md)|  | 

### Return type

[**IpAddressPoolSubnet**](IpAddressPoolSubnet.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_ip_address_block**
> delete_ip_address_block(ip_block_id)

Delete an IpAddressBlock

Delete the IpAddressBlock with the given id. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

ip_block_id = 'ip_block_id_example' # String | 


begin
  #Delete an IpAddressBlock
  api_instance.delete_ip_address_block(ip_block_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->delete_ip_address_block: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_block_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_ip_address_pool**
> delete_ip_address_pool(ip_pool_id)

Delete an IpAddressPool

Delete the IpAddressPool with the given id. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

ip_pool_id = 'ip_pool_id_example' # String | 


begin
  #Delete an IpAddressPool
  api_instance.delete_ip_address_pool(ip_pool_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->delete_ip_address_pool: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_pool_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_ip_address_pool_allocation**
> delete_ip_address_pool_allocation(ip_pool_id, ip_allocation_id)

Records intent to release an IP from an IpPool.

Releases the IP that was allocated for this allocation request 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

ip_pool_id = 'ip_pool_id_example' # String | 

ip_allocation_id = 'ip_allocation_id_example' # String | 


begin
  #Records intent to release an IP from an IpPool.
  api_instance.delete_ip_address_pool_allocation(ip_pool_id, ip_allocation_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->delete_ip_address_pool_allocation: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_pool_id** | **String**|  | 
 **ip_allocation_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **delete_ip_address_pool_subnet**
> delete_ip_address_pool_subnet(ip_pool_id, ip_subnet_id)

Delete an IpAddressPoolSubnet

Delete the IpAddressPoolSubnet with the given id. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

ip_pool_id = 'ip_pool_id_example' # String | 

ip_subnet_id = 'ip_subnet_id_example' # String | 


begin
  #Delete an IpAddressPoolSubnet
  api_instance.delete_ip_address_pool_subnet(ip_pool_id, ip_subnet_id)
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->delete_ip_address_pool_subnet: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_pool_id** | **String**|  | 
 **ip_subnet_id** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_ip_address_blocks**
> IpAddressBlockListResult list_ip_address_blocks(opts)

List IpAddressBlocks

Paginated list of IpAddressBlocks. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List IpAddressBlocks
  result = api_instance.list_ip_address_blocks(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->list_ip_address_blocks: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**IpAddressBlockListResult**](IpAddressBlockListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_ip_address_pool_allocations**
> IpAddressAllocationListResult list_ip_address_pool_allocations(ip_pool_id, opts)

List IpAddressPool Allocations

Returns information about which addresses have been allocated from a specified IP address pool in policy. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

ip_pool_id = 'ip_pool_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List IpAddressPool Allocations
  result = api_instance.list_ip_address_pool_allocations(ip_pool_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->list_ip_address_pool_allocations: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_pool_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**IpAddressAllocationListResult**](IpAddressAllocationListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_ip_address_pool_subnets**
> IpAddressPoolSubnetListResult list_ip_address_pool_subnets(ip_pool_id, opts)

List IpAddressPoolSubnets

Paginated list of IpAddressPoolSubnets. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

ip_pool_id = 'ip_pool_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List IpAddressPoolSubnets
  result = api_instance.list_ip_address_pool_subnets(ip_pool_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->list_ip_address_pool_subnets: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_pool_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**IpAddressPoolSubnetListResult**](IpAddressPoolSubnetListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **list_ip_address_pools**
> IpAddressPoolListResult list_ip_address_pools(opts)

List IpAddressPools

Paginated list of IpAddressPools. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List IpAddressPools
  result = api_instance.list_ip_address_pools(opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->list_ip_address_pools: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**IpAddressPoolListResult**](IpAddressPoolListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_ip_address_block**
> IpAddressBlock read_ip_address_block(ip_block_id)

Read a IpAddressBlock

Read IpAddressBlock with given Id. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

ip_block_id = 'ip_block_id_example' # String | 


begin
  #Read a IpAddressBlock
  result = api_instance.read_ip_address_block(ip_block_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->read_ip_address_block: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_block_id** | **String**|  | 

### Return type

[**IpAddressBlock**](IpAddressBlock.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_ip_address_pool**
> IpAddressPool read_ip_address_pool(ip_pool_id)

Read an IpAddressPool

Read IpAddressPool with given Id. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

ip_pool_id = 'ip_pool_id_example' # String | 


begin
  #Read an IpAddressPool
  result = api_instance.read_ip_address_pool(ip_pool_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->read_ip_address_pool: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_pool_id** | **String**|  | 

### Return type

[**IpAddressPool**](IpAddressPool.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_ip_address_pool_allocation**
> IpAddressAllocation read_ip_address_pool_allocation(ip_pool_id, ip_allocation_id)

Read policy IpPool allocation

Read a previously created allocation 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

ip_pool_id = 'ip_pool_id_example' # String | 

ip_allocation_id = 'ip_allocation_id_example' # String | 


begin
  #Read policy IpPool allocation
  result = api_instance.read_ip_address_pool_allocation(ip_pool_id, ip_allocation_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->read_ip_address_pool_allocation: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_pool_id** | **String**|  | 
 **ip_allocation_id** | **String**|  | 

### Return type

[**IpAddressAllocation**](IpAddressAllocation.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_ip_address_pool_subnet**
> IpAddressPoolSubnet read_ip_address_pool_subnet(ip_pool_id, ip_subnet_id)

Read an IpAddressPoolSubnet

Read IpAddressPoolSubnet with given Id. 

### Example
```ruby
# load the gem
require 'swagger_client'
# setup authorization
SwaggerClient.configure do |config|
  # Configure HTTP basic authorization: BasicAuth
  config.username = 'YOUR USERNAME'
  config.password = 'YOUR PASSWORD'
end

api_instance = SwaggerClient::PolicyPoolManagementIpPoolsApi.new

ip_pool_id = 'ip_pool_id_example' # String | 

ip_subnet_id = 'ip_subnet_id_example' # String | 


begin
  #Read an IpAddressPoolSubnet
  result = api_instance.read_ip_address_pool_subnet(ip_pool_id, ip_subnet_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyPoolManagementIpPoolsApi->read_ip_address_pool_subnet: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ip_pool_id** | **String**|  | 
 **ip_subnet_id** | **String**|  | 

### Return type

[**IpAddressPoolSubnet**](IpAddressPoolSubnet.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



