# SwaggerClient::ServerSslProfileBinding

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**server_auth_crl_ids** | **Array&lt;String&gt;** | A Certificate Revocation List (CRL) can be specified in the server-side SSL profile binding to disallow compromised server certificates.  | [optional] 
**server_auth** | **String** | server authentication mode | [optional] [default to &#39;IGNORE&#39;]
**certificate_chain_depth** | **Integer** | authentication depth is used to set the verification depth in the server certificates chain.  | [optional] [default to 3]
**client_certificate_id** | **String** | To support client authentication (load balancer acting as a client authenticating to the backend server), client certificate can be specified in the server-side SSL profile binding  | [optional] 
**server_auth_ca_ids** | **Array&lt;String&gt;** | If server auth type is REQUIRED, server certificate must be signed by one of the trusted Certificate Authorities (CAs), also referred to as root CAs, whose self signed certificates are specified.  | [optional] 
**ssl_profile_id** | **String** | Server SSL profile defines reusable, application-independent server side SSL properties.  | [optional] 


