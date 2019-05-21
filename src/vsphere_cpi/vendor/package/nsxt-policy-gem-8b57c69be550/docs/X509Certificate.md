# SwaggerClient::X509Certificate

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**rsa_public_key_modulus** | **String** | An RSA public key is made up of the modulus and the public exponent. Modulus is wrap around number | [optional] 
**dsa_public_key_y** | **String** | One of the DSA cryptogaphic algorithm&#39;s strength parameters | [optional] 
**is_ca** | **BOOLEAN** | True if this is a CA certificate | [optional] 
**issuer** | **String** | the certificate issuers complete distinguished name | [optional] 
**not_after** | **Integer** | the time in epoch milliseconds at which the certificate becomes invalid | [optional] 
**signature** | **String** | the signature value(the raw signature bits) used for signing and validate the cert | [optional] 
**dsa_public_key_q** | **String** | One of the DSA cryptogaphic algorithm&#39;s strength parameters, sub-prime | [optional] 
**dsa_public_key_p** | **String** | One of the DSA cryptogaphic algorithm&#39;s strength parameters, prime | [optional] 
**rsa_public_key_exponent** | **String** | An RSA public key is made up of the modulus and the public exponent. Exponent is a power number | [optional] 
**public_key_algo** | **String** | Cryptographic algorithm used by the public key for data encryption | [optional] 
**is_valid** | **BOOLEAN** | True if this certificate is valid | [optional] 
**issuer_cn** | **String** | the certificate issuer&#39;s common name | [optional] 
**version** | **String** | Certificate version (default v1) | [optional] 
**subject_cn** | **String** | the certificate owner&#39;s common name | [optional] 
**signature_algorithm** | **String** | the algorithm used by the Certificate Authority to sign the certificate | [optional] 
**serial_number** | **String** | certificate&#39;s serial number | [optional] 
**dsa_public_key_g** | **String** | One of the DSA cryptogaphic algorithm&#39;s strength parameters, base | [optional] 
**public_key_length** | **Integer** | size measured in bits of the public/private keys used in a cryptographic algorithm | [optional] 
**not_before** | **Integer** | the time in epoch milliseconds at which the certificate becomes valid | [optional] 
**subject** | **String** | the certificate owners complete distinguished name | [optional] 


