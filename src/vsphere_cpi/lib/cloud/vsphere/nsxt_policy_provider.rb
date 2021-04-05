require 'cloud/vsphere/logger'
require 'digest'

module VSphereCloud
  class UnrealizedResource < StandardError
    def initialize(path)
      @path = path
    end

    def to_s
      "Resource with path: #{@path} is not realized yet"
    end
  end

  class NSXTPolicyProvider
    DEFAULT_NSXT_POLICY_DOMAIN = 'default'.freeze

    include Logger

    def initialize(client,  default_vif_type='PARENT')
      @client = client
      @default_vif_type = default_vif_type
      @sleep_time = DEFAULT_SLEEP
      @max_tries = MAX_TRIES
    end

    def add_vm_to_groups(vm, groups)
      logger.info("Adding vm: #{vm.cid} to groups: #{groups}")

      return if groups.nil? || groups.empty?

      # All port paths above need to be added to the all the groups. So,
      groups.each do |grp|
        retry_on_conflict("while adding vm: #{vm.cid} to group #{grp}") do
          group_obj = retrieve_group(group_id: grp)
          add_vm_to_group(group_obj, vm.cid)
        end
      end
    end

    def remove_vm_from_groups(vm)
      logger.info("Removing vm: #{vm.cid} from all Policy Groups it is part of")
      all_groups = retrieve_all_groups
      # For all the groups
      all_groups.each do |grp|
        retry_on_conflict("while removing vm: #{vm.cid} from group #{grp.id}") do
          grp = retrieve_group(group_id: grp.id)
          delete_vm_from_group(grp, vm.cid)
        end
        grp = policy_group_api.read_group_for_domain(DEFAULT_NSXT_POLICY_DOMAIN, grp.id)
        logger.info("Removal done vm: #{vm.cid} grp: #{grp}")
      end
    end

    def add_vm_to_server_pools(vm, server_pools)
      Bosh::Retryable.new(
        tries: 50,
        sleep: ->(try_count, retry_exception) { 2 },
        on: [VirtualMachineIpNotFound]
      ).retryer do |i|
        vm_ip = vm.mob.guest&.ip_address
        raise VirtualMachineIpNotFound.new(vm) unless vm_ip
        server_pools.each do |server_pool|
          retry_on_conflict("while adding vm: #{vm.cid} to group #{server_pool['name']}") do
            load_balancer_pool = policy_load_balancer_pools_api.read_lb_pool_0(server_pool['name'])
            logger.info("Adding vm: '#{vm.cid}' with ip:#{vm_ip} to ServerPool: #{load_balancer_pool.id} on Port: #{server_pool['port']} ")
            (load_balancer_pool.members ||= []).push(NSXTPolicy::LBPoolMember.new(port: server_pool['port'], ip_address: vm_ip))
            policy_load_balancer_pools_api.update_lb_pool_0(server_pool['name'], load_balancer_pool)
          end
        end
      end
    end

    def remove_vm_from_server_pools(vm_ip)
      policy_load_balancer_pools_api.list_lb_pools.results.each do |server_pool|
        original_size = server_pool.members&.length
        server_pool.members&.each do |member|
          if member.ip_address == vm_ip
            logger.info("Removing vm with ip: '#{vm_ip}', port_no: #{member.port} from ServerPool: #{server_pool.id} ")
            server_pool.members&.delete(member)
          end
        end
        next if server_pool.members&.length == original_size
        policy_load_balancer_pools_api.update_lb_pool_0(server_pool.id, server_pool)
      end
    end

    private

    DEFAULT_SLEEP = 1
    MAX_TRIES=100

    def retry_on_conflict(log_str)
      yield
    rescue NSXTPolicy::ApiCallError => e
      if [409, 412].include?(e.code)
        logger.info("Revision Error: #{log_str if log_str} with message #{e.message}")
        # To limit request rate on NSX-T server
        sleep(rand(5)/2.0)
        retry
      end
      logger.info("Failed #{log_str if log_str} with message #{e.message}")
      raise e
    end

    def retrieve_group(group_id:)
      logger.info("Searching for Policy Group with group id: #{group_id}")
      begin
        group = policy_group_api.read_group_for_domain(DEFAULT_NSXT_POLICY_DOMAIN, group_id)
      rescue => e
        logger.info("Failed to find Policy Group: #{group_id} with error #{e.inspect}")
        raise e
      end
      logger.info("Found Policy Group: #{group.id}")
      group
    end

    def retrieve_all_groups()
      logger.info("Gathering all Policy Groups")
      groups = []
      group_list = policy_group_api.list_group_for_domain_0(DEFAULT_NSXT_POLICY_DOMAIN)
      groups.push(*group_list.results)
      until group_list.cursor.nil?
        group_list = policy_group_api.list_group_for_domain_0(DEFAULT_NSXT_POLICY_DOMAIN, cursor: group_list.cursor)
        groups.push(*group_list.results)
      end
      logger.info("Found #{groups.size} Policy Groups")
      groups
    end

    def add_vm_to_group(group_obj, vm_cid)
      group_obj.expression = [] if group_obj.expression.nil?

      group_obj.expression.each do |expr|
        if expr.is_a?(NSXTPolicy::Condition) &&
            expr.value == vm_cid &&
            expr.key == 'Name' &&
            expr.member_type == 'VirtualMachine' &&
            expr.operator == 'EQUALS'
          return
        end
      end

      original_length = group_obj.expression.length
      unless group_obj.expression.empty?
        group_obj.expression << NSXTPolicy::ConjunctionOperator.new(resource_type: 'ConjunctionOperator',
                                                                    conjunction_operator: 'OR',
                                                                    id: "conjunction-#{vm_cid}")
      end

      group_obj.expression << NSXTPolicy::Condition.new(resource_type: 'Condition',
                                                        key: 'Name',
                                                        operator: 'EQUALS',
                                                        member_type: 'VirtualMachine',
                                                        value: vm_cid)
      if original_length != group_obj.expression.length
        logger.info("Adding vm: #{vm_cid}, group #{group_obj}")
        policy_group_api.update_group_for_domain(DEFAULT_NSXT_POLICY_DOMAIN, group_obj.id, group_obj)
      end
    end

    def delete_vm_from_group(group_obj, vm_cid)
      return if group_obj.expression.nil? || group_obj.expression.empty?

      original_length = group_obj.expression.length
      group_obj.expression.delete_if do |expr|
        (expr.is_a?(NSXTPolicy::Condition) &&
            expr.value == vm_cid &&
            expr.key == 'Name' &&
            expr.member_type == 'VirtualMachine' &&
            expr.operator == 'EQUALS') ||
        (expr.is_a?(NSXTPolicy::ConjunctionOperator) &&
            expr.id == "conjunction-#{vm_cid}" &&
            expr.conjunction_operator == 'OR')
      end
      if original_length != group_obj.expression.length
        logger.info("Removal of vm: #{vm_cid}, group #{group_obj}")
        policy_group_api.update_group_for_domain(DEFAULT_NSXT_POLICY_DOMAIN, group_obj.id, group_obj)
      end
    end

    def policy_segment_port_api
      @policy_segment_port_api ||= NSXTPolicy::PolicyNetworkingConnectivitySegmentsPortsApi.new(@client)
    end

    def policy_segment_api
      @policy_segment_api ||= NSXTPolicy::PolicyNetworkingConnectivitySegmentsSegmentsApi.new(@client)
    end

    def policy_group_api
      @policy_group_api ||= NSXTPolicy::PolicyInventoryGroupsGroupsApi.new(@client)
    end

    def policy_load_balancer_pools_api
      @policy_load_balancer_pools_api ||= NSXTPolicy::PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerPoolsApi.new(@client)
    end
  end
end
