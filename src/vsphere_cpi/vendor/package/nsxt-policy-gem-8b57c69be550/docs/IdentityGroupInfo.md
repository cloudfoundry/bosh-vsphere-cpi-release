# SwaggerClient::IdentityGroupInfo

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**distinguished_name** | **String** | Each LDAP object is uniquely identified by its distinguished name (DN). A DN is a sequence of relative distinguished names (RDN) connected by commas. e.g. CN&#x3D;Larry Cole,CN&#x3D;admin,DC&#x3D;corp,DC&#x3D;acme,DC&#x3D;com.  | 
**domain_base_distinguished_name** | **String** | This is the base distinguished name for the domain where this particular group resides. (e.g. dc&#x3D;example,dc&#x3D;com) Each active directory domain has a domain naming context (NC), which contains domain-specific data. The root of this naming context is represented by a domain&#39;s distinguished name (DN) and is typically referred to as the NC head.  | 
**sid** | **String** | A security identifier (SID) is a unique value of variable length used to identify a trustee. A SID consists of the following components: The revision level of the SID structure; A 48-bit identifier authority value that identifies the authority that issued the SID; A variable number of subauthority or relative identifier (RID) values that uniquely identify the trustee relative to the authority that issued the SID. This field is only populated for Microsoft Active Directory identity store.  | [optional] 


