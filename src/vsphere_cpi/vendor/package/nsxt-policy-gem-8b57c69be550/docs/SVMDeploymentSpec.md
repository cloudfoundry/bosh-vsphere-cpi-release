# SwaggerClient::SVMDeploymentSpec

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**min_host_version** | **String** | Minimum host version supported by this ovf. If a host in the deployment cluster is having version less than this, then service deployment will not happen on that host. | [optional] 
**ovf_url** | **String** | Location of the partner VM OVF to be deployed. | 
**service_form_factor** | **String** | Supported ServiceInsertion Form Factor for the OVF deployment. The default FormFactor is Medium. | [optional] [default to &#39;MEDIUM&#39;]
**host_type** | **String** | Host Type on which the specified OVF can be deployed. | 
**name** | **String** | Deployment Spec name for ease of use, since multiple DeploymentSpec can be specified. | [optional] 


