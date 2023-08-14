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

      # avoid "Cannot add multiple devices using the same device key.." when
      # adding multiple vGPUs
      def self.unique_key
        @@key -= 1
      end
    end
  end
end