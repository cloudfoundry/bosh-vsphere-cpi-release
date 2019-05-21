# SwaggerClient::IPSecVPNPolicyRule

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**_revision** | **Integer** | The _revision property describes the current revision of the resource. To prevent clients from overwriting each other&#39;s changes, PUT operations must include the current _revision of the resource, which clients should obtain by issuing a GET operation. If the _revision provided in a PUT request is missing or stale, the operation will be rejected. | [optional] 
**_owner** | [**OwnerResourceLink**](OwnerResourceLink.md) | Owner of this resource | [optional] 
**display_name** | **String** | Defaults to ID if not set | [optional] 
**id** | **String** | Unique policy id. | [optional] 
**resource_type** | **String** | The type of this resource. | [optional] 
**description** | **String** | Description of this resource | [optional] 
**sources** | [**Array&lt;IPSecVPNPolicySubnet&gt;**](IPSecVPNPolicySubnet.md) | List of local subnets. | [optional] 
**action** | **String** | PROTECT - Protect rules are defined per policy based IPSec VPN session. BYPASS - Bypass rules are defined per IPSec VPN service and affects all policy based IPSec VPN sessions. Bypass rules are prioritized over protect rules.  | [optional] [default to &#39;PROTECT&#39;]
**enabled** | **BOOLEAN** | A flag to enable/disable the policy rule. | [optional] [default to true]
**logged** | **BOOLEAN** | A flag to enable/disable the logging for the policy rule. | [optional] [default to false]
**destinations** | [**Array&lt;IPSecVPNPolicySubnet&gt;**](IPSecVPNPolicySubnet.md) | List of peer subnets. | [optional] 


