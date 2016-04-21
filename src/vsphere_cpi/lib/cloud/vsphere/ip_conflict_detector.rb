module VSphereCloud
  class IPConflictDetector

    def initialize(logger, client, networks)
      @logger = logger
      @client = client
      @networks = networks
    end

    def conflicts
      conflicts = []
      @networks.each do |name, ip|
        @logger.info("Checking if ip '#{ip}' is in use")
        vm = @client.find_vm_by_ip(ip)
        if vm.nil?
          next
        end

        vm.guest.net.each do |nic|
          if nic.ip_address.include?(ip) && nic.network == name
            @logger.info("found conflicting vm: #{vm.name}, on network: #{name} with ip: #{ip}")
            conflicts << {vm_name: vm.name, network_name: name, ip: ip}
          end
        end
      end

      conflicts
    end

  end
end
