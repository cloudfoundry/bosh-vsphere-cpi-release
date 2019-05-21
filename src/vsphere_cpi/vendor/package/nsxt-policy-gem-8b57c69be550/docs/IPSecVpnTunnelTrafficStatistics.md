# SwaggerClient::IpSecVpnTunnelTrafficStatistics

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**packets_sent_other_error** | **Integer** | Total number of packets dropped while sending for any reason.  | [optional] 
**packets_out** | **Integer** | Total number of outgoing packets on outbound Security association.  | [optional] 
**dropped_packets_out** | **Integer** | Total number of outgoing packets dropped on outbound security association.  | [optional] 
**integrity_failures** | **Integer** | Total number of packets dropped due to integrity failures.  | [optional] 
**nomatching_policy_errors** | **Integer** | Number of packets dropped because of no matching policy is available.  | [optional] 
**sa_mismatch_errors_in** | **Integer** | Totoal number of security association mismatch errors on incoming packets.  | [optional] 
**peer_subnet** | **String** | Tunnel peer subnet in IPv4 CIDR Block format.  | [optional] 
**replay_errors** | **Integer** | Total number of packets dropped due to replay check on that Security association.  | [optional] 
**bytes_out** | **Integer** | Total number of outgoing bytes on outbound Security association.  | [optional] 
**packets_received_other_error** | **Integer** | Total number of incoming packets dropped on inbound Security association.  | [optional] 
**dropped_packets_in** | **Integer** | Total number of incoming packets dropped on inbound security association.  | [optional] 
**encryption_failures** | **Integer** | Total number of packets dropped because of failure in encryption.  | [optional] 
**sa_mismatch_errors_out** | **Integer** | Totoal number of security association mismatch errors on outgoing packets.  | [optional] 
**tunnel_down_reason** | **String** | Gives the detailed reason about the tunnel when it is down. If tunnel is UP tunnel down reason will be empty.  | [optional] 
**local_subnet** | **String** | Tunnel local subnet in IPv4 CIDR Block format.  | [optional] 
**bytes_in** | **Integer** | Total number of incoming bytes on inbound Security association.  | [optional] 
**decryption_failures** | **Integer** | Total number of packets dropped due to decryption failures.  | [optional] 
**seq_number_overflow_error** | **Integer** | Total number of packets dropped while sending due to overflow in sequence number.  | [optional] 
**packets_in** | **Integer** | Total number of incoming packets on inbound Security association.  | [optional] 
**tunnel_status** | **String** | Specifies the status of tunnel, if it is UP/DOWN.  | [optional] 


