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

  class DuplicateLBPoolDisplayName < StandardError
    def initialize(display_name)
      @display_name = display_name
    end

    def to_s
      "Multiple server pools have the display name '#{@display_name}'"
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
      @all_lb_pools = nil
    end

    def add_vm_to_groups(vm, groups)
      return if groups.nil? || groups.empty?
      logger.info("Adding vm: #{vm.cid} to groups: #{groups.map(&:display_name)}")

      groups.each do |group|
        retry_on_conflict("while adding vm: #{vm.cid} to group #{group.display_name}") do
          group = retrieve_group(group_id: group.id)
          add_vm_to_group(group, vm.cid)
        end
      end
    end

    def remove_vm_from_groups(vm)
      logger.info("Removing vm: #{vm.cid} from all Policy Groups it is part of")
      vm_external_id = get_vm_external_id(vm.cid)
      return if vm_external_id.nil? # If VM external ID is nil, then it's not connected to NSX: return immediately
      logger.info("Finding Policy Groups that contain VM (via external ID '#{vm_external_id}')")
      begin
        vm_groups = retrieve_vm_groups(vm_external_id)
      rescue => e
        # 2026-01-20 - We have observed many issues where the NSX API incorrectly returns a NOT_FOUND error when trying to retrieve groups via external id
        # root cause is not currently known, but it _seems_ like a timing problem?
        # We are choosing to ignore this failure case, because:
        # 1) if encountered, this error blocks vm deletes
        # 2) we think NSX will remove memberships anyways
        # 3) we take this "ignore" approach eleswhere (e.g. policy migration mode).
        if e.message.include?("NOT_FOUND")
          vm_groups = []
          logger.info("Ignoring NOT_FOUND error for VM #{vm.cid}. This error may occur in cases where the NSX data is incompletely propagated. NSX should eventually remove any memberships automatically, but in some cases manual cleanup may be necessary.")
        else
          raise e
        end
      end

      # For all the groups
      vm_groups.each do |grp_ref|
        retry_on_conflict("while removing vm: #{vm.cid} from group #{grp_ref.target_id}") do
          group_obj = retrieve_group(group_id: grp_ref.path.split('/').last)
          delete_vm_from_group(group_obj, vm.cid, vm_external_id)
        end
      end
    end

    def add_vm_to_server_pools(vm, server_pools)
      return if server_pools.nil? || server_pools.empty?
      Bosh::Retryable.new(
        tries: 150,
        sleep: ->(try_count, retry_exception) { 2 },
        on: [VirtualMachineIpNotFound]
      ).retryer do |i|
        vm_ip = vm.mob.guest&.ip_address
        raise VirtualMachineIpNotFound.new(vm) unless vm_ip
        server_pools.each do |server_pool, port_no|
          retry_on_conflict("while adding vm: #{vm.cid} to group #{server_pool.display_name}") do
            logger.info("Adding vm: '#{vm.cid}' with ip:#{vm_ip} to ServerPool: #{server_pool.id} on Port: #{port_no} ")
            lb_pool = policy_load_balancer_pools_api.read_lb_pool(server_pool.id)
            (lb_pool.members ||= []).push(NSXTPolicy::LBPoolMember.new(port: port_no, ip_address: vm_ip, display_name: vm.cid))

            policy_load_balancer_pools_api.update_lb_pool(lb_pool.id, lb_pool)
          end
        end
      end
    end

    # cpi_metadata_version must be an integer
    def remove_vm_from_server_pools(vm_ip, vm_cid, cpi_metadata_version)
      policy_load_balancer_pools_api.list_lb_pools.results.each do |server_pool|
        next if server_pool.members.nil?

        members_to_remove, members_to_keep = server_pool.members.partition do |member|
          member.ip_address == vm_ip && ((cpi_metadata_version > 0 && vm_cid == member.display_name) || cpi_metadata_version == 0)
        end
        members_to_remove.each do |member|
          logger.info("Removing vm with ip: '#{vm_ip}', port_no: #{member.port} from ServerPool: #{server_pool.id} ")
        end

        next if members_to_remove.empty?

        server_pool.members = members_to_keep
        policy_load_balancer_pools_api.update_lb_pool(server_pool.id, server_pool)
      end
    end

    def update_vm_metadata_on_segment_ports(vm, metadata)
      return if metadata.nil? or metadata.empty?

      segment_ports = vm.get_nsxt_segment_vif_list
      return if segment_ports.nil?
      segment_ports.each do |_, attachment_id|
        Bosh::Retryable.new(
            tries: [@max_tries, NSXT_SEGMENT_PORT_RETRIES].max,
            sleep: ->(try_count, retry_exception) { [NSXT_MIN_SLEEP, @sleep_time].max },
            on: [SegmentPortNotFound]
        ).retryer do |i|
          segment_port_search_result = search_api.query_search("attachment.id:#{attachment_id}").results[0]
          raise SegmentPortNotFound.new(attachment_id) if segment_port_search_result.nil?

          tier1_data = segment_port_search_result[:path].match(/\/infra\/tier-1s\/(.*)\/segments/)
          tier1_router_id = tier1_data.nil? ? nil : tier1_data[1]
          segment_data = segment_port_search_result[:parent_path].match(/\/segments\/(.*)/)
          segment_id = segment_data.nil? ? nil : segment_data[1]
          if tier1_router_id
            # Segment port is scoped under the tier-1
            segment_port = policy_segments_api.get_tier1_segment_port(tier1_router_id, segment_id, segment_port_search_result[:id])
          else
            segment_port = policy_segments_api.get_infra_segment_port(segment_id, segment_port_search_result[:id])
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

          if tier1_router_id
            policy_segments_api.patch_tier1_segment_port(tier1_router_id, segment_id, segment_port.id, segment_port)
          else
            policy_segments_api.patch_infra_segment_port(segment_id, segment_port.id, segment_port)
          end

          true
        end
      end
    end

    #We don't page here but extremely unlikely to hit the pagination limit.
    def retrieve_groups_by_name(group_display_names)
      logger.info("Searching for Policy Groups with group display names: #{group_display_names}")
      
      all_groups = []
      # Split group names into smaller chunks to avoid query string length limits
      chunk_size = 20  # Process 20 group names at a time
      group_display_names.each_slice(chunk_size) do |name_chunk|
        query = "resource_type:Group AND display_name:(#{name_chunk.join(" OR ")})"
        logger.debug("Searching for chunk of #{name_chunk.length} groups")
        
        cursor = nil
        page_size = 50  # Use smaller page size to avoid remote errors
        
        loop do
          search_opts = { page_size: page_size }
          search_opts[:cursor] = cursor if cursor
          
          search_response = search_api.query_search(query, search_opts)
          break if search_response.results.nil? || search_response.results.empty?
          
          all_groups.concat(search_response.results.map { |group_attrs| NSXTPolicy::Group.new(group_attrs) })
          
          # Check if there are more pages
          cursor = search_response.cursor
          break if cursor.nil? || cursor.empty?
          
          logger.debug("Retrieved #{all_groups.length} groups so far, continuing with cursor: #{cursor}")
        end
      end
      
      logger.info("Retrieved total of #{all_groups.length} groups")
      all_groups
    end

    #We don't page here but extremely unlikely to hit the pagination limit.
    def retrieve_groups_by_id(group_ids)
      logger.info("Searching for Policy Groups with group ids: #{group_ids}")
      query = "resource_type:Group AND id:(#{group_ids.join(" OR ")})"
      search_api.query_search(query).results.map { |group_attrs| NSXTPolicy::Group.new(group_attrs) }
    end

    def retrieve_server_pools(server_pools, allow_missing_pools=false)
      return [] if server_pools.nil? || server_pools.empty?

      #Create a hash of server_pools with key as their name and value as list of matching server_pools
      server_pools_by_name = policy_load_balancer_pools_api.list_lb_pools.results.each_with_object({}) do |server_pool, hash|
        hash[server_pool.display_name] ? hash[server_pool.display_name] << server_pool : hash[server_pool.display_name] = [server_pool]
      end

      missing = server_pools.reject do |server_pool|
        server_pools_by_name.key?(server_pool['name'])
      end

      if !missing.empty?
        if allow_missing_pools
          logger.info("Not all server pools found, missing #{missing.map {|p| p['name'] }.join(",")}. The VM will still be added to found server pools.")
        else
          raise ServerPoolsNotFound.new(*missing)
        end
      end

      static_server_pools, dynamic_server_pools = [], []
      server_pools.each do |server_pool|
        server_pool_name = server_pool['name']
        server_pool_port = server_pool['port']
        matching_server_pools = server_pools_by_name[server_pool_name]
        next unless matching_server_pools
        matching_server_pools.each do |matching_server_pool|
          matching_server_pool.member_group ? dynamic_server_pools << matching_server_pool : static_server_pools << [matching_server_pool, server_pool_port]
        end
      end
      [static_server_pools, dynamic_server_pools]
    end


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
        group = policy_groups_api.read_group_for_domain(DEFAULT_NSXT_POLICY_DOMAIN, group_id)
      rescue => e
        logger.info("Failed to find Policy Group: #{group_id} with error #{e.inspect}")
        raise e
      end
      logger.info("Found Policy Group: #{group.id}")
      group
    end

    def retrieve_vm_groups(vm_external_id)
      logger.info("Gathering Policy Groups for VM #{vm_external_id}")
      groups = []
      group_list = policy_group_members_api.get_groups_for_vm(vm_external_id)
      groups.push(*group_list.results)
      until group_list.cursor.nil?
        group_list = policy_group_members_api.get_groups_for_vm(vm_external_id, cursor: group_list.cursor)
        groups.push(*group_list.results)
      end
      logger.info("Found #{groups.size} Policy Groups for VM #{vm_external_id}")
      groups
    end

    def add_vm_to_group(group_obj, vm_cid)
      group_obj.expression = [] if group_obj.expression.nil?

      vm_external_id = get_vm_external_id(vm_cid)
      raise VirtualMachineNotFound.new(vm_cid) if vm_external_id.nil?

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
      policy_groups_api.update_group_for_domain(DEFAULT_NSXT_POLICY_DOMAIN, group_obj.id, group_obj)
    end

    def delete_vm_from_group(group_obj, vm_cid, vm_external_id)
      return if group_obj.expression.nil? || group_obj.expression.empty?

      updated = false
      group_obj.expression.each_with_index do |expr, index|
        if expr.is_a?(NSXTPolicy::ExternalIDExpression) &&
            expr.member_type == 'VirtualMachine' &&
            expr.resource_type == 'ExternalIDExpression'
          expr.external_ids.delete_if { |id| id == vm_external_id }
           # not true if id does not exist in any eid expr. but this is very unlikely
          updated = true

          if expr.external_ids.empty?
            group_obj.expression.delete(expr)
            if ! group_obj.expression.empty?
              # delete the OR op before or after
              if index == 0
                e=group_obj.expression[0]
              else
                e=group_obj.expression[index-1]
              end
              if e.is_a?(NSXTPolicy::ConjunctionOperator) &&
                    e.resource_type == 'ConjunctionOperator' &&
                    e.conjunction_operator == 'OR'
                group_obj.expression.delete(e)
              end
            end
          end
        end
      end

      if updated
        logger.info("Removing vm #{vm_cid} from group #{group_obj}")
        policy_groups_api.update_group_for_domain(DEFAULT_NSXT_POLICY_DOMAIN, group_obj.id, group_obj)
      end
    end

    def get_vm_external_id(vm_cid)
      search_results = []
      begin
        Bosh::Retryable.new(
          tries: 10,
          sleep: ->(_, _) { 1 },
        ).retryer do |_|
          search_results = policy_virtual_machine_api.list_virtual_machines_on_enforcement_point(DEFAULT_NSXT_POLICY_DOMAIN, { query: "display_name:#{vm_cid}" }).results
          search_results.length > 0
        end
      rescue => e
        raise unless e.kind_of?(Bosh::Common::RetryCountExceeded)
      end

      if search_results.length < 1
        err_msg = "Failed to find vm in realized state with cid: #{vm_cid}, assuming vm is not attached to an NSX segment"
        logger.info(err_msg)
        return nil
      end
      # API can return several results of the VM with the same external_id and different power_state
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

    def policy_segments_api
      @policy_segments_api ||= NSXTPolicy::SegmentsApi.new(@client_builder.get_client)
    end

    def policy_groups_api
      @policy_groups_api ||= NSXTPolicy::GroupsApi.new(@client_builder.get_client)
    end

    def policy_group_members_api
      @policy_group_members_api ||= NSXTPolicy::GroupMembersApi.new(@client_builder.get_client)
    end

    def policy_load_balancer_pools_api
      @policy_load_balancer_pools_api ||= NSXTPolicy::LoadBalancerPoolsApi.new(@client_builder.get_client)
    end

    def policy_virtual_machine_api
      @policy_virtual_machine_api ||= NSXTPolicy::VirtualMachinesApi.new(@client_builder.get_client)
    end

    def search_api
      @search_api ||= NSXTPolicy::SearchApi.new(@client_builder.get_client)
    end
  end
end
