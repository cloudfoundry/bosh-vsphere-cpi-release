# SwaggerClient::FileTransferProtocol

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**protocol_name** | **String** | Protocol name | [default to &#39;sftp&#39;]
**ssh_fingerprint** | **String** | The expected SSH fingerprint of the server. If the server&#39;s fingerprint does not match this fingerprint, the connection will be terminated.  Only ECDSA fingerprints hashed with SHA256 are supported. To obtain the host&#39;s ssh fingerprint, you should connect via some method other than SSH to obtain this information. You can use one of these commands to view the key&#39;s fingerprint: 1. ssh-keygen -l -E sha256 -f ssh_host_ecdsa_key.pub 2. awk &#39;{print $2}&#39; ssh_host_ecdsa_key.pub | base64 -d | sha256sum -b |    sed &#39;s/ .*$//&#39; | xxd -r -p | base64 | sed &#39;s/.//44g&#39; |    awk &#39;{print \&quot;SHA256:\&quot;$1}&#39;  | 
**authentication_scheme** | [**FileTransferAuthenticationScheme**](FileTransferAuthenticationScheme.md) | Scheme to authenticate if required | 


