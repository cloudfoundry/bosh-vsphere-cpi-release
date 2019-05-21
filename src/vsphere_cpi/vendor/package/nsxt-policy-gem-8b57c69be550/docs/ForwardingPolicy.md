# SwaggerClient::ForwardingPolicy

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**_self** | [**SelfResourceLink**](SelfResourceLink.md) | Link to this resource | [optional] 
**_links** | [**Array&lt;ResourceLink&gt;**](ResourceLink.md) | The server will populate this field when returing the resource. Ignored on PUT and POST. | [optional] 
**_schema** | **String** | Schema for this resource | [optional] 
**_revision** | **Integer** | The _revision property describes the current revision of the resource. To prevent clients from overwriting each other&#39;s changes, PUT operations must include the current _revision of the resource, which clients should obtain by issuing a GET operation. If the _revision provided in a PUT request is missing or stale, the operation will be rejected. | [optional] 
**_system_owned** | **BOOLEAN** | Indicates system owned resource | [optional] 
**display_name** | **String** | Defaults to ID if not set | [optional] 
**description** | **String** | Description of this resource | [optional] 
**tags** | [**Array&lt;Tag&gt;**](Tag.md) | Opaque identifiers meaningful to the API user | [optional] 
**_create_user** | **String** | ID of the user who created this resource | [optional] 
**_protection** | **String** | Protection status is one of the following: PROTECTED - the client who retrieved the entity is not allowed             to modify it. NOT_PROTECTED - the client who retrieved the entity is allowed                 to modify it REQUIRE_OVERRIDE - the client who retrieved the entity is a super                    user and can modify it, but only when providing                    the request header X-Allow-Overwrite&#x3D;true. UNKNOWN - the _protection field could not be determined for this           entity.  | [optional] 
**_create_time** | **Integer** | Timestamp of resource creation | [optional] 
**_last_modified_time** | **Integer** | Timestamp of last modification | [optional] 
**_last_modified_user** | **String** | ID of the user who last modified this resource | [optional] 
**id** | **String** | Unique identifier of this resource | [optional] 
**resource_type** | **String** | The type of this resource. | [optional] 
**path** | **String** | Absolute path of this object | [optional] 
**parent_path** | **String** | Path of its parent | [optional] 
**relative_path** | **String** | Path relative from its parent | [optional] 
**children** | [**Array&lt;ChildPolicyConfigResource&gt;**](ChildPolicyConfigResource.md) | subtree for this type within policy tree containing nested elements.  | [optional] 
**marked_for_delete** | **BOOLEAN** | Intent objects are not directly deleted from the system when a delete is invoked on them. They are marked for deletion and only when all the realized entities for that intent object gets deleted, the intent object is deleted. Objects that are marked for deletion are not returned in GET call. One can use the search API to get these objects.  | [optional] [default to false]
**category** | **String** | - Distributed Firewall - Policy framework provides five pre-defined categories for classifying a security policy. They are \&quot;Ethernet\&quot;,\&quot;Emergency\&quot;, \&quot;Infrastructure\&quot; \&quot;Environment\&quot; and \&quot;Application\&quot;. There is a pre-determined order in which the policy framework manages the priority of these security policies. Ethernet category is for supporting layer 2 firewall rules. The other four categories are applicable for layer 3 rules. Amongst them, the Emergency category has the highest priority followed by Infrastructure, Environment and then Application rules. Administrator can choose to categorize a security policy into the above categories or can choose to leave it empty. If empty it will have the least precedence w.r.t the above four categories. - Edge Firewall - Policy Framework for Edge Firewall provides six pre-defined categories \&quot;Emergency\&quot;, \&quot;SystemRules\&quot;, \&quot;SharedPreRules\&quot;, \&quot;LocalGatewayRules\&quot;, \&quot;AutoServiceRules\&quot; and \&quot;Default\&quot;, in order of priority of rules. All categories are allowed for Gatetway Policies that belong to &#39;default&#39; Domain. However, for user created domains, category is restricted to \&quot;SharedPreRules\&quot; or \&quot;LocalGatewayRules\&quot; only. Also, the users can add/modify/delete rules from only the \&quot;SharedPreRules\&quot; and \&quot;LocalGatewayRules\&quot; categories. If user doesn&#39;t specify the category then defaulted to \&quot;Rules\&quot;. System generated category is used by NSX created rules, for example BFD rules. Autoplumbed category used by NSX verticals to autoplumb data path rules. Finally, \&quot;Default\&quot; category is the placeholder default rules with lowest in the order of priority.  | [optional] 
**stateful** | **BOOLEAN** | Stateful or Stateless nature of security policy is enforced on all rules in this security policy. When it is stateful, the state of the network connects are tracked and a stateful packet inspection is performed. Layer3 security policies can be stateful or stateless. By default, they are stateful. Layer2 security policies can only be stateless.  | [optional] 
**locked** | **BOOLEAN** | Indicates whether a security policy should be locked. If the security policy is locked by a user, then no other user would be able to modify this security policy. Once the user releases the lock, other users can update this security policy.  | [optional] [default to false]
**tcp_strict** | **BOOLEAN** | Ensures that a 3 way TCP handshake is done before the data packets are sent. tcp_strict&#x3D;true is supported only for stateful security policies.  | [optional] 
**lock_modified_by** | **String** | ID of the user who last modified the lock for the secruity policy.  | [optional] 
**rules** | [**Array&lt;ForwardingRule&gt;**](ForwardingRule.md) | Rules that are a part of this ForwardingPolicy | [optional] 
**lock_modified_time** | **Integer** | SecurityPolicy locked/unlocked time in epoch milliseconds. | [optional] 
**sequence_number** | **Integer** | This field is used to resolve conflicts between security policies across domains. In order to change the sequence number of a security policy, it is recommended to send a PUT request to the following URL /infra/domains/&lt;domain-id&gt;/security-policy?action&#x3D;revise The sequence number field will reflect the value of the computed sequence number upon execution of the above mentioned PUT request. For scenarios where the administrator is using a template to update several security policies, the only way to set the sequence number is to explicitly specify the sequence number for each security policy.  | [optional] 
**comments** | **String** | Comments for security policy lock/unlock. | [optional] 


