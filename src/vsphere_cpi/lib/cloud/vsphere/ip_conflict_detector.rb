module VSphereCloud
  class IPConflictDetector

    def initialize(logger, client, networks)
      @logger = logger
      @client = client
      @networks = networks
      @desired_ip_mapping = []

      @networks.map do |_, network_spec|
        ip = network_spec['ip']
        network_name = network_spec.fetch('cloud_properties', [])['name']

        if ip && network_name
          @desired_ip_mapping << {ip: ip, name: network_name}
        end
      end
    end

    def conflicts
      conflicts = []
      @desired_ip_mapping.each do |mapping|
        @logger.info("Checking if ip '#{mapping[:ip]}' is in use")
        vm = @client.find_vm_by_ip(mapping[:ip])
        if vm.nil?
          next
        end

        vm.guest.net.each do |nic|
          if nic.ip_address.include?(mapping[:ip]) && nic.network == mapping[:name]
            @logger.info("found conflicting vm: #{vm.name}, on network: #{mapping[:name]} with ip: #{mapping[:ip]}")
            conflicts << {vm_name: vm.name, network_name: mapping[:name], ip: mapping[:ip]}
          end
        end
      end

      conflicts
    end

  end
end
