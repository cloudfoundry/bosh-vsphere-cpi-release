# SwaggerClient::NsxTDnsAnswer

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**resource_type** | **String** | Resource type of the DNS forwarder nslookup answer.  | 
**enforcement_point_path** | **String** | Policy path referencing the enforcement point from where the DNS forwarder nslookup answer is fetched.  | [optional] 
**authoritative_answers** | [**Array&lt;NsxTDnsQueryAnswer&gt;**](NsxTDnsQueryAnswer.md) | Authoritative answers | [optional] 
**edge_node_id** | **String** | ID of the edge node that performed the query.  | 
**dns_server** | **String** | Dns server ip address and port, format is \&quot;ip address#port\&quot;.  | 
**non_authoritative_answers** | [**Array&lt;NsxTDnsQueryAnswer&gt;**](NsxTDnsQueryAnswer.md) | Non authoritative answers | [optional] 
**raw_answer** | **String** | It can be NXDOMAIN or error message which is not consisted of authoritative_answer or non_authoritative_answer.  | [optional] 


