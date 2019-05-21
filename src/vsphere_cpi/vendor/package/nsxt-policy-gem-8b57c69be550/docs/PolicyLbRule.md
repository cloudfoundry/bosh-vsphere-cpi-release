# SwaggerClient::PolicyLbRule

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
**path_match** | **String** | This condition is used to match URIs(Uniform Resource Identifier) of HTTP request messages. The URI field can be specified as a regluar expression. If an HTTP request message is requesting an URI which matches specified regular expression, it matches the condition. The syntax of whole URI looks like this: scheme:[//[user[:password]@]host[:port]][/path][?query][#fragment] This condition matches only the path part of entire URI. The path_match field is used as a regular expression to match URI path of HTTP requests. For example, to match any URI that has \&quot;/image/\&quot; or \&quot;/images/\&quot;, uri field can be specified as: \&quot;/image[s]?/\&quot;. The regular  expressions in load balancer rules use the features common to both  Java regular expressions and Perl Compatible Regular Expressions  (PCREs) with some restrictions. Reference http://www.pcre .org for  PCRE and the NSX-T Administrator&#39;s Guide for the restrictions.  Please note, when regular expressions are used in JSON (JavaScript  Object Notation) string, every backslash character (\\) needs to be  escaped by one additional backslash character.  | [optional] 
**host_match** | **String** | This condition is used to match HTTP request messages by the specific HTTP header field, Host.  The Host request header specifies the domain name of the server. The supplied Host HTTP header match condition will be matched as a regular expression. The regular expressions in load balancer rules use the features common to both Java regular expressions and Perl Compatible Regular Expressions (PCREs) with some restrictions. Reference http://www.pcre .org for PCRE and the NSX-T Administrator&#39;s Guide for the restrictions. Please note, when regular expressions are used in JSON (JavaScript Object Notation) string, every backslash character (\\) needs to be escaped by one additional backslash character.  | [optional] 
**lb_virtual_server** | **String** | The path of PolicyLbVirtualServer to bind to this PolicyLbRule and its Group  | [optional] 
**sequence_number** | **Integer** | This field is used to resolve conflicts between multiple PolicyLbRules associated with a single PolicyLbVirtualServer and will be applied numerically or low to high  | [optional] 
**match_strategy** | **String** | If more than one match condition is specified, then matching strategy determines if all conditions should match or any one condition should match for the LB Rule to be considered a match. - ALL indicates that both host_match and path_match must match for this PolicyLbRule to be considered a match - ANY indicates that either host_match or patch match may match for this PolicyLbRule to be considered a match  | [optional] [default to &#39;ANY&#39;]


