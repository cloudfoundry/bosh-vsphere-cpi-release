require 'oga'

module VSphereCloud
  class NSX

    attr_reader :http_client, :nsx_url

    def initialize(nsx_url, http_client)
      @http_client = http_client
      @nsx_url = nsx_url
    end

    def apply_tag_to_vm(tag_name, vm_id)
      tag_id = find_or_create_tag(tag_name)
      response = @http_client.put("https://#{@nsx_url}/api/2.0/services/securitytags/tag/#{tag_id}/vm/#{vm_id}", nil)
      unless response.status.between?(200, 299)
        raise "Failed to associate VM to tag with unknown NSX error: '#{response.body}'"
      end

      true
    end

    # Note: this method should only be used for cleanup in integration tests
    # Deleting tags in production code could remove tags that were created by users outside the BOSH workflow
    def delete_tag(tag_name)
      tag_id = find_tag_id_by_tag_name(tag_name)
      response = @http_client.delete("https://#{@nsx_url}/api/2.0/services/securitytags/tag/#{tag_id}")
      unless response.status.between?(200, 299)
        raise "Failed to delete tag '#{tag_name}' with unknown NSX error: '#{response.body}'"
      end

      true
    end

    def get_vms_for_tag(tag_name)
      tag_id = find_tag_id_by_tag_name(tag_name)

      response = @http_client.get("https://#{@nsx_url}/api/2.0/services/securitytags/tag/#{tag_id}/vm")
      unless response.status.between?(200, 299)
        raise "Failed to query VMs for tag '#{tag_name}' with unknown NSX error: '#{response.body}'"
      end

      extract_vms_with_tag(response)
    end

    private

    def find_or_create_tag(tag_name)
      tag =  create_new_tag(tag_name)
      return tag if tag != nil

      find_tag_id_by_tag_name(tag_name)
    end

    def extract_vms_with_tag(response)
      document = Oga.parse_xml(response.body)

      document.xpath('basicinfolist/basicinfo').map do |n|
        n.xpath('name').text
      end
    end

    def find_tag_id_by_tag_name(tag_name)
      response = @http_client.get("https://#{@nsx_url}/api/2.0/services/securitytags/tag")
      unless response.status.between?(200, 299)
        raise "Failed to query list of tags with unknown NSX error: '#{response.body}'"
      end

      document = Oga.parse_xml(response.body)

      tag_node = document.xpath('securityTags/securityTag').find do |n|
        n.xpath('name').text == tag_name
      end
      if tag_node.nil?
        raise "Unable to find tag with name '#{tag_name}'"
      end

      tag_node.xpath('objectId').text
    end

    def create_new_tag(tag_name)
      response = @http_client.post(
        "https://#{@nsx_url}/api/2.0/services/securitytags/tag",
        create_tag_content(tag_name),
        {'Content-Type' => 'text/xml'}
      )
      if response.status.between?(200,299)
        return response.body
      end

      error_document = Oga.parse_xml(response.body)
      error_code_element = error_document.xpath('error/errorCode')

      tag_already_exists = (!error_code_element.empty? && error_code_element.text == '210')
      if tag_already_exists
        return nil
      end

      raise "Failed to create tag with unknown NSX Error: '#{response.body}'"
    end

    def create_tag_content(tag_name)
      tag_contents = {
        objectTypeName: 'SecurityTag',
        type: {
          typeName: 'SecurityTag',
        },
        name: tag_name,
        description: "created by BOSH at #{Time.now}",
        extendedAttributes: nil,
      }

      ruby_struct_to_xml('securityTag', tag_contents).to_xml
    end

    def ruby_struct_to_xml(name, ruby_struct)
      # limitations:
      #   attributes are ignored
      #   can't do arrays
      element = Oga::XML::Element.new(name: name)
      if ruby_struct.is_a?(Hash)
        ruby_struct.each do |key, value|
          element.children << ruby_struct_to_xml(key, value)
        end
      elsif ruby_struct.is_a?(String)
        element.inner_text = ruby_struct
      end
      element
    end

  end
end
