require 'spec_helper'
require 'oga'

module VSphereCloud
  describe NSX do

    let(:http_client) { instance_double(NsxHttpClient) }
    let(:logger)      { instance_double('Logger', info: nil, debug: nil) }
    let(:vm_id)       { 'my-vm-id' }
    let(:vm_name)     { 'my-vm-name' }
    let(:nsx_address) { 'my-nsx-manager' }
    let(:retryer)     { Retryer.new }
    let(:sg_name)     { 'fake-security-group-name' }
    let(:sg_id)       { 'fake-security-group-id' }

    subject(:nsx) do
      described_class.new(nsx_address, http_client, logger, retryer)
    end


    before do
      allow(logger).to receive(:debug)
      allow(logger).to receive(:warn)
      allow(retryer).to receive(:sleep)
    end

    describe '#add_vm_to_security_group' do
      it 'creates a security group and adds the VM to it' do
        expect(http_client).to receive(:post) do |url, body, headers|
          expect(url).to eq("https://#{nsx_address}/api/2.0/services/securitygroup/bulk/globalroot-0")
          expect(headers).to eq({'Content-Type' => 'text/xml'})

          element = Oga.parse_xml(body)
          security_groups = element.xpath('securitygroup')
          expect(security_groups.length).to eq(1), "Expected XML to have a single element, but it had #{security_groups.length}"
          security_group = security_groups.first
          expect(security_group.xpath('objectTypeName').text).to eq('SecurityGroup')
          expect(security_group.xpath('type/typeName').text).to eq('SecurityGroup')
          expect(security_group.xpath('name').text).to eq(sg_name)
          expect(security_group.xpath('description').text).to match(/^created by BOSH at/)

          double('response', status: 200, body: sg_id)
        end

        put_response = double('response', status: 200)
        expect(http_client).to receive(:put).with("https://#{nsx_address}/api/2.0/services/securitygroup/#{sg_id}/members/#{vm_id}", nil)
                                 .and_return(put_response)
        nsx.add_vm_to_security_group(sg_name, vm_id)
      end

      context 'when the Security Group already exists' do
        it 'adds the VM to the existing Security Group' do
          create_document = Oga.parse_xml('<error><description>fake security_group already exists msg</description><errorCode>210</errorCode></error>')
          create_response = double('response', status: 400, body: create_document.to_xml)
          expect(http_client).to receive(:post).and_return(create_response)

          find_security_group_document = Oga.parse_xml("<list><securitygroup><name>#{sg_name}</name><objectId>#{sg_id}</objectId></securitygroup></list>")
          find_security_group_response = double('response', status: 200, body: find_security_group_document.to_xml)
          expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitygroup/scope/globalroot-0")
                                   .and_return(find_security_group_response)

          put_response = double('response', status: 200)
          expect(http_client).to receive(:put).with("https://#{nsx_address}/api/2.0/services/securitygroup/#{sg_id}/members/#{vm_id}", nil)
                                   .and_return(put_response)
          nsx.add_vm_to_security_group(sg_name, vm_id)
        end
      end

      context 'when the create Security Group HTTP request fails' do
        it 'returns an error' do
          create_response = double('response', status: 500, body: 'fake-nsx-error')
          expect(http_client).to receive(:post).and_return(create_response)
          expect {
            nsx.add_vm_to_security_group(sg_name, vm_id)
          }.to raise_error(/fake-nsx-error/)
        end
      end

      context 'when the get Security Group ID HTTP request fails' do
        it 'returns an error' do
          create_document = Oga.parse_xml('<error><description>fake security group already exists msg</description><errorCode>210</errorCode></error>')
          create_response = double('response', status: 400, body: create_document.to_xml)
          expect(http_client).to receive(:post).and_return(create_response)

          find_sg_response = double('response', status: 500, body: 'fake-nsx-error')
          expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitygroup/scope/globalroot-0")
                                   .and_return(find_sg_response)

          expect {
            nsx.add_vm_to_security_group(sg_name, vm_id)
          }.to raise_error(/fake-nsx-error/)
        end
      end

      context 'when the add VM to Security Group HTTP request fails' do
        it 'retries until the apply succeeds when call is retryable' do
          create_response = double('response', status: 200, body: sg_id)
          expect(http_client).to receive(:post).and_return(create_response)

          put_response = double('response', status: 500, body: "<error><details>The requested object : #{vm_id} could not be found. Object identifiers are case sensitive.</details><errorCode>202</errorCode><moduleName>core-services</moduleName></error>")
          put_response_good = double('response', status: 200)
          expect(http_client).to receive(:put).with("https://#{nsx_address}/api/2.0/services/securitygroup/#{sg_id}/members/#{vm_id}", nil)
                                   .and_return(put_response)
          expect(http_client).to receive(:put).with("https://#{nsx_address}/api/2.0/services/securitygroup/#{sg_id}/members/#{vm_id}", nil)
                                   .and_return(put_response_good)

          nsx.add_vm_to_security_group(sg_name, vm_id)
        end

        it "returns an error after #{VSphereCloud::Retryer::MAX_TRIES} retries when call is retryable" do
          expect(retryer).to receive(:sleep).exactly(VSphereCloud::Retryer::MAX_TRIES - 1).times

          create_response = double('response', status: 200, body: sg_id)
          expect(http_client).to receive(:post).and_return(create_response)

          put_response = double('response', status: 500, body: "<error><details>The requested object : #{vm_id} could not be found. Object identifiers are case sensitive.</details><errorCode>202</errorCode><moduleName>core-services</moduleName></error>")
          expect(http_client).to receive(:put).with("https://#{nsx_address}/api/2.0/services/securitygroup/#{sg_id}/members/#{vm_id}", nil)
                                   .exactly(VSphereCloud::Retryer::MAX_TRIES).times
                                   .and_return(put_response)

          expect {
            nsx.add_vm_to_security_group(sg_name, vm_id)
          }.to raise_error(/could not be found/)
        end

        it 'returns an error when the call is not retryable' do
          create_response = double('response', status: 200, body: sg_id)
          expect(http_client).to receive(:post).and_return(create_response)

          put_response = double('response', status: 500, body: 'fake-nsx-error')
          expect(http_client).to receive(:put).with("https://#{nsx_address}/api/2.0/services/securitygroup/#{sg_id}/members/#{vm_id}", nil)
                                   .and_return(put_response)

          expect {
            nsx.add_vm_to_security_group(sg_name, vm_id)
          }.to raise_error(/fake-nsx-error/)
        end
      end
    end

    describe '#delete_tag' do
      it 'deletes a security tag' do
        expectGetSecurityGroupHappy

        delete_response = double('response', status: 200, body: '')
        expect(http_client).to receive(:delete).with("https://#{nsx_address}/api/2.0/services/securitygroup/#{sg_id}")
                                 .and_return(delete_response)
        nsx.delete_security_group(sg_name)
      end

      context 'when it fails' do
        it 'deletes a security tag' do
          response_document= Oga.parse_xml("<list><securitygroup><name>#{sg_name}</name><objectId>#{sg_id}</objectId></securitygroup></list>")
          response = double('response', status: 200, body: response_document.to_xml)
          expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitygroup/scope/globalroot-0")
                                   .and_return(response)

          delete_response = double('response', status: 500, body: 'fake-nsx-error')
          expect(http_client).to receive(:delete).with("https://#{nsx_address}/api/2.0/services/securitygroup/#{sg_id}")
                                   .and_return(delete_response)

          expect {
            nsx.delete_security_group(sg_name)
          }.to raise_error(/fake-nsx-error/)
        end
      end
    end

    describe '#get_vms_for_security_group' do
      it 'queries the Security Group for a list of VMs' do
        response_document= Oga.parse_xml("<list><securitygroup><name>#{sg_name}</name><objectId>#{sg_id}</objectId></securitygroup></list>")
        response = double('response', status: 200, body: response_document.to_xml)
        expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitygroup/scope/globalroot-0")
                                 .and_return(response)

        response_document= Oga.parse_xml("<vmnodes><vmnode><vmName>#{vm_name}</vmName><vmId>#{vm_id}</vmId></vmnode></vmnodes>")
        response = double('response', status: 200, body: response_document.to_xml)
        expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitygroup/#{sg_id}/translation/virtualmachines")
                                 .and_return(response)

        expect(nsx.get_vms_in_security_group(sg_name)).to eq([vm_name])
      end

      context 'when the HTTP call fails' do
        it 'returns an error' do
          response_document= Oga.parse_xml("<list><securitygroup><name>#{sg_name}</name><objectId>#{sg_id}</objectId></securitygroup></list>")
          response = double('response', status: 200, body: response_document.to_xml)
          expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitygroup/scope/globalroot-0")
                                   .and_return(response)

          response = double('response', status: 500, body: 'fake-nsx-error')
          expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitygroup/#{sg_id}/translation/virtualmachines")
                                   .and_return(response)

          expect {
            nsx.get_vms_in_security_group(sg_name)
          }.to raise_error(/fake-nsx-error/)
        end
      end
    end

    def expectGetSecurityGroupHappy
      response_document= Oga.parse_xml("<list><securitygroup><name>#{sg_name}</name><objectId>#{sg_id}</objectId></securitygroup></list>")
      response = double('response', status: 200, body: response_document.to_xml)
      expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitygroup/scope/globalroot-0")
                               .and_return(response)
    end
  end
end
