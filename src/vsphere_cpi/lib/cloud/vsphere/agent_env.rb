require 'cloud/vsphere/logger'

module VSphereCloud
  class AgentEnv
    include VimSdk
    include Logger

    def initialize(client:, file_provider:)
      @client = client
      @file_provider = file_provider
    end

    def set_env(vm, location, env)
      logger.info("Updating current agent env from vm '#{vm.name}' in datacenter '#{location[:datacenter]}'")
      env_json = JSON.dump(env)

      disconnect_cdrom(vm)
      clean_env(vm)
      ds_hosts = get_vm_vsphere_cluster_hosts(vm)
      # NOTE: env.json used to be used by a 'get_current_env' method to fetch the existing env state of the VM and
      # update it. We no longer update the agent env, since disk information is passed by CPIv2 `disk_hint` so the
      # 'get_current_env' method has been removed and 'env.json' is written out purely for consistency & debugging
      # purposes.
      @file_provider.upload_file_to_datastore(location[:datacenter],
                                              location[:datastore].mob,
                                              "#{location[:vm]}/env.json",
                                              env_json, ds_hosts)

      @file_provider.upload_file_to_datastore(location[:datacenter],
                                              location[:datastore].mob,
                                              "#{location[:vm]}/env.iso",
                                              generate_env_iso(env_json), ds_hosts)

      file_name = "[#{location[:datastore].name}] #{location[:vm]}/env.iso"
      update_cdrom_env(vm, location[:datastore].mob, file_name)
    end

    def env_iso_folder(cdrom_device)
      return unless cdrom_device && cdrom_device.backing.respond_to?(:file_name)
      File.dirname(cdrom_device.backing.file_name)
    end

    def clean_env(vm)
      logger.info("Cleaning current agent env from vm '#{vm.name}'")
      cdrom = @client.get_cdrom_device(vm)
      env_iso_folder = env_iso_folder(cdrom)
      return unless env_iso_folder

      datacenter = @client.find_parent(vm, Vim::Datacenter)

      @client.delete_path(datacenter, File.join(env_iso_folder, 'env.json'))
      @client.delete_path(datacenter, File.join(env_iso_folder, 'env.iso'))
    end

    private

    def get_vm_vsphere_cluster_hosts(vm_mob)
      # As per the VC Object hierarchy,
      #  - VM's host will be there
      #  - The host will be bound to a cluster
      #     - (true because CPI is using this and it does not deal with DC hosts)
      vm_mob.runtime.host.parent.host
    end

    def update_cdrom_env(vm, datastore, file_name)
      backing_info = Vim::Vm::Device::VirtualCdrom::IsoBackingInfo.new
      backing_info.datastore = datastore
      backing_info.file_name = file_name

      connect_info = Vim::Vm::Device::VirtualDevice::ConnectInfo.new
      connect_info.allow_guest_control = false
      connect_info.start_connected = true
      connect_info.connected = true

      cdrom = @client.get_cdrom_device(vm)
      cdrom.connectable = connect_info
      cdrom.backing = backing_info

      config = Vim::Vm::ConfigSpec.new
      config.device_change = [Resources::VM.create_edit_device_spec(cdrom)]
      @client.reconfig_vm(vm, config)
    end

    def disconnect_cdrom(vm)
      cdrom = @client.get_cdrom_device(vm)
      if cdrom.connectable.connected
        cdrom.connectable.connected = false
        config = Vim::Vm::ConfigSpec.new
        config.device_change = [Resources::VM.create_edit_device_spec(cdrom)]
        @client.reconfig_vm(vm, config)
      end
    end

    def generate_env_iso(env)
      Dir.mktmpdir do |path|
        env_path = File.join(path, 'env')
        iso_path = File.join(path, 'env.iso')
        File.open(env_path, 'w') { |f| f.write(env) }

        mkiso = genisoimage
        if mkiso.match('iso9660wrap$')
          output = `#{mkiso} #{env_path} #{iso_path} 2>&1`
        else
          output = `#{mkiso} -o #{iso_path} #{env_path} 2>&1`
        end

        raise "#{$?.exitstatus} -#{output}" if $?.exitstatus != 0
        File.open(iso_path, 'r') { |f| f.read }
      end
    end

    def which(programs)
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        programs.each do |bin|
          exe = File.join(path, bin)
          return exe if File.exist?(exe)
        end
      end
      programs.first
    end

    def genisoimage
      @genisoimage ||= which(%w{genisoimage iso9660wrap})
    end
  end
end
