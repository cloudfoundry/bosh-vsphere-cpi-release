require 'oga'

module VSphereCloud
  class NSX

    attr_reader :http_client, :nsx_url

    def initialize(nsx_url, http_client, logger, retryer = nil)
      @http_client = http_client
      @nsx_url = nsx_url
      @logger = logger
      @retryer = retryer || Retryer.new
    end

    def add_vm_to_security_group(security_group_name, vm_id)

      sg_id = find_or_create_security_group(security_group_name)

      @retryer.try do |i|
        if i == 0
          @logger.debug("Adding VM '#{vm_id}' to Security Group '#{security_group_name}'...")
        else
          @logger.warn("Retrying adding VM '#{vm_id}' to Security Group '#{security_group_name}', #{i} attempts so far...")
        end

        response = @http_client.put("https://#{@nsx_url}/api/2.0/services/securitygroup/#{sg_id}/members/#{vm_id}", nil)
        unless response.status.between?(200, 299)
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
      @logger.debug("Querying VMs attached to Secuurity Group '#{security_group_name}'...")

      sg_id = find_security_group_id_by_name(security_group_name)

      response = @http_client.get("https://#{@nsx_url}/api/2.0/services/securitygroup/#{sg_id}/translation/virtualmachines")
      unless response.status.between?(200, 299)
        raise "Failed to query VMs for Security Group '#{security_group_name}' with unknown NSX error: '#{response.body}'"
      end

      vms = extract_vms_in_security_group(response)
      @logger.debug("Found VMs #{vms.join(', ')} belonging to Security Group '#{security_group_name}'.")

      vms
    end

    private

    def find_or_create_security_group(security_group_name)
      security_group = create_new_security_group(security_group_name)
      return security_group if security_group != nil

      find_security_group_id_by_name(security_group_name)
    end

    def extract_vms_in_security_group(response)
      document = Oga.parse_xml(response.body)

      document.xpath('vmnodes/vmnode').map do |n|
        n.xpath('vmName').text
      end
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
        description: "created by BOSH at #{Time.now}",
        extendedAttributes: nil,
      }

      Helpers::XML.ruby_struct_to_xml('securitygroup', security_group_contents)
    end

    def is_attach_error_retryable?(xml_content)
      error_document = Oga.parse_xml(xml_content)
      error_code_element = error_document.xpath('error/errorCode')

      vm_not_found = (!error_code_element.empty? && error_code_element.text == '202')
      vm_not_found ? true : false
    end
  end
end
