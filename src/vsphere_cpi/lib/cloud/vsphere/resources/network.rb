require 'cloud/vsphere/resources'

module VSphereCloud
  module Resources
    class Network
      include VimSdk
      include ObjectStringifier
      stringify_with :name, :mob, :bosh_name

      attr_reader :mob, :client, :bosh_name
      def self.make_network_resource(bosh_name, mob, client)
        case mob
        when VimSdk::Vim::Dvs::DistributedVirtualPortgroup
          DistributedVirtualPortGroupNetwork.new(bosh_name, mob, client)
        when VimSdk::Vim::OpaqueNetwork
          OpaqueNetwork.new(bosh_name, mob, client)
        else
          Network.new(bosh_name, mob, client)
        end
      end

      def initialize(bosh_name, mob, client)
        @bosh_name = bosh_name
        @mob = mob
        @client = client
      end

      def vim_name
        @mob.name
      end

      def nic_backing(_)
        backing_info = VimSdk::Vim::Vm::Device::VirtualEthernetCard::NetworkBackingInfo.new
        backing_info.device_name = vim_name
        backing_info.network = mob
        backing_info
      end

      def inspect
        "<network: / #{@bosh_name} / #{@mob}"
      end
    end

    class OpaqueNetwork < Network

      def nic_backing(dvs_index)
        backing_info = VimSdk::Vim::Vm::Device::VirtualEthernetCard::OpaqueNetworkBackingInfo.new
        network_id = mob.summary.opaque_network_id
        backing_info.opaque_network_id = network_id
        dvs_index[network_id] = bosh_name
        backing_info.opaque_network_type = mob.summary.opaque_network_type
        backing_info
      end
    end

    class DistributedVirtualPortGroupNetwork < Network

      def nic_backing(dvs_index)
        # NSXT backed DVPG are a CVDS feature supported with only 7.0
        # CPI treats these NSXT DVPG like an opaque network and uses
        # their logical switch uuid to create opaque backing rather than DVPG type backing
        if mob.config.respond_to?(:backing_type) && mob.config.backing_type == 'nsx' &&
          backing_info = VimSdk::Vim::Vm::Device::VirtualEthernetCard::OpaqueNetworkBackingInfo.new
          backing_info.opaque_network_id = mob.config.logical_switch_uuid
          dvs_index[backing_info.opaque_network_id] = bosh_name
          backing_info.opaque_network_type = 'nsx.LogicalSwitch'
        else
          portgroup_properties = client.cloud_searcher.get_properties(mob,
                                                               VimSdk::Vim::Dvs::DistributedVirtualPortgroup,
                                                               ['config.key', 'config.distributedVirtualSwitch'],
                                                               ensure_all: true)

          switch = portgroup_properties['config.distributedVirtualSwitch']
          switch_uuid = client.cloud_searcher.get_property(switch, VimSdk::Vim::DistributedVirtualSwitch, 'uuid', ensure_all: true)

          port = VimSdk::Vim::Dvs::PortConnection.new
          port.switch_uuid = switch_uuid
          port.portgroup_key = portgroup_properties['config.key']

          backing_info = VimSdk::Vim::Vm::Device::VirtualEthernetCard::DistributedVirtualPortBackingInfo.new
          backing_info.port = port

          dvs_index[port.portgroup_key] = bosh_name
        end
        backing_info
      end
    end
  end
end

