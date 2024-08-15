require 'cloud/vsphere/logger'

module VSphereCloud
  class IPConflictDetector
    include Logger

    def initialize(client, datacenter)
      @client = client
      @datacenter = datacenter
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
        raise Bosh::Clouds::CloudError, "Detected IP conflicts with other VMs on the same networks: #{conflict_messages.join(", ")}"
      end
    end

    private

    def conflicts(networks)
      conflicts = []
      networks.each do |name, ips|
        ips.each do |ip|
          logger.info("Checking if ip '#{ip}' is in use")
          @client.find_all_vms_by_ip(ip).each do |vm|
            logger.info("Found VM '#{vm.name}' with IP '#{ip}'. Checking if VM belongs to network '#{name}'...")
            vm.guest.net.each do |nic|
              unqualified_name = name.split('/').last
              if nic.ip_address.include?(ip) && nic.network == unqualified_name
                network_mob = @client.find_network(@datacenter, name)
                logger.info("found network '#{network_mob}' with vm '#{network_mob.vm}' and nic #{nic} with ips '#{nic.ip_address}'")

                if network_mob.vm.include?(vm)
                  logger.info("found conflicting vm: #{vm.name}, on network: #{name} with ip: #{ip}")
                  conflicts << { vm_name: vm.name, network_name: name, ip: ip }
                end
              end
            end
          end
        end
      end
      conflicts
    end

  end
end
