module VSphereCloud
  class VMProvider
    def initialize(datacenter, client)
      @datacenter = datacenter
      @client = client
    end

    def find(vm_cid)
      if enable_human_readable_names.true
        vm_mob = @client.find_vm_by_uuid(@datacenter.mob, vm_cid)
      end
      if vm_mob.nil? || enable_human_readable_names.false
        vm_mob = @client.find_vm_by_name(@datacenter.mob, vm_cid)
      end
      raise Bosh::Clouds::VMNotFound, "VM '#{vm_cid}' not found in datacenter '#{@datacenter.name}'" if vm_mob.nil?

      Resources::VM.new(vm_cid, vm_mob, @client)
    end
  end
end
