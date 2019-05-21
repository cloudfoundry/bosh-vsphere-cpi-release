# SwaggerClient::RouteMapEntry

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**action** | **String** | Action for the route map entry  | 
**community_list_matches** | [**Array&lt;CommunityMatchCriteria&gt;**](CommunityMatchCriteria.md) | Community list match criteria for route map. Properties community_list_matches and prefix_list_matches are mutually exclusive and cannot be used in the same route map entry.  | [optional] 
**set** | [**RouteMapEntrySet**](RouteMapEntrySet.md) | Set criteria for route map entry  | [optional] 
**prefix_list_matches** | **Array&lt;String&gt;** | Prefix list match criteria for route map. Properties community_list_matches and prefix_list_matches are mutually exclusive and cannot be used in the same route map entry.  | [optional] 


