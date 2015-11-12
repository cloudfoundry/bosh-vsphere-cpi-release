module VSphereCloud
  class VMProvider
    def initialize(datacenter, client, logger)
      @datacenter = datacenter
      @client = client
      @logger = logger
    end

    def find(vm_cid)
      vm_mob = @client.find_vm_by_name(@datacenter, vm_cid)
      raise Bosh::Clouds::VMNotFound, "VM '#{vm_cid}' not found in datacenter '#{@datacenter.name}'" if vm_mob.nil?

      Resources::VM.new(vm_cid, vm_mob, @client, @logger)
    end
  end
end
