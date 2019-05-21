# SwaggerClient::LBServerSslProfileBinding

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**server_auth_ca_paths** | **Array&lt;String&gt;** | If server auth type is REQUIRED, server certificate must be signed by one of the trusted Certificate Authorities (CAs), also referred to as root CAs, whose self signed certificates are specified.  | [optional] 
**client_certificate_path** | **String** | To support client authentication (load balancer acting as a client authenticating to the backend server), client certificate can be specified in the server-side SSL profile binding  | [optional] 
**server_auth** | **String** | Server authentication mode. | [optional] [default to &#39;AUTO_APPLY&#39;]
**certificate_chain_depth** | **Integer** | Authentication depth is used to set the verification depth in the server certificates chain.  | [optional] [default to 3]
**server_auth_crl_paths** | **Array&lt;String&gt;** | A Certificate Revocation List (CRL) can be specified in the server-side SSL profile binding to disallow compromised server certificates.  | [optional] 
**ssl_profile_path** | **String** | Server SSL profile defines reusable, application-independent server side SSL properties.  | [optional] 


