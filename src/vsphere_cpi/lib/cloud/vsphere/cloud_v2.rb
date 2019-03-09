require 'cloud/vsphere/logger'
require 'cloud_v2'

module VSphereCloud
  class CloudV2
    include Bosh::CloudV2
    include Logger
    extend Forwardable

    def_delegators :@cloud_core,
                   :create_stemcell, :delete_stemcell,
                   :reboot_vm, :has_vm?,
                   :set_vm_metadata,
                   :configure_networks,
                   :create_disk, :has_disk?, :delete_disk, :resize_disk,
                   :current_vm_id, :get_disks,
                   :calculate_vm_cloud_properties,
                   :info, :set_disk_metadata,
                   :create_network, :delete_network,

    def initialize(options)
      @cloud_core = VSphereCloud::CloudCore.new(options)
    end

    # # If a method we call is missing, pass the call onto
    # # the cloud core we delegate to.
    # def method_missing(m, *args, &block)
    #   if VSphereCloud::CloudCore.instance_methods(false).include?(m)
    #     @cloud_core.send(m, *args, &block)
    #   else
    #     super
    #   end
    # end

    def create_vm(agent_id, stemcell_cid, vm_type, networks_spec, existing_disk_cids = [], environment = nil)
      with_thread_name("create_vm(#{agent_id}, ...):v2") do
        vm_id = @cloud_core.create_vm(agent_id, stemcell_cid, vm_type, networks_spec, existing_disk_cids, environment)
        [vm_id, networks_spec]
      end
    end

    def delete_vm(vm_cid)
      with_thread_name("delete_vm(#{vm_cid}):v2") do
        @cloud_core.delete_vm(vm_cid)
      end
    end

    def attach_disk(vm_cid, raw_director_disk_cid)
      with_thread_name("attach_disk(#{vm_cid}, #{raw_director_disk_cid}):v2") do
        disk_hint = @cloud_core.attach_disk(vm_cid, raw_director_disk_cid) do |vm, cid, unit_number|
          @cloud_core.add_disk_to_agent_env(vm, cid, unit_number) if @cloud_core.config.stemcell_api_version < 2
        end
        disk_hint
      end
    end

    def detach_disk(vm_cid, raw_director_disk_cid)
      with_thread_name("detach_disk(#{vm_cid}, #{raw_director_disk_cid}):v2") do
        @cloud_core.detach_disk(vm_cid, raw_director_disk_cid) do |vm, director_disk_cid|
          @cloud_core.delete_disk_from_agent_env(vm, director_disk_cid) if @cloud_core.config.stemcell_api_version < 2
        end
      end
    end
  end
end
