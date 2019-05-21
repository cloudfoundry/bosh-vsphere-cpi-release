# SwaggerClient::VsphereClusterNodeVMDeploymentConfig

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**placement_type** | **String** | Specifies the config for the platform through which to deploy the VM  | 
**dns_servers** | **Array&lt;String&gt;** | List of DNS servers. If DHCP is used, the default DNS servers associated with the DHCP server will be used instead. Required if using static IP.  | [optional] 
**ntp_servers** | **Array&lt;String&gt;** | List of NTP servers. To use hostnames, a DNS server must be defined. If not using DHCP, a DNS server should be specified under dns_servers.  | [optional] 
**management_network_id** | **String** | Distributed portgroup identifier to which the management vnic of cluster node VM will be connected.  | 
**enable_ssh** | **BOOLEAN** | If true, the SSH service will automatically be started on the VM. Enabling SSH service is not recommended for security reasons.  | [optional] [default to false]
**allow_ssh_root_login** | **BOOLEAN** | If true, the root user will be allowed to log into the VM. Allowing root SSH logins is not recommended for security reasons.  | [optional] [default to false]
**compute_id** | **String** | The cluster node VM will be deployed on the specified cluster or resourcepool for specified VC server.  | 
**vc_id** | **String** | The VC-specific identifiers will be resolved on this VC, so all other identifiers specified in the config must belong to this vCenter server.  | 
**storage_id** | **String** | The cluster node VM will be deployed on the specified datastore in the specified VC server. User must ensure that storage is accessible by the specified cluster/host.  | 
**default_gateway_addresses** | **Array&lt;String&gt;** | The default gateway for the VM to be deployed must be specified if all the other VMs it communicates with are not in the same subnet. Do not specify this field and management_port_subnets to use DHCP. Note: only single IPv4 default gateway address is supported and it must belong to management network. IMPORTANT: VMs deployed using DHCP are currently not supported, so this parameter should be specified.  | [optional] 
**management_port_subnets** | [**Array&lt;IPSubnet&gt;**](IPSubnet.md) | IP Address and subnet configuration for the management port. Do not specify this field and default_gateway_addresses to use DHCP. Note: only one IPv4 address is supported for the management port. IMPORTANT: VMs deployed using DHCP are currently not supported, so this parameter should be specified.  | [optional] 
**host_id** | **String** | The cluster node VM will be deployed on the specified host in the specified VC server within the cluster if host_id is specified. Note: User must ensure that storage and specified networks are accessible by this host.  | [optional] 
**hostname** | **String** | Desired host name/FQDN for the VM to be deployed | 


