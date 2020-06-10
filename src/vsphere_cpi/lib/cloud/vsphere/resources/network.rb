require 'cloud/vsphere/resources'

module VSphereCloud
  module Resources
    # An standard network uses a NetworkBackingInfo and is excluded from the dvs
    # index.
    class Network
      include ObjectStringifier
      stringify_with :name, :mob

      attr_reader :mob, :client

      # @return [Network] return an instance of the proper subclass of Network
      #   to represent the `mob`
      def self.make_network_resource(mob, client)
        nw_type = case mob
        when VimSdk::Vim::Dvs::DistributedVirtualPortgroup
          if mob.config.respond_to?(:backing_type) && mob.config.backing_type == 'nsx'
            DistributedVirtualPortGroupNSXTNetwork
          else
            DistributedVirtualPortGroupNetwork
          end
        when VimSdk::Vim::OpaqueNetwork
          OpaqueNetwork
        else
          Network
        end
        nw_type.new(mob, client)
      end

      def initialize(mob, client)
        @mob = mob
        @client = client
      end

      # @return [VimSdk::Vim::Vm::Device::VirtualEthernetCard::NetworkBackingInfo]
      #   the backing info object used to attach a NIC device to this network
      def nic_backing
        backing_info = VimSdk::Vim::Vm::Device::VirtualEthernetCard::NetworkBackingInfo.new
        backing_info.device_name = @mob.name
        backing_info.network = mob
        backing_info
      end

      # @return [Object] the network id to use as the key in dvs_index
      def network_id
        nil
      end

      def inspect
        "<network: / #{@mob}>"
      end
    end

    # An opaque network uses an OpaqueNetworkBackingInfo and the opaque network
    # id as the key in the dvs index.
    class OpaqueNetwork < Network
      def nic_backing
        backing_info = VimSdk::Vim::Vm::Device::VirtualEthernetCard::OpaqueNetworkBackingInfo.new
        network_id = mob.summary.opaque_network_id
        backing_info.opaque_network_id = network_id
        backing_info.opaque_network_type = mob.summary.opaque_network_type
        backing_info
      end

      def network_id
        mob.summary.opaque_network_id
      end
    end

    # A normal DVPG uses a DistributedVirtualPortBackingInfo and the portgroup
    # key as the key in the dvs index.
    class DistributedVirtualPortGroupNetwork < Network
      def nic_backing
        portgroup_properties = client.cloud_searcher.get_properties(
          mob, VimSdk::Vim::Dvs::DistributedVirtualPortgroup,
          ['config.key', 'config.distributedVirtualSwitch'], ensure_all: true)
        switch = portgroup_properties['config.distributedVirtualSwitch']
        switch_uuid = client.cloud_searcher.get_property(
          switch, VimSdk::Vim::DistributedVirtualSwitch, 'uuid', ensure_all: true)

        port = VimSdk::Vim::Dvs::PortConnection.new
        port.switch_uuid = switch_uuid
        port.portgroup_key = portgroup_properties['config.key']

        backing_info = VimSdk::Vim::Vm::Device::VirtualEthernetCard::DistributedVirtualPortBackingInfo.new
        backing_info.port = port
        backing_info
      end

      def network_id
        mob.config.key
      end
    end


    # NSX-T backed DVPGs are a CVDS feature supported with only in vSphere 7.0.
    # The CPI treats these NSX-T DVPGs like an opaque network and uses their
    # logical switch uuid to create an opaque network backing rather than DVPG
    # type backing. Its logical switch uuid is the key in the dvs index.
    class DistributedVirtualPortGroupNSXTNetwork < Network
      def nic_backing
        backing_info = VimSdk::Vim::Vm::Device::VirtualEthernetCard::OpaqueNetworkBackingInfo.new
        backing_info.opaque_network_id = mob.config.logical_switch_uuid
        backing_info.opaque_network_type = 'nsx.LogicalSwitch'
        backing_info
      end

      def network_id
        mob.config.logical_switch_uuid
      end
    end
  end
end
