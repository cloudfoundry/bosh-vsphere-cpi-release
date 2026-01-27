module VSphereCloud
  module Resources
    class PCIPassthrough
      @@key = 0

      def self.create_pci_passthrough(vendor_id:, device_id:)
        allowed_device = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough::AllowedDevice.new
        allowed_device.vendor_id = vendor_id
        allowed_device.device_id = device_id
        backing = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough::DynamicBackingInfo.new
        backing.allowed_device = [allowed_device]
        virtual_pci_passthrough = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough.new
        virtual_pci_passthrough.backing = backing
        virtual_pci_passthrough
      end

      def self.create_vgpu(vgpu)
        backing = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough::VmiopBackingInfo.new.tap do |backing_info|
          backing_info.vgpu = vgpu
        end
        pci_passthrough = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough.new
        pci_passthrough.backing = backing
        pci_passthrough.key = unique_key
        pci_passthrough
      end

      # Create vGPU devices for a device group
      # @param device_group_name [String] The name of the device group (e.g., "Nvidia:2@nvidia_h100l-94c%NVLink")
      # @param group_instance_key [Integer] The groupInstanceKey to link devices together
      # @param host [VimSdk::Vim::HostSystem] A host system to query for device group info
      # @param cloud_searcher [CloudSearcher] Cloud searcher to query host properties
      # @return [Array<VimSdk::Vim::Vm::Device::VirtualPCIPassthrough>] Array of vGPU devices with deviceGroupInfo set
      def self.create_device_group_vgpus(device_group_name, group_instance_key, host, cloud_searcher)
        # Query vSphere to get device group information
        host_properties = cloud_searcher.get_properties(
          host,
          VimSdk::Vim::HostSystem,
          ['configManager.assignableHardwareManager'],
          ensure_all: true
        )

        assignable_hw_manager = host_properties['configManager.assignableHardwareManager']
        raise "Failed to get AssignableHardwareManager from host" if assignable_hw_manager.nil?

        # Retrieve device group information from the host
        # Note: This method requires vSphere 8.0+ and may fail if vCenter version is incompatible
        begin
          device_group_infos = assignable_hw_manager.retrieve_vendor_device_group_info
        rescue NameError => e
          if e.message.include?('SoapError')
            raise "Device groups require vSphere 8.0+. The vCenter version may not support device groups, or the SDK version is incompatible."
          else
            raise
          end
        rescue => e
          if e.message.include?('MethodNotFound') || e.message.include?('not available')
            raise "Device groups require vSphere 8.0+. The method 'retrieve_vendor_device_group_info' is not available: #{e.message}"
          else
            raise
          end
        end
        raise "Failed to retrieve device group information from host" if device_group_infos.nil?

        # Find the matching device group
        device_group_info = device_group_infos.find { |info| info.device_group_name == device_group_name }
        raise "Device group '#{device_group_name}' not found on host" if device_group_info.nil?

        # Extract component device information
        component_devices = device_group_info.component_device_info || []
        if component_devices.empty?
          raise "Device group '#{device_group_name}' has no component devices. " \
                "This is a configuration issue - verify the device group contains vGPU devices in vSphere."
        end

        # Filter for nvidiaVgpu devices
        vgpu_devices = component_devices.select { |comp| comp.type == 'nvidiaVgpu' }
        if vgpu_devices.empty?
          found_types = component_devices.map(&:type).uniq.join(', ')
          raise "Device group '#{device_group_name}' has no nvidiaVgpu component devices (found: #{found_types}). " \
                "This is a configuration issue - verify the device group contains vGPU devices in vSphere."
        end

        # Create vGPU devices with deviceGroupInfo
        devices = []
        vgpu_devices.each_with_index do |comp_device, sequence_id|
          # Extract vGPU profile from the device backing
          # Note: comp_device.device is a template/example device from metadata (not an attached device)
          # We validate its structure to extract the vGPU profile for creating new devices
          device = comp_device.device
          raise "Component device does not have backing information" unless device.is_a?(VimSdk::Vim::Vm::Device::VirtualPCIPassthrough)
          raise "Component device does not have VmiopBackingInfo" unless device.backing.is_a?(VimSdk::Vim::Vm::Device::VirtualPCIPassthrough::VmiopBackingInfo)

          vgpu_profile = device.backing.vgpu
          raise "Component device does not have vGPU profile" if vgpu_profile.nil?

          # Create backing with vGPU profile
          backing = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough::VmiopBackingInfo.new
          backing.vgpu = vgpu_profile

          # Create deviceGroupInfo to link devices together
          device_group_info_obj = VimSdk::Vim::Vm::Device::VirtualDevice::DeviceGroupInfo.new
          device_group_info_obj.group_instance_key = group_instance_key
          device_group_info_obj.sequence_id = sequence_id

          # Create the PCI passthrough device
          pci_passthrough = VimSdk::Vim::Vm::Device::VirtualPCIPassthrough.new
          pci_passthrough.backing = backing
          pci_passthrough.key = unique_key
          pci_passthrough.device_group_info = device_group_info_obj

          devices << pci_passthrough
        end

        devices
      end

      # avoid "Cannot add multiple devices using the same device key.." when
      # adding multiple vGPUs
      def self.unique_key
        @@key -= 1
      end
    end
  end
end