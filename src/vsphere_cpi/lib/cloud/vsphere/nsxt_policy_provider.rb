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

  class SegmentPortNotFound < StandardError
    def initialize(attachment_id)
      @attachment_id = attachment_id
    end

    def to_s
      "Segment port with attachment id: #{@attachment_id} not found"
    end
  end

  class InvalidSegmentPortError < StandardError
    def initialize(segment_port)
      @segment_port = segment_port
    end

    def to_s
      "Segment port #{@segment_port.id} has multiple values for tag with scope 'bosh/id'"
    end
  end

  class NSXTPolicyProvider
    include Logger
    extend Hooks

    def initialize(client_builder, default_vif_type='PARENT')
      @client_builder = client_builder
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
          delete_vm_from_group(grp, vm.cid)
        end
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

    def update_vm_metadata_on_segment_ports(vm, metadata)
      return if metadata.nil? or metadata.empty?

      segment_ports = vm.get_nsxt_segment_vif_list
      return if segment_ports.nil?
      segment_ports.each do |segment_name, attachment_id|
        Bosh::Retryable.new(
            tries: [@max_tries, NSXT_SEGMENT_PORT_RETRIES].max,
            sleep: ->(try_count, retry_exception) { [NSXT_MIN_SLEEP, @sleep_time].max },
            on: [SegmentPortNotFound]
        ).retryer do |i|
          segment_port_search_result = search_api.query_search("attachment.id:#{attachment_id}").results[0]
          raise SegmentPortNotFound.new(attachment_id) if segment_port_search_result.nil?

          tier1_data = segment_port_search_result[:path].match(/\/infra\/tier-1s\/(.*)\/segments/)
          tier1_router_name = tier1_data.nil? ? nil: tier1_data[1]
          if tier1_router_name
            # Segment port is scoped under the tier-1
            segment_port = policy_segment_ports_api.get_tier1_segment_port_0(tier1_router_name, segment_name, segment_port_search_result[:id])
          else
            segment_port = policy_segment_ports_api.get_infra_segment_port(segment_name, segment_port_search_result[:id])
          end
          raise SegmentPortNotFound.new(attachment_id) if segment_port.nil?

          tags = segment_port.tags || []
          tags_by_scope = tags.group_by { |tag| tag.scope }
          bosh_tags = tags_by_scope.select { |key, _| key =~ /^bosh\// }

          metadata.each do |metadata_key, metadata_value|
            metadata_key = "bosh/" + metadata_key
            if metadata_key == "bosh/id"
              metadata_value = Digest::SHA1.hexdigest(metadata_value)
            end
            unless bosh_tags[metadata_key].nil?
              unless bosh_tags[metadata_key].length <= 1
                raise InvalidSegmentPortError.new(segment_port)
              end
            end
            bosh_tag = NSXTPolicy::Tag.new('scope' => metadata_key, 'tag' => metadata_value)
            tags.delete_if { |tag| tag.scope == metadata_key }
            tags << bosh_tag
          end

          segment_port.tags = tags

          if tier1_router_name
            policy_segment_ports_api.patch_tier1_segment_port_0(tier1_router_name, segment_name, segment_port.id, segment_port)
          else
            policy_segment_ports_api.patch_infra_segment_port(segment_name, segment_port.id, segment_port)
          end

          true
        end
      end
    end

    before(*instance_methods) { require 'nsxt_policy_client/nsxt_policy_client' }

    private

    DEFAULT_NSXT_POLICY_DOMAIN = 'default'.freeze
    NSXT_MIN_SLEEP = 1
    DEFAULT_SLEEP = 1
    NSXT_SEGMENT_PORT_RETRIES = 300
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

      vm_external_id = get_vm_external_id(vm_cid)

      external_id_expressions = group_obj.expression.select { |expr| expr.is_a?(NSXTPolicy::ExternalIDExpression) && expr.member_type == 'VirtualMachine' }
      if external_id_expressions.size < 1
        unless group_obj.expression.empty?
          group_obj.expression << generate_conjunction_expression(vm_cid, group_obj.expression)
        end

        group_obj.expression << NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                                     member_type: 'VirtualMachine',
                                                                     external_ids: [vm_external_id])
      else
        existing_external_id = external_id_expressions.find { |expr| expr.external_ids.include?(vm_external_id) }
        if existing_external_id != nil
          return
        end

        available_external_id_expression = external_id_expressions.find { |expr| expr.external_ids.size < 500 }
        if available_external_id_expression != nil
          available_external_id_expression.external_ids << vm_external_id
        else
          group_obj.expression << generate_conjunction_expression(vm_cid, group_obj.expression)
          group_obj.expression << NSXTPolicy::ExternalIDExpression.new(resource_type: 'ExternalIDExpression',
                                                                       member_type: 'VirtualMachine',
                                                                       external_ids: [vm_external_id])
        end
      end

      logger.info("Adding vm #{vm_cid} to group #{group_obj}")
      policy_group_api.update_group_for_domain(DEFAULT_NSXT_POLICY_DOMAIN, group_obj.id, group_obj)
    end

    def delete_vm_from_group(group_obj, vm_cid)
      return if group_obj.expression.nil? || group_obj.expression.empty?

      vm_external_id = get_vm_external_id(vm_cid)

      updated = false
      group_obj.expression.each do |expr|
        if expr.is_a?(NSXTPolicy::ExternalIDExpression) &&
            expr.member_type == 'VirtualMachine' &&
            expr.resource_type == 'ExternalIDExpression'
          expr.external_ids.delete_if { |id| id == vm_external_id }
          updated = true

          if expr.external_ids.empty?
            group_obj.expression.delete(expr)

            conjunction_expr = group_obj.expression.find do |e|
              e.is_a?(NSXTPolicy::ConjunctionOperator) &&
                  e.resource_type == 'ConjunctionOperator' &&
                  e.conjunction_operator == 'OR' &&
                  e.id.start_with?("conjunction-#{vm_cid}")
            end
            if conjunction_expr != nil
              group_obj.expression.delete(conjunction_expr)
            end
          end
        end
      end

      if updated
        logger.info("Removing vm #{vm_cid} from group #{group_obj}")
        policy_group_api.update_group_for_domain(DEFAULT_NSXT_POLICY_DOMAIN, group_obj.id, group_obj)
      end
    end

    def get_vm_external_id(vm_cid)
      search_results = policy_infra_realized_state_api.list_virtual_machines_on_enforcement_point(DEFAULT_NSXT_POLICY_DOMAIN, {query: "display_name:#{vm_cid}"}).results
      # API can return several results of the VM with the same external_id and different power_state
      if search_results.length < 1
        err_msg = "Failed to find vm in realized state with cid: #{vm_cid}"
        logger.info(err_msg)
        raise err_msg
      end
      search_results[0][:external_id]
    end

    def generate_conjunction_expression(vm_cid, expressions)
      existing_expr_count = expressions.count do |expr|
        expr.is_a?(NSXTPolicy::ConjunctionOperator) &&
            expr.resource_type == 'ConjunctionOperator' &&
            expr.conjunction_operator == 'OR' &&
            expr.id.start_with?("conjunction-#{vm_cid}")
      end

      NSXTPolicy::ConjunctionOperator.new(resource_type: 'ConjunctionOperator',
                                          conjunction_operator: 'OR',
                                          id: "conjunction-#{vm_cid}-#{existing_expr_count}")
    end

    def policy_segment_ports_api
      @policy_segment_ports_api ||= NSXTPolicy::PolicyNetworkingConnectivitySegmentsPortsApi.new(@client_builder.get_client)
    end

    def policy_segment_api
      @policy_segment_api ||= NSXTPolicy::PolicyNetworkingConnectivitySegmentsSegmentsApi.new(@client_builder.get_client)
    end

    def policy_group_api
      @policy_group_api ||= NSXTPolicy::PolicyInventoryGroupsGroupsApi.new(@client_builder.get_client)
    end

    def policy_load_balancer_pools_api
      @policy_load_balancer_pools_api ||= NSXTPolicy::PolicyNetworkingNetworkServicesLoadBalancingLoadBalancerPoolsApi.new(@client_builder.get_client)
    end

    def policy_infra_realized_state_api
      @policy_infra_realized_state_api ||= NSXTPolicy::PolicyInfraRealizedStateApi.new(@client_builder.get_client)
    end

    def search_api
      @search_api ||= NSXTPolicy::SearchSearchAPIApi.new(@client_builder.get_client)
    end
  end
end
