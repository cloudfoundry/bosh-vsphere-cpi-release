# SwaggerClient::TransportNodeTemplateState

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**state** | **String** | Transport node template state on individual hosts of ComputeCollection which enabled automated transport code creation. &#39;FAILED_TO_CREATE&#39; means transport node isn&#39;t created. &#39;IN_PROGRESS&#39; means transport node is in progress of creation. &#39;FAILED_TO_REALIZE&#39; means transport node has been created, but failed on host realization, it will repush to host by NSX later. &#39;SUCCESS&#39; means transport node creation is succeeded.  | [optional] 
**node_id** | **String** | node id | 
**transport_node_id** | **String** | transport node id | [optional] 


