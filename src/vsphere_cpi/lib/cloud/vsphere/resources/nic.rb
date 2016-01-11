module VSphereCloud
  module Resources
    class Nic
      def self.create_virtual_nic(cloud_searcher, v_network_name, network, controller_key, dvs_index)
        raise "Invalid network '#{v_network_name}'" if network.nil?
        if network.class == VimSdk::Vim::Dvs::DistributedVirtualPortgroup
          portgroup_properties = cloud_searcher.get_properties(network,
            VimSdk::Vim::Dvs::DistributedVirtualPortgroup,
            ['config.key', 'config.distributedVirtualSwitch'],
            ensure_all: true)

          switch = portgroup_properties['config.distributedVirtualSwitch']
          switch_uuid = cloud_searcher.get_property(switch, VimSdk::Vim::DistributedVirtualSwitch, 'uuid', ensure_all: true)

          port = VimSdk::Vim::Dvs::PortConnection.new
          port.switch_uuid = switch_uuid
          port.portgroup_key = portgroup_properties['config.key']

          backing_info = VimSdk::Vim::Vm::Device::VirtualEthernetCard::DistributedVirtualPortBackingInfo.new
          backing_info.port = port

          dvs_index[port.portgroup_key] = v_network_name
        else
          backing_info = VimSdk::Vim::Vm::Device::VirtualEthernetCard::NetworkBackingInfo.new
          backing_info.device_name = network.name
          backing_info.network = network
        end

        nic = VimSdk::Vim::Vm::Device::VirtualVmxnet3.new
        nic.key = -1
        nic.controller_key = controller_key
        nic.backing = backing_info

        nic
      end
    end
  end
end
