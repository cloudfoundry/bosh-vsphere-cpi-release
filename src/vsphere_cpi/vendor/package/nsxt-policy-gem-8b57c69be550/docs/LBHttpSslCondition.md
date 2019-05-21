# SwaggerClient::LbHttpSslCondition

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**inverse** | **BOOLEAN** | A flag to indicate whether reverse the match result of this condition | [optional] [default to false]
**type** | **String** | Type of load balancer rule condition | 
**client_supported_ssl_ciphers** | **Array&lt;String&gt;** | Cipher list which supported by client | [optional] 
**client_certificate_issuer_dn** | [**LbClientCertificateIssuerDnCondition**](LbClientCertificateIssuerDnCondition.md) | The issuer DN match condition of the client certificate for an established SSL connection  | [optional] 
**client_certificate_subject_dn** | [**LbClientCertificateSubjectDnCondition**](LbClientCertificateSubjectDnCondition.md) | The subject DN match condition of the client certificate for an established SSL connection  | [optional] 
**used_ssl_cipher** | **String** | Cipher used for an established SSL connection | [optional] 
**session_reused** | **String** | The type of SSL session reused | [optional] [default to &#39;IGNORE&#39;]
**used_protocol** | **String** | Protocol of an established SSL connection | [optional] 


