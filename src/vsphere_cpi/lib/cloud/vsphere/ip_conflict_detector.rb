require 'cloud/vsphere/logger'

module VSphereCloud
  class IPConflictDetector
    include Logger

    def initialize(client)
      @client = client
    end

    def ensure_no_conflicts(networks)
      ip_conflicts = conflicts(networks)
      conflict_messages = []
      ip_conflicts.each do |conflict|
        conflict_messages << "#{conflict[:vm_name]} on network #{conflict[:network_name]} with ip #{conflict[:ip]}"
      end

      if ip_conflicts.empty?
        logger.info("No IP conflicts detected")
      else
        raise "Detected IP conflicts with other VMs on the same networks: #{conflict_messages.join(", ")}"
      end
    end

    private

    def conflicts(networks)
      conflicts = []
      networks.each do |name, ips|
        ips.each do |ip|
          logger.info("Checking if ip '#{ip}' is in use")
          vm = @client.find_vm_by_ip(ip)
          if vm.nil?
            next
          end
          logger.info("Found VM '#{vm.name}' with IP '#{ip}'. Checking if VM belongs to network '#{name}'...")

          vm.guest.net.each do |nic|
            if nic.ip_address.include?(ip) && nic.network == name
              logger.info("found conflicting vm: #{vm.name}, on network: #{name} with ip: #{ip}")
              conflicts << {vm_name: vm.name, network_name: name, ip: ip}
            end
          end
        end
      end

      conflicts
    end

  end
end
