# SwaggerClient::CommunityMatchOperation

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**match_operator** | **String** | Match operator for communities from provided community list id. MATCH_ANY will match any community MATCH_ALL will match all communities MATCH_EXACT will do exact match on community MATCH_NONE [operator not supported] will not match any community MATCH_REGEX will match community by evaluating regular expression  | [optional] [default to &#39;MATCH_ANY&#39;]
**regular_expression** | **String** | Regular expression to match BGP communities. If match_operator is MATCH_REGEX then this value must be specified.  | [optional] 
**community_list_id** | **String** | ID of BGP community list. This value is not required when match_operator is MATCH_REGEX otherwise required.  | [optional] 


