# SwaggerClient::VsphereDeploymentConfig

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**placement_type** | **String** |  | 
**data_network_ids** | **Array&lt;String&gt;** | List of distributed portgroup or VLAN logical identifiers to which the datapath serving vnics of edge node vm will be connected.  | 
**dns_servers** | **Array&lt;String&gt;** | List of DNS servers.  | [optional] 
**ntp_servers** | **Array&lt;String&gt;** | List of NTP servers.  | [optional] 
**management_network_id** | **String** | Distributed portgroup identifier to which the management vnic of edge node vm will be connected. This portgroup must have connectivity with MP and CCP. A VLAN logical switch identifier may also be specified.  | 
**enable_ssh** | **BOOLEAN** | Enabling SSH service is not recommended for security reasons.  | [optional] [default to false]
**allow_ssh_root_login** | **BOOLEAN** | Allowing root SSH logins is not recommended for security reasons.  | [optional] [default to false]
**compute_id** | **String** | The edge node vm will be deployed on the specified cluster or resourcepool. Note - all the hosts must have nsx fabric prepared in the specified cluster.  | 
**search_domains** | **Array&lt;String&gt;** | List of domain names that are used to complete unqualified host names.  | [optional] 
**vc_id** | **String** | The vc specific identifiers will be resolved on this VC. So all other identifiers specified here must belong to this vcenter server.  | 
**storage_id** | **String** | The edge node vm will be deployed on the specified datastore. User must ensure that storage is accessible by the specified cluster/host.  | 
**default_gateway_addresses** | **Array&lt;String&gt;** | The default gateway for edge node must be specified if all the nodes it communicates with are not in the same subnet. Note: Only single IPv4 default gateway address is supported and it must belong to management network.  | [optional] 
**management_port_subnets** | [**Array&lt;IPSubnet&gt;**](IPSubnet.md) | IP Address and subnet configuration for the management port. Note: only one IPv4 address is supported for the management port.  | [optional] 
**host_id** | **String** | The edge node vm will be deployed on the specified Host within the cluster if host_id is specified. Note - User must ensure that storage and specified networks are accessible by this host.  | [optional] 
**hostname** | **String** | Host name or FQDN for edge node. | 


