require 'cloud/vsphere/resources'

module VSphereCloud
  module Resources
    class Host
      include Logger
      include VimSdk
      include ObjectStringifier
      stringify_with :name, :mob
      PROPERTIES = %w(name hardware.pciDevice config.graphicsInfo runtime)

      def self.build_from_client(client, host_mob, options={})
        host_properties_map = client.cloud_searcher.get_properties(host_mob, Vim::HostSystem, Host::PROPERTIES, options)
        host_properties_map.values.map do |host_properties|
          Host.new(
            host_properties['name'],
            host_properties[:obj],
            host_properties['hardware.pciDevice'],
            host_properties['config.graphicsInfo'],
            host_properties['runtime'],
          )
        end
      end

      # @!attribute name
      #   @return [String] host name.
      attr_accessor :name

      # @!attribute mob
      #   @return [Vim::HostSystem] Host vSphere MOB.
      attr_accessor :mob

      # @!attribute pci_devies
      #   @return [Array<Vim::Host::PciDevice>] List of PCI Devices attached to host.
      attr_accessor :pci_devices

      # @!attribute graphics_info
      #   @return [Array<Vim::Host::GraphicsInfo>] List of graphics devices attached to Host.
      attr_accessor :graphics_info

      # @!attribute runtime
      #   @return [<Vim::Host::RuntimeInfo>] Runtime info for this host.
      attr_accessor :runtime

      # Creates a Host resource from the prefetched vSphere properties.
      #
      # @param [Hash] properties prefetched vSphere properties to build the
      #   model.
      def initialize(name, mob, pci_devices, graphics_info, runtime)
        @name = name
        @mob = mob
        @pci_devices = pci_devices
        @graphics_info = graphics_info
        @runtime = runtime
      end

      # @return [String] debug Host information.
      def inspect
        "<Host: #@mob / #@name>"
      end

      # @return[Boolean] whether host is active or not.
      def active?
        runtime.in_maintenance_mode != true &&
        runtime.connection_state == 'connected' &&
        runtime.power_state == 'poweredOn'
      end

      def eql?(other)
        other.name == name
      end

      def hash
        name.hash
      end

      # raw_available_memory
      #
      # Returns raw available memory with a host. The reason it is raw is because it does not account
      # for any memory overhead needed to power up a new virtual machine.
      def raw_available_memory
        (mob.hardware.memory_size - mob.summary.quick_stats.overall_memory_usage)/BYTES_IN_MB
      end

      def available_gpus
        graphics_info.reject do |gpu|
          # Reject all gpu where it is not passthrough
          gpu.graphics_type != 'direct'
        end.select do |gpu|
          # Select all gpu where they are not assigned to a VM
          gpu.vm.empty?
        end.reject do |gpu|
          # Since gpu.vm is optional. Reject all gpu which have been assigned to any vm on that host
          mob.vm.any? do |vm|
            begin
              vm.config.hardware.device.any? do |device|
                backing = device.backing
                backing && backing.is_a?(VimSdk::Vim::Vm::Device::VirtualPCIPassthrough::DeviceBackingInfo) &&
                  backing.id == gpu.pci_id
              end
            # This rescue is for VMs which are being created or being deleted by other CPI processes.
            # VM in process of creation or deletion might throw up an error while we try to query its state and properties.
            # Can we rescue more specific error here.
            rescue StandardError => error
              logger.warn("Method Host::available_gpus : Going through vms. Error raised #{error} for this vm #{vm}")
              logger.info("#{error} - #{error.backtrace.join("\n")}")
              false
            end
          end
        end.inject([]) do |acc, gpu|
          device = pci_devices.detect {|dev| dev.id == gpu.pci_id}
          acc << device
          acc
        end
      end
    end
  end
end
