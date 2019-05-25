require 'cloud/vsphere/logger'
require 'digest'
require 'swagger_client'

module VSphereCloud
  class UnrealizedResource < StandardError
    def initialize(path)
      @path = path
    end

    def to_s
      "Resource with path: #{@path} is not realized yet"
    end
  end

  class ErrorRealizingResource < StandardError
  end

  class NSXTPolicyProvider
    include Logger

    def self.build_policy_api_client(config, logger)
      configuration = SwaggerClient::Configuration.new
      configuration.host = config.host
      configuration.username = config.username
      configuration.password = config.password
      configuration.logger = logger
      configuration.client_side_validation = false
      configuration.debugging = false
      if ENV['BOSH_NSXT_CA_CERT_FILE']
        configuration.ssl_ca_cert = ENV['BOSH_NSXT_CA_CERT_FILE']
      end
      if ENV['NSXT_SKIP_SSL_VERIFY']
        configuration.verify_ssl = false
        configuration.verify_ssl_host = false
      end
      SwaggerClient::ApiClient.new(configuration)
    end

    def initialize(client, nsxt_mgr_provider)
      @client = client
      @manager_provider = nsxt_mgr_provider
      @sleep_time = DEFAULT_SLEEP
      @max_tries = MAX_TRIES
    end

    def add_vm_to_groups(vm, groups)
      logger.info("Adding vm: #{vm.cid} to groups: #{groups}")

      return if groups.nil? || groups.empty?

      # Get NSX-T segment and port map for this VM
      nsxt_segment_port_map = nsxt_segment_port_list(vm: vm)
      return if nsxt_segment_port_map.nil? || nsxt_segment_port_map.empty?

      # Get NSX-T segment port object paths from all the ports
      segment_port_paths = nsxt_segment_port_map.map do |seg_name, port_id|
        retrieve_segment_port(seg: seg_name, port: port_id)
      end.map(&:path)

      # All port paths above need to be added to the all the groups. So,
      groups.each do |grp|
        logger.info("Adding segment ports: #{segment_port_paths} to Group: #{grp}")
        retry_on_conflict("while adding vm: #{vm.cid} to group #{grp}") do
          group_obj = retrieve_group(group_id: grp)
          path_expression = get_or_create_path_expression(group_obj)
          path_expression.paths.push(*segment_port_paths)
          logger.info("Start adding vm: #{vm.cid} , group: #{group_obj}")
          group_obj = policy_group_api.update_group_for_domain(DEFAULT_NSXT_POLICY_DOMAIN, group_obj.id, group_obj)
          logger.info("Done adding vm: #{vm.cid} , group: #{group_obj}")
          group_obj
        end
      end
      logger.info("Added vm: #{vm.cid} to groups: #{groups}")
    end

    def create_segment_port(segment:, tags:)
      port_id = "#{tags.vm_name}_#{segment}_#{tags.network_index}"
      port_tags = tags.each_pair.map do |type, value|
        SwaggerClient::Tag.new(scope: "cpi/#{type}", tag: value)
      end

      port_attachment = SwaggerClient::PortAttachment.new(id: "#{SecureRandom.uuid}", type: DEFAULT_VIF_TYPE)
      segment_port = SwaggerClient::SegmentPort.new(id: port_id, display_name: port_id,
                                                    description: "Created by BOSH vSphere-CPI", tags: port_tags, attachment: port_attachment)
      logger.info("Creating Segment Port #{port_id} on segment #{segment} with tags #{tags}")
      retry_on_conflict("while creating segment port #{port_id} on segment #{segment}") do
        segment_port = policy_segment_port_api.create_or_replace_infra_segment_port(segment, port_id, segment_port)
      end
      poll_until_realized(intent_path: segment_port.path)
      logger.info("Finished creating segment port #{segment_port.id} "\
                            "with port attachment id: #{segment_port.attachment.id}")
      segment_port.attachment.id
    end

    def remove_vm_from_groups(vm)
      logger.info("Removing vm: #{vm.cid} from all Policy Groups it is part of")

      # Get NSX-T segment and port map for this VM
      nsxt_segment_port_list = nsxt_segment_port_list(vm: vm) or return

      # Get NSX-T segment port object paths from all the ports
      segment_port_paths = nsxt_segment_port_list.map do |seg_name, port_id|
        policy_segment_port_api.get_infra_segment_port(seg_name, port_id)
      end.map(&:path)

      all_groups = retrieve_all_groups

      # For all the groups
      all_groups.each do |grp|
        retry_on_conflict("while removing vm: #{vm.cid} from group #{grp.id}") do
          grp = retrieve_group(group_id: grp.id)
          # Nothing to delete from the empty group
          break if grp.expression.nil? || grp.expression.empty?

          modified_grp = false
          all_path_expressions = grp.expression.select{|expr| expr.is_a?(SwaggerClient::PathExpression)}

          # for all the path expressions in a group
          exprs_to_delete = []
          all_path_expressions.each_with_index do |path_expr, index|
            # Next if there are no PATHS in the path expression
            next if path_expr.paths.nil? || path_expr.paths.empty?
            logger.info("Removing intersection port paths #{segment_port_paths} from grp: #{grp.id}")
            old_length = path_expr.paths.length
            # For each path in path expression , delete if it is in segment port paths
            path_expr.paths.delete_if do |path|
              segment_port_paths.include?(path)
            end
            new_length = path_expr.paths.length
            modified_grp = true if old_length != new_length
            # Delete the expression itself if it contains no path.
            if path_expr.paths.empty?
              exprs_to_delete << path_expr
              # For the conjunction operator
              exprs_to_delete << grp.expression[index - 1] if index > 0
            end
          end
          if modified_grp
            exprs_to_delete.each do|expr|
              logger.info("Removing Expression #{expr.id} from grp: #{grp.id}")
              grp.expression.delete(expr)
            end
            logger.info("Start Removing vm: #{vm.cid} , group #{grp}")
            grp = policy_group_api.update_group_for_domain(DEFAULT_NSXT_POLICY_DOMAIN, grp.id, grp)
            logger.info("Done Removing vm: #{vm.cid} group: #{grp}")
          end
          # The block must not return nil
          grp
        end
      end
      logger.info("Removed vm: #{vm.cid} from all Policy Groups it was part of")
    end

    def update_vm_metadata_on_logical_ports(vm, metadata)
      return unless metadata.has_key?('id')

      segment_port_list = nsxt_segment_port_list(vm: vm)
      return if segment_port_list.nil?

      segment_port_list.each do |seg_name, port_id|
        logger.info("Adding tag: #{metadata['id']} to segment: #{seg_name} and port: #{port_id} for vm: #{vm.cid}")
        begin
          retry_on_conflict("while adding tag: #{metadata['id']} to segment: #{seg_name} and port: #{port_id} for vm: #{vm.cid}") do
            segment_port = policy_segment_port_api.get_infra_segment_port(seg_name, port_id)
            id_tag = SwaggerClient::Tag.new(scope: 'bosh/id', tag: Digest::SHA1.hexdigest(metadata['id']))
            segment_port.tags << id_tag
            segment_port = policy_segment_port_api.create_or_replace_infra_segment_port(seg_name, port_id, segment_port)
            logger.info("Added tag: #{metadata['id']} to segment: #{seg_name} and port: #{port_id} for vm: #{vm.cid}")
            segment_port
          end
        end
      end
    end

    def delete_segment_ports(vm:)
      logger.info("Deleting all segment ports on the VM: #{vm.cid}")
      nsxt_segment_port_list = nsxt_segment_port_list(vm: vm)
      return if nsxt_segment_port_list.nil? || nsxt_segment_port_list.empty?
      nsxt_segment_port_list.each do |seg, port|
        delete_segment_port(segment: seg, port: port)
      end
      logger.info("Deleted all segment ports on the VM: #{vm.cid}")
    end

    private

    DEFAULT_NSXT_POLICY_DOMAIN = 'default'.freeze
    DEFAULT_SLEEP = 1
    MAX_TRIES=100
    DEFAULT_VIF_TYPE = 'PARENT'.freeze

    def delete_segment_port(segment:, port:)
      logger.info("Deleting port: #{port} on segment: #{segment}")
      begin
        policy_segment_port_api.delete_infra_segment_port(segment, port)
      rescue => e
        logger.info("Failed to Delete port: #{port} on segment: #{segment} with message: #{e.inspect} with code #{e.code}")
        raise e
      end
      logger.info("Finished Deleting logical port: #{port} on segment: #{segment}")
    end

    def get_or_create_path_expression(group_obj)
      # NSX-T group objects with zero expressions have nil instead of [] for empty expression list.
      if group_obj.expression.nil?
        group_obj.expression = []
      end

      if group_obj.expression.empty?
        group_obj.expression << SwaggerClient::PathExpression.new(resource_type: 'PathExpression',
                                                                  id:"path-#{SecureRandom.uuid}", paths: [])
        return group_obj.expression.first
      end

      # get first path expression
      # There could be multiple path expressions but we only need one as there is
      # no restriction on number of paths one can add to one path expression
      #   Why would there be multiple?
      #   Because NSX-T allows it and someone could end up creating more such lists.
      path_expression = group_obj.expression.detect{|expr| expr.is_a?(SwaggerClient::PathExpression)}
      return path_expression unless path_expression.nil?

      # No path expression exists
      # Add new path expression with a conjunction operator
      # Add an OR(Union) conjunction operator
      group_obj.expression << SwaggerClient::ConjunctionOperator.new(resource_type: 'ConjunctionOperator',
                                                                     conjunction_operator: 'OR',
                                                                     id: "conjunction-#{SecureRandom.uuid}")
      group_obj.expression << SwaggerClient::PathExpression.new(resource_type: 'PathExpression',
                                                                id:"path-#{SecureRandom.uuid}", paths: [])
      return group_obj.expression.last
    end

    def nsxt_segment_port_list(vm:)
      vm_segment_manager_vif_list = vm.get_nsxt_segment_vif_list
      @manager_provider.retrieve_lport_display_names_from_vif_ids(vm_segment_manager_vif_list)
    end

    def policy_group_api
      @policy_group_api ||= SwaggerClient::PolicyApi.new(@client)
    end

    def policy_realization_api
      @policy_realization_api ||= SwaggerClient::PolicyRealizationApi.new(@client)
    end

    def policy_segment_port_api
      @policy_segment_port_api ||= SwaggerClient::PolicyConnectivitySegmentsPortsApi.new(@client)
    end

    def policy_segment_api
      @policy_segment_api ||= SwaggerClient::PolicyConnectivitySegmentsApi.new(@client)
    end

    def poll_until_realized(intent_path:, vm: nil)
      Bosh::Retryable.new(
          tries: @max_tries,
          sleep: ->(try_count, retry_exception) { @sleep_time },
          on: [UnrealizedResource]
      ).retryer do |i|
        logger.info("Polling (try:##{i}) to check if Entity with path: #{intent_path} is realized or not")
        result = policy_realization_api.list_realized_entities(intent_path)

        # In case policy API has not started realizing an entity. the results should be nil then as count is 0
        raise UnrealizedResource.new(intent_path) if result.result_count == 0
        # A single policy resource might need multiple manager realizations to happen
        # before it could be use. Here we are checking that all the
        # GenericPolicyRealizedResource objects (the results) have been realized
        # and raise an error if any of the realization object is in ERROR state.
        realized = result.results.all? do |res|
          if res.state == 'ERROR'
            raise ErrorRealizingResource.new("Error realizing entity #{res} for intent path: #{intent_path}")
          end
          res.state == 'REALIZED'
        end
        # If none has been realized yet, raise error
        raise UnrealizedResource.new(intent_path) unless realized
        logger.info("Context VM: #{vm.cid unless vm.nil?} Entity: #{intent_path} realized.")
        realized
      end
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

    def retrieve_segment_port(seg:, port:)
      logger.info("Searching for segment port: #{port} on segment: #{seg}")
      begin
        segment_port = policy_segment_port_api.get_infra_segment_port(seg, port)
      rescue => e
        logger.info("Failed to find port: #{port} on segment: #{seg}")
        raise e
      end
      segment_port
    end

    def retrieve_all_with_pagination(object_type:)
      logger.info("Gathering all #{object_type}")
      objects = []
      result_list = yield
      objects.push(*result_list.results)
      until result_list.cursor.nil?
        result_list = yield(result_list.cursor)
        objects.push(*result_list.results)
      end
      logger.info("Found #{objects.size} number of #{object_type}")
      objects
    end

    def retrieve_all_groups
      retrieve_all_with_pagination(object_type: 'Policy Group') do |cursor=nil|
        unless cursor.nil?
          policy_group_api.list_group_for_domain(DEFAULT_NSXT_POLICY_DOMAIN, cursor: cursor)
        else
          policy_group_api.list_group_for_domain(DEFAULT_NSXT_POLICY_DOMAIN)
        end
      end
    end

    def retry_on_conflict(log_str)
      # @TA: TODO : Are 1000 tries enough? or more?
      Bosh::Retryable.new(
          tries: 1000,
          sleep: ->(try_count, retry_exception) { @sleep_time },
          on: [VSphereCloud::RevisionConflictMatcher]
      ).retryer do |_|
        begin
          yield
        rescue SwaggerClient::ApiCallError => e
          logger.info("Revision Error: #{log_str if log_str} with message #{e.message}") if [412, 409].include?(e.code)
          raise e
        end
      end
      # rescue SwaggerClient::ApiCallError => e
      #   if [409, 412].include?(e.code)
      #     logger.info("Revision Error: #{log_str if log_str} with message #{e.message}")
      #     # To limit request rate on NSX-T server
      #     sleep(rand(5)/2.0)
      #     retry
      #   end
      #   logger.info("Failed #{log_str if log_str} with message #{e.message}")
      #   raise e
      # end
      # end
      # yield
    end
  end

  module RevisionConflictMatcher
    include Logger
    def matches?(exception)
      exception.is_a?(SwaggerClient::ApiCallError) && [409, 412].include?(exception.code)
    end

    module_function :matches?
  end
end
