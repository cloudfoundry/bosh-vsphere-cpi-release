# SwaggerClient::PolicyInfraEnforcementPointsEdgeClusterEdgeNodeApi

All URIs are relative to *https://nsxmanager.your.domain/policy/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**list_edge_nodes_under_edge_cluster_for_enforcement_point**](PolicyInfraEnforcementPointsEdgeClusterEdgeNodeApi.md#list_edge_nodes_under_edge_cluster_for_enforcement_point) | **GET** /infra/sites/{site-id}/enforcement-points/{enforcementpoint-id}/edge-clusters/{edge-cluster-id}/edge-nodes | List Edge Nodes under an Enforcement Point, Edge Cluster
[**read_edge_node_under_edge_cluster_for_enforcement_point**](PolicyInfraEnforcementPointsEdgeClusterEdgeNodeApi.md#read_edge_node_under_edge_cluster_for_enforcement_point) | **GET** /infra/sites/{site-id}/enforcement-points/{enforcementpoint-id}/edge-clusters/{edge-cluster-id}/edge-nodes/{edge-node-id} | Read a Edge Node under an Enforcement Point, Edge Cluster


# **list_edge_nodes_under_edge_cluster_for_enforcement_point**
> PolicyEdgeNodeListResult list_edge_nodes_under_edge_cluster_for_enforcement_point(site_id, enforcementpoint_id, edge_cluster_id, opts)

List Edge Nodes under an Enforcement Point, Edge Cluster

Paginated list of all Edge Nodes under an Enforcement Point, Edge Cluster 

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

api_instance = SwaggerClient::PolicyInfraEnforcementPointsEdgeClusterEdgeNodeApi.new

site_id = 'site_id_example' # String | 

enforcementpoint_id = 'enforcementpoint_id_example' # String | 

edge_cluster_id = 'edge_cluster_id_example' # String | 

opts = { 
  cursor: 'cursor_example', # String | Opaque cursor to be used for getting next page of records (supplied by current result page)
  include_mark_for_delete_objects: false, # BOOLEAN | Include objects that are marked for deletion in results
  included_fields: 'included_fields_example', # String | Comma separated list of fields that should be included in query result
  page_size: 1000, # Integer | Maximum number of results to return in this page (server may return fewer)
  sort_ascending: true, # BOOLEAN | 
  sort_by: 'sort_by_example' # String | Field by which records are sorted
}

begin
  #List Edge Nodes under an Enforcement Point, Edge Cluster
  result = api_instance.list_edge_nodes_under_edge_cluster_for_enforcement_point(site_id, enforcementpoint_id, edge_cluster_id, opts)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraEnforcementPointsEdgeClusterEdgeNodeApi->list_edge_nodes_under_edge_cluster_for_enforcement_point: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **site_id** | **String**|  | 
 **enforcementpoint_id** | **String**|  | 
 **edge_cluster_id** | **String**|  | 
 **cursor** | **String**| Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
 **include_mark_for_delete_objects** | **BOOLEAN**| Include objects that are marked for deletion in results | [optional] [default to false]
 **included_fields** | **String**| Comma separated list of fields that should be included in query result | [optional] 
 **page_size** | **Integer**| Maximum number of results to return in this page (server may return fewer) | [optional] [default to 1000]
 **sort_ascending** | **BOOLEAN**|  | [optional] 
 **sort_by** | **String**| Field by which records are sorted | [optional] 

### Return type

[**PolicyEdgeNodeListResult**](PolicyEdgeNodeListResult.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



# **read_edge_node_under_edge_cluster_for_enforcement_point**
> PolicyEdgeNode read_edge_node_under_edge_cluster_for_enforcement_point(site_id, enforcementpoint_id, edge_cluster_id, edge_node_id)

Read a Edge Node under an Enforcement Point, Edge Cluster

Read a Edge Node under an Enforcement Point, Edge Cluster 

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

api_instance = SwaggerClient::PolicyInfraEnforcementPointsEdgeClusterEdgeNodeApi.new

site_id = 'site_id_example' # String | Site id

enforcementpoint_id = 'enforcementpoint_id_example' # String | EnforcementPoint id

edge_cluster_id = 'edge_cluster_id_example' # String | Edge Cluster id

edge_node_id = 'edge_node_id_example' # String | Edge Node id


begin
  #Read a Edge Node under an Enforcement Point, Edge Cluster
  result = api_instance.read_edge_node_under_edge_cluster_for_enforcement_point(site_id, enforcementpoint_id, edge_cluster_id, edge_node_id)
  p result
rescue SwaggerClient::ApiError => e
  puts "Exception when calling PolicyInfraEnforcementPointsEdgeClusterEdgeNodeApi->read_edge_node_under_edge_cluster_for_enforcement_point: #{e}"
end
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **site_id** | **String**| Site id | 
 **enforcementpoint_id** | **String**| EnforcementPoint id | 
 **edge_cluster_id** | **String**| Edge Cluster id | 
 **edge_node_id** | **String**| Edge Node id | 

### Return type

[**PolicyEdgeNode**](PolicyEdgeNode.md)

### Authorization

[BasicAuth](../README.md#BasicAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json



