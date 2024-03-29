$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'nsxt_manager_client'))
=begin
#NSX-T Manager API

#VMware NSX-T Manager REST API

OpenAPI spec version: 2.5.1.0.0

Generated by: https://github.com/swagger-api/swagger-codegen.git
Swagger Codegen version: 2.4.19

=end

# Common files
require 'nsxt_manager_client/api_client'
require 'nsxt_manager_client/api_error'
require 'nsxt_manager_client/version'
require 'nsxt_manager_client/configuration'

# Models
require 'nsxt_manager_client/models/alg_type_ns_service'
require 'nsxt_manager_client/models/api_error'
require 'nsxt_manager_client/models/assigned_by_dhcp'
require 'nsxt_manager_client/models/attachment_context'
require 'nsxt_manager_client/models/base_host_switch_profile'
require 'nsxt_manager_client/models/base_switching_profile'
require 'nsxt_manager_client/models/bfd_health_monitoring_profile'
require 'nsxt_manager_client/models/bpdu_filter'
require 'nsxt_manager_client/models/certificate'
require 'nsxt_manager_client/models/certificate_list'
require 'nsxt_manager_client/models/cpu_core_config_for_enhanced_networking_stack_switch'
require 'nsxt_manager_client/models/ds_rule'
require 'nsxt_manager_client/models/ds_service'
require 'nsxt_manager_client/models/dhcp_filter'
require 'nsxt_manager_client/models/directory_group'
require 'nsxt_manager_client/models/discovered_resource'
require 'nsxt_manager_client/models/dscp'
require 'nsxt_manager_client/models/duplicate_ip_detection'
require 'nsxt_manager_client/models/edge_cluster_member_allocation_pool'
require 'nsxt_manager_client/models/edge_cluster_member_allocation_profile'
require 'nsxt_manager_client/models/effective_ip_address_member_list_result'
require 'nsxt_manager_client/models/effective_member_resource_list_result'
require 'nsxt_manager_client/models/effective_member_type_list_result'
require 'nsxt_manager_client/models/egress_rate_shaper'
require 'nsxt_manager_client/models/embedded_resource'
require 'nsxt_manager_client/models/ether_type_ns_service'
require 'nsxt_manager_client/models/extra_config'
require 'nsxt_manager_client/models/extra_config_host_switch_profile'
require 'nsxt_manager_client/models/fire_wall_service_association_list_result'
require 'nsxt_manager_client/models/firewall_rule'
require 'nsxt_manager_client/models/firewall_service'
require 'nsxt_manager_client/models/guest_info'
require 'nsxt_manager_client/models/ha_vip_config'
require 'nsxt_manager_client/models/host_infra_traffic_type'
require 'nsxt_manager_client/models/host_switch'
require 'nsxt_manager_client/models/host_switch_profile_type_id_entry'
require 'nsxt_manager_client/models/host_switch_spec'
require 'nsxt_manager_client/models/icmp_type_ns_service'
require 'nsxt_manager_client/models/igmp_type_ns_service'
require 'nsxt_manager_client/models/ip_protocol_ns_service'
require 'nsxt_manager_client/models/ip_set'
require 'nsxt_manager_client/models/i_pv6_profiles'
require 'nsxt_manager_client/models/ingress_broadcast_rate_shaper'
require 'nsxt_manager_client/models/ingress_rate_shaper'
require 'nsxt_manager_client/models/ip_address_info'
require 'nsxt_manager_client/models/ip_assignment_spec'
require 'nsxt_manager_client/models/ip_discovery_switching_profile'
require 'nsxt_manager_client/models/ip_mac_pair'
require 'nsxt_manager_client/models/ip_pool'
require 'nsxt_manager_client/models/ip_pool_range'
require 'nsxt_manager_client/models/ip_pool_subnet'
require 'nsxt_manager_client/models/ipfix_config'
require 'nsxt_manager_client/models/ipfix_dfw_config'
require 'nsxt_manager_client/models/ipfix_dfw_template_parameters'
require 'nsxt_manager_client/models/ipfix_service_association_list_result'
require 'nsxt_manager_client/models/ipfix_switch_config'
require 'nsxt_manager_client/models/key_value_pair'
require 'nsxt_manager_client/models/l4_port_set_ns_service'
require 'nsxt_manager_client/models/lag'
require 'nsxt_manager_client/models/lb_pool'
require 'nsxt_manager_client/models/lb_pool_list_result'
require 'nsxt_manager_client/models/lb_snat_auto_map'
require 'nsxt_manager_client/models/lb_snat_ip_element'
require 'nsxt_manager_client/models/lb_snat_ip_pool'
require 'nsxt_manager_client/models/lb_snat_translation'
require 'nsxt_manager_client/models/list_result'
require 'nsxt_manager_client/models/lldp_host_switch_profile'
require 'nsxt_manager_client/models/load_balancer_allocation_pool'
require 'nsxt_manager_client/models/logical_port'
require 'nsxt_manager_client/models/logical_port_attachment'
require 'nsxt_manager_client/models/logical_port_list_result'
require 'nsxt_manager_client/models/logical_router'
require 'nsxt_manager_client/models/logical_router_config'
require 'nsxt_manager_client/models/logical_router_list_result'
require 'nsxt_manager_client/models/logical_switch'
require 'nsxt_manager_client/models/mac_set'
require 'nsxt_manager_client/models/mac_learning_spec'
require 'nsxt_manager_client/models/mac_management_switching_profile'
require 'nsxt_manager_client/models/mac_pool'
require 'nsxt_manager_client/models/mac_range'
require 'nsxt_manager_client/models/managed_resource'
require 'nsxt_manager_client/models/ns_group'
require 'nsxt_manager_client/models/ns_group_complex_expression'
require 'nsxt_manager_client/models/ns_group_expression'
require 'nsxt_manager_client/models/ns_group_expression_list'
require 'nsxt_manager_client/models/ns_group_list_result'
require 'nsxt_manager_client/models/ns_group_simple_expression'
require 'nsxt_manager_client/models/ns_group_tag_expression'
require 'nsxt_manager_client/models/ns_service_element'
require 'nsxt_manager_client/models/named_teaming_policy'
require 'nsxt_manager_client/models/nioc_profile'
require 'nsxt_manager_client/models/node'
require 'nsxt_manager_client/models/node_id_services_map'
require 'nsxt_manager_client/models/owner_resource_link'
require 'nsxt_manager_client/models/packet_address_classifier'
require 'nsxt_manager_client/models/pnic'
require 'nsxt_manager_client/models/pool_member'
require 'nsxt_manager_client/models/pool_member_group'
require 'nsxt_manager_client/models/pool_member_setting'
require 'nsxt_manager_client/models/pool_member_setting_list'
require 'nsxt_manager_client/models/pool_usage'
require 'nsxt_manager_client/models/port_mirroring_switching_profile'
require 'nsxt_manager_client/models/preconfigured_endpoint'
require 'nsxt_manager_client/models/preconfigured_host_switch'
require 'nsxt_manager_client/models/preconfigured_host_switch_spec'
require 'nsxt_manager_client/models/principal_identity'
require 'nsxt_manager_client/models/principal_identity_list'
require 'nsxt_manager_client/models/qos_base_rate_shaper'
require 'nsxt_manager_client/models/qos_switching_profile'
require 'nsxt_manager_client/models/rate_limits'
require 'nsxt_manager_client/models/related_api_error'
require 'nsxt_manager_client/models/resource'
require 'nsxt_manager_client/models/resource_allocation'
require 'nsxt_manager_client/models/resource_link'
require 'nsxt_manager_client/models/resource_reference'
require 'nsxt_manager_client/models/revisioned_resource'
require 'nsxt_manager_client/models/self_resource_link'
require 'nsxt_manager_client/models/service_association_list_result'
require 'nsxt_manager_client/models/spoof_guard_switching_profile'
require 'nsxt_manager_client/models/standard_host_switch'
require 'nsxt_manager_client/models/standard_host_switch_spec'
require 'nsxt_manager_client/models/static_ip_list_spec'
require 'nsxt_manager_client/models/static_ip_mac_list_spec'
require 'nsxt_manager_client/models/static_ip_pool_spec'
require 'nsxt_manager_client/models/switch_security_switching_profile'
require 'nsxt_manager_client/models/switching_profile_type_id_entry'
require 'nsxt_manager_client/models/tag'
require 'nsxt_manager_client/models/teaming_policy'
require 'nsxt_manager_client/models/transport_node'
require 'nsxt_manager_client/models/transport_zone_end_point'
require 'nsxt_manager_client/models/transport_zone_profile'
require 'nsxt_manager_client/models/transport_zone_profile_type_id_entry'
require 'nsxt_manager_client/models/trunk_vlan_range'
require 'nsxt_manager_client/models/trust_object_data'
require 'nsxt_manager_client/models/unassociated_vm_list_result'
require 'nsxt_manager_client/models/uplink'
require 'nsxt_manager_client/models/uplink_host_switch_profile'
require 'nsxt_manager_client/models/vip_subnet'
require 'nsxt_manager_client/models/vif_attachment_context'
require 'nsxt_manager_client/models/virtual_machine'
require 'nsxt_manager_client/models/virtual_machine_list_result'
require 'nsxt_manager_client/models/virtual_network_interface'
require 'nsxt_manager_client/models/virtual_network_interface_list_result'
require 'nsxt_manager_client/models/vlan_trunk_spec'
require 'nsxt_manager_client/models/vmknic_network'
require 'nsxt_manager_client/models/x509_certificate'

# APIs
require 'nsxt_manager_client/api/management_plane_api_fabric_vifs_api'
require 'nsxt_manager_client/api/management_plane_api_fabric_virtual_machines_api'
require 'nsxt_manager_client/api/management_plane_api_grouping_objects_ns_groups_api'
require 'nsxt_manager_client/api/management_plane_api_logical_routing_and_services_logical_routers_api'
require 'nsxt_manager_client/api/management_plane_api_logical_switching_logical_switch_ports_api'
require 'nsxt_manager_client/api/management_plane_api_nsx_component_administration_trust_management_certificate_api'
require 'nsxt_manager_client/api/management_plane_api_nsx_component_administration_trust_management_principal_identity_api'
require 'nsxt_manager_client/api/management_plane_api_services_loadbalancer_api'

module NSXT
  class << self
    # Customize default settings for the SDK using block.
    #   NSXT.configure do |config|
    #     config.username = "xxx"
    #     config.password = "xxx"
    #   end
    # If no block given, return the default Configuration object.
    def configure
      if block_given?
        yield(Configuration.default)
      else
        Configuration.default
      end
    end
  end
end
