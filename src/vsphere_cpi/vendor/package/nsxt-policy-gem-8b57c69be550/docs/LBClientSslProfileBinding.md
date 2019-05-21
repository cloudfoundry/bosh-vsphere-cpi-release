# SwaggerClient::LBClientSslProfileBinding

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**client_auth** | **String** | Client authentication mode. | [optional] [default to &#39;IGNORE&#39;]
**client_auth_crl_paths** | **Array&lt;String&gt;** | A Certificate Revocation List (CRL) can be specified in the client-side SSL profile binding to disallow compromised client certificates.  | [optional] 
**client_auth_ca_paths** | **Array&lt;String&gt;** | If client auth type is REQUIRED, client certificate must be signed by one of the trusted Certificate Authorities (CAs), also referred to as root CAs, whose self signed certificates are specified.  | [optional] 
**certificate_chain_depth** | **Integer** | Authentication depth is used to set the verification depth in the client certificates chain.  | [optional] [default to 3]
**sni_certificate_paths** | **Array&lt;String&gt;** | Client-side SSL profile binding allows multiple certificates, for different hostnames, to be bound to the same virtual server.  | [optional] 
**default_certificate_path** | **String** | A default certificate should be specified which will be used if the server does not host multiple hostnames on the same IP address or if the client does not support SNI extension.  | 
**ssl_profile_path** | **String** | Client SSL profile defines reusable, application-independent client side SSL properties.  | [optional] 


