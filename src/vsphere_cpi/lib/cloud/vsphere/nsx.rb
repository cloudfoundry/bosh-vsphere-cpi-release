require 'oga'

module VSphereCloud
  class NSX

    # use a large number of retries as we investigate NSX error messages around finding VM ID
    # <error>
    #   <details>Requested member vm-84357 could not be found for addition to Security Group securitygroup-53.</details>
    #   <errorCode>300</errorCode>
    #   <moduleName>core-services</moduleName>
    # </error>
    MAX_TRIES = 20

    attr_reader :http_client, :nsx_url

    def initialize(nsx_url, http_client, logger, retryer = nil)
      @http_client = http_client
      @nsx_url = nsx_url
      @logger = logger
      @retryer = retryer || Retryer.new
    end

    def add_vm_to_security_group(security_group_name, vm_id)
      sg_id = find_or_create_security_group(security_group_name)

      @retryer.try(MAX_TRIES) do |i|
        if i == 0
          @logger.debug("Adding VM '#{vm_id}' to Security Group '#{security_group_name}'...")
        else
          @logger.warn("Retrying adding VM '#{vm_id}' to Security Group '#{security_group_name}', #{i} attempts so far...")
        end

        response = @http_client.put("https://#{@nsx_url}/api/2.0/services/securitygroup/#{sg_id}/members/#{vm_id}", nil)
        unless response.status.between?(200, 299) || vm_belongs_to_security_group?(response.body)
          unless is_attach_error_retryable?(response.body)
            raise "Failed to add VM to Security Group with unknown NSX error: '#{response.body}'"
          end

          err = "Failed to locate VM with VM ID '#{vm_id}' via NSX API: '#{response.body}'"
          @logger.warn(err)
          [nil, err]
        else
          [response, nil]
        end
      end

      @logger.debug("Successfully added VM '#{vm_id}' to Security Group '#{security_group_name}'.")

      true
    end

    # Note: this method should only be used for cleanup in integration tests
    # Deleting SGs in production code could remove SGs that were created by users outside the BOSH workflow
    def delete_security_group(security_group_name)
      @logger.debug("Deleting Security Group '#{security_group_name}'...")

      sg_id = find_security_group_id_by_name(security_group_name)
      response = @http_client.delete("https://#{@nsx_url}/api/2.0/services/securitygroup/#{sg_id}")
      unless response.status.between?(200, 299)
        raise "Failed to delete Security Group '#{security_group_name}' with unknown NSX error: '#{response.body}'"
      end

      @logger.debug("Successfully deleted Security Group '#{security_group_name}'.")

      true
    end

    def get_vms_in_security_group(security_group_name)
      @logger.debug("Querying VMs attached to Security Group '#{security_group_name}'...")

      sg_id = find_security_group_id_by_name(security_group_name)

      response = @http_client.get("https://#{@nsx_url}/api/2.0/services/securitygroup/#{sg_id}/translation/virtualmachines")
      unless response.status.between?(200, 299)
        raise "Failed to query VMs for Security Group '#{security_group_name}' with unknown NSX error: '#{response.body}'"
      end

      vms = extract_vms_in_security_group(response)
      @logger.debug("Found VMs #{vms.join(', ')} belonging to Security Group '#{security_group_name}'.")

      vms
    end

    def get_pool_members(edge_name, pool_name)
      edge_id = get_edge_id(edge_name)
      pool_element = get_pool_details(edge_id, pool_name)

      extract_pool_member_names(pool_element)
    end

    # Note: this method should only be used for cleanup in integration tests
    # Deleting pool members in production code is usually unsafe as other VMs may be routable using the same member
    def remove_pool_members(edge_name, pool_name)
      edge_id = get_edge_id(edge_name)
      document = get_pool_details(edge_id, pool_name)
      pool_id = document.xpath('poolId').text
      document.xpath('member').remove

      response = @http_client.put("https://#{@nsx_url}/api/4.0/edges/#{edge_id}/loadbalancer/config/pools/#{pool_id}", document.to_xml, { 'Content-Type' => 'text/xml' })
      unless response.status.between?(200, 299)
        raise "Failed to update Pool '#{pool_name}' under Edge '#{edge_name}' with unknown NSX error: '#{response.body}'"
      end
    end

    # This method assumes provided Security Groups already exist
    def add_members_to_lbs(members)
      populate_security_group_ids(members)

      edges = members.map { |member| member['edge_name'] }.uniq
      edge_elements = get_edge_list_element
      edges.each do |edge_name|
        edge_node = edge_elements.find do |n|
          n.xpath('name').text == edge_name
        end
        if edge_node.nil?
          raise "Unable to find Edge with name '#{edge_name}'"
        end
        edge_id = edge_node.xpath('objectId').text

        members_of_edge = members.select { |member| member['edge_name'] == edge_name }
        pools = members_of_edge.map { |member| member['pool_name'] }.uniq

        pools.each do |pool_name|
          members_of_pool = members_of_edge.select { |member| member['pool_name'] == pool_name }
          add_bundled_members_to_lbs(edge_id, pool_name, members_of_pool)
        end
      end
    end

    private

    def populate_security_group_ids(members)
      security_groups = get_security_group_list_element
      members.each do |member|
        sg_name = member['security_group']

        security_group_node = security_groups.find do |n|
          n.xpath('name').text == sg_name
        end
        if security_group_node.nil?
          raise "Unable to find Security Group with name '#{sg_name}'"
        end
        member['security_group_id'] = security_group_node.xpath('objectId').text
      end
    end

    def add_bundled_members_to_lbs(edge_id, pool_name, members_of_pool)
      pool_details = get_pool_details(edge_id, pool_name)
      pool_id = pool_details.xpath('poolId').text

      members_to_add = select_members_to_add_to_lb(pool_details, members_of_pool)
      if members_to_add.empty?
        return
      end

      pool_xml = create_pool_xml(pool_details, members_to_add)
      response = @http_client.put("https://#{@nsx_url}/api/4.0/edges/#{edge_id}/loadbalancer/config/pools/#{pool_id}", pool_xml, { 'Content-Type' => 'text/xml' })
      unless response.status.between?(200, 299)
        raise "Failed to update LB Pool ID '#{pool_id}' under Edge ID '#{edge_id}' with unknown NSX error: '#{response.body}'"
      end
    end

    def select_members_to_add_to_lb(pool_details, members_of_pool)
      pool_name = pool_details.xpath('name').text
      members_to_add = []
      members_of_pool.each do |member|
        security_group_id = member['security_group_id']
        port = member['port']
        monitor_port = member['monitor_port'] || member['port']
        if already_member?(pool_details, security_group_id, port, monitor_port)
          @logger.debug("LB Pool '#{pool_name}' already has a Security Group with Id '#{security_group_id}' port '#{port}' monitor_port #{monitor_port}, not adding.")
        else
          members_to_add << member
        end
      end
      members_to_add
    end

    def already_member?(pool_details, security_group_id, port, monitor_port)
      pool_details.xpath('member').each do |member|
        member_id_matches = member.xpath('groupingObjectId').text == security_group_id
        member_port_matches = member.xpath('port').text == port.to_s
        member_monitor_port_matches = member.xpath('monitorPort').text == monitor_port.to_s
        if member_id_matches && member_port_matches && member_monitor_port_matches
          return true
        end
      end
      false
    end

    def find_or_create_security_group(security_group_name)
      security_group = create_new_security_group(security_group_name)
      return security_group if security_group != nil

      find_security_group_id_by_name(security_group_name)
    end

    def get_edge_id(edge_name)
      edge_list = get_edge_list_element
      edge_node = edge_list.find do |n|
        n.xpath('name').text == edge_name
      end
      if edge_node.nil?
        raise "Unable to find Edge with name '#{edge_name}'"
      end

      edge_node.xpath('objectId').text
    end

    def get_edge_list_element
      response = @http_client.get("https://#{@nsx_url}/api/4.0/edges")
      unless response.status.between?(200, 299)
        raise "Failed to list Edges with unknown NSX error: '#{response.body}'"
      end
      document = Oga.parse_xml(response.body)
      document.xpath('pagedEdgeList/edgePage/edgeSummary')
    end

    def get_pool_id(edge_id, pool_name)
      get_pool_details(edge_id, pool_name).xpath('poolId').text
    end

    def get_pool_details(edge_id, pool_name)
      response = @http_client.get("https://#{@nsx_url}/api/4.0/edges/#{edge_id}/loadbalancer/config/pools")
      unless response.status.between?(200, 299)
        raise "Failed to query edge's '#{edge_id}' pool's '#{pool_name}' security tag with unknown NSX error: '#{response.body}'"
      end
      document = Oga.parse_xml(response.body)
      pool_node = document.xpath('loadBalancer/pool').find do |n|
        n.xpath('name').text == pool_name
      end
      if pool_node.nil?
        raise "Unable to find Pool with name '#{pool_name}' under Edge with ID '#{edge_id}'"
      end

      pool_node
    end

    def extract_pool_member_names(lb_element)
      member_names = []
      lb_element.xpath('member').each do |member|
        member_names << {
          'group_name' => member.xpath('groupingObjectName').text,
          'port' => member.xpath('port').text,
          'monitor_port' => member.xpath('monitorPort').text,
        }
      end

      member_names
    end

    def extract_vms_in_security_group(response)
      document = Oga.parse_xml(response.body)

      document.xpath('vmnodes/vmnode').map do |n|
        n.xpath('vmName').text
      end
    end

    def get_security_group_list_element
      response = @http_client.get("https://#{@nsx_url}/api/2.0/services/securitygroup/scope/globalroot-0")
      unless response.status.between?(200, 299)
        raise "Failed to query list of Security Groups with unknown NSX error: '#{response.body}'"
      end

      document = Oga.parse_xml(response.body)
      document.xpath('list/securitygroup')
    end

    def find_security_group_id_by_name(security_group_name)
      response = @http_client.get("https://#{@nsx_url}/api/2.0/services/securitygroup/scope/globalroot-0")
      unless response.status.between?(200, 299)
        raise "Failed to query list of Security Groups with unknown NSX error: '#{response.body}'"
      end

      document = Oga.parse_xml(response.body)

      security_group_node = document.xpath('list/securitygroup').find do |n|
        n.xpath('name').text == security_group_name
      end
      if security_group_node.nil?
        raise "Unable to find Security Group with name '#{security_group_name}'"
      end

      security_group_node.xpath('objectId').text
    end

    def create_new_security_group(security_group_name)
      response = @http_client.post(
        "https://#{@nsx_url}/api/2.0/services/securitygroup/bulk/globalroot-0",
        create_security_group_content(security_group_name),
        {'Content-Type' => 'text/xml'}
      )
      if response.status.between?(200, 299)
        return response.body
      end

      error_document = Oga.parse_xml(response.body)
      error_code_element = error_document.xpath('error/errorCode')

      tag_already_exists = (!error_code_element.empty? && error_code_element.text == '210')
      if tag_already_exists
        return nil
      end

      raise "Failed to create Security Group with unknown NSX Error: '#{response.body}'"
    end

    def create_security_group_content(security_group_name)
      security_group_contents = {
        objectTypeName: 'SecurityGroup',
        type: {
          typeName: 'SecurityGroup',
        },
        name: security_group_name,
        description: "Created by BOSH at #{Time.now}. If 'Static include members' is empty, this group can safely be deleted.",
        extendedAttributes: nil,
      }

      Helpers::XML.ruby_struct_to_xml('securitygroup', security_group_contents)
    end

    def create_pool_xml(existing_pool_element, members_to_add)
      members_to_add.each do |member|
        security_group_id = member['security_group_id']
        port = member['port']
        monitor_port = member['monitor_port'] || member['port']

        member_contents = {
          name: "BOSH-#{security_group_id}-#{port}-#{monitor_port}",
          groupingObjectId: security_group_id,
          groupingObjectName: member['security_group'],
          port: port.to_s,
          monitorPort: monitor_port.to_s,
        }
        member_node = Helpers::XML.ruby_struct_to_xml_element('member', member_contents)
        existing_pool_element.children << member_node
      end

      existing_pool_element.to_xml
    end

    def is_attach_error_retryable?(xml_content)
      error_document = Oga.parse_xml(xml_content)
      error_code_element = error_document.xpath('error/errorCode')

      vm_not_found = (!error_code_element.empty? && error_code_element.text == '300')
      vm_not_found ? true : false
    end

    def vm_belongs_to_security_group?(xml_content)
      if xml_content.nil?
        return false
      end

      error_document = Oga.parse_xml(xml_content)
      error_code_element = error_document.xpath('error/errorCode')

      vm_in_security_group = (!error_code_element.empty? && error_code_element.text == '203')
      vm_in_security_group ? true : false
    end
  end
end
