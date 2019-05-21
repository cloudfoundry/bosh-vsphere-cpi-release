# SwaggerClient::IdfwNsgroupVmDetailListResult

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**cursor** | **String** | Opaque cursor to be used for getting next page of records (supplied by current result page) | [optional] 
**sort_ascending** | **BOOLEAN** | If true, results are sorted in ascending order | [optional] 
**sort_by** | **String** | Field by which records are sorted | [optional] 
**result_count** | **Integer** | Count of results found (across all pages), set only on first page | [optional] 
**ns_group_id** | **String** | NSGroup ID | [optional] 
**results** | [**Array&lt;IdfwVmDetail&gt;**](IdfwVmDetail.md) | List of user login/session data for a single VM | 


