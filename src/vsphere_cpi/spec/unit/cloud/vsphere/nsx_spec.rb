require 'spec_helper'
require 'oga'

module VSphereCloud
  describe NSX do

    let(:http_client) { instance_double(NsxHttpClient) }
    let(:logger) { instance_double('Logger', info: nil, debug: nil) }
    let(:tag_name) { 'fake-tag-name' }
    let(:tag_id) { 'fake-tag-id' }
    let(:vm) { 'my-vm' }
    let(:nsx_address) { 'my-nsx-manager' }
    let(:retryer) { Retryer.new }

    subject(:nsx) do
      described_class.new(nsx_address, http_client, logger, retryer)
    end

    before do
      allow(logger).to receive(:debug)
      allow(logger).to receive(:warn)
      allow(retryer).to receive(:sleep)
    end

    describe '#apply_tag_to_vm' do
      it 'creates and applies a security tag to a VM' do
        expect(http_client).to receive(:post) do |url, body, headers|
          expect(url).to eq("https://#{nsx_address}/api/2.0/services/securitytags/tag")
          expect(headers).to eq({'Content-Type' => 'text/xml'})

          element = Oga.parse_xml(body)
          tags = element.xpath('securityTag')
          expect(tags.length).to eq(1), 'Expected XML to have a single element, but it did not'
          tag = tags.first
          expect(tag.xpath('objectTypeName').text).to eq('SecurityTag')
          expect(tag.xpath('type/typeName').text).to eq('SecurityTag')
          expect(tag.xpath('name').text).to eq(tag_name)
          expect(tag.xpath('description').text).to match(/^created by BOSH at/)
          expect(tag.xpath('extendedAttributes').first).to_not be_nil, 'Expected to find an "extendedAttributes" element'
          expect(tag.xpath('extendedAttributes').text).to eq(''), 'Expected "extendedAttributes" element to be empty'

          double('response', status: 200, body: 'fake-tag-id')
        end

        put_response = double('response', status: 200)
        expect(http_client).to receive(:put).with("https://#{nsx_address}/api/2.0/services/securitytags/tag/fake-tag-id/vm/#{vm}", nil)
                                 .and_return(put_response)
        nsx.apply_tag_to_vm(tag_name, vm)
      end

      context 'when the tag already exists' do
        it 'applies the existing security tag to a VM' do
          create_document = Oga.parse_xml('<error><description>fake tag already exists msg</description><errorCode>210</errorCode></error>')
          create_response = double('response', status: 400, body: create_document.to_xml)
          expect(http_client).to receive(:post).and_return(create_response)

          find_tag_document = Oga.parse_xml("<securityTags><securityTag><name>#{tag_name}</name><objectId>#{tag_id}</objectId></securityTag></securityTags>")
          find_tag_response = double('response', status: 200, body: find_tag_document.to_xml)
          expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitytags/tag")
                                   .and_return(find_tag_response)

          put_response = double('response', status: 200)
          expect(http_client).to receive(:put).with("https://#{nsx_address}/api/2.0/services/securitytags/tag/fake-tag-id/vm/#{vm}", nil)
                                   .and_return(put_response)
          nsx.apply_tag_to_vm(tag_name, vm)
        end
      end

      context 'when the create tag HTTP request fails' do
        it 'returns an error' do
          create_response = double('response', status: 500, body: 'fake-nsx-error')
          expect(http_client).to receive(:post).and_return(create_response)
          expect {
            nsx.apply_tag_to_vm(tag_name, vm)
          }.to raise_error(/fake-nsx-error/)
        end
      end

      context 'when the get tag ID HTTP request fails' do
        it 'returns an error' do
          create_document = Oga.parse_xml('<error><description>fake tag already exists msg</description><errorCode>210</errorCode></error>')
          create_response = double('response', status: 400, body: create_document.to_xml)
          expect(http_client).to receive(:post).and_return(create_response)

          find_tag_response = double('response', status: 500, body: 'fake-nsx-error')
          expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitytags/tag")
                                   .and_return(find_tag_response)

          expect {
            nsx.apply_tag_to_vm(tag_name, vm)
          }.to raise_error(/fake-nsx-error/)
        end
      end

      context 'when the tag association HTTP request fails' do
        it 'retries until the apply succeeds when call is retryable' do
          create_response = double('response', status: 200, body: 'fake-tag-id')
          expect(http_client).to receive(:post).and_return(create_response)

          put_response = double('response', status: 500, body: "<error><details>The requested object : #{vm} could not be found. Object identifiers are case sensitive.</details><errorCode>202</errorCode><moduleName>core-services</moduleName></error>")
          put_response_good = double('response', status: 200)
          expect(http_client).to receive(:put).with("https://#{nsx_address}/api/2.0/services/securitytags/tag/fake-tag-id/vm/#{vm}", nil)
                                   .and_return(put_response)
          expect(http_client).to receive(:put).with("https://#{nsx_address}/api/2.0/services/securitytags/tag/fake-tag-id/vm/#{vm}", nil)
                                   .and_return(put_response_good)

          nsx.apply_tag_to_vm(tag_name, vm)
        end

        it "returns an error after #{VSphereCloud::NSX::MAX_TRIES} retries when call is retryable" do
          expect(retryer).to receive(:sleep).exactly(VSphereCloud::NSX::MAX_TRIES - 1).times

          create_response = double('response', status: 200, body: 'fake-tag-id')
          expect(http_client).to receive(:post).and_return(create_response)

          put_response = double('response', status: 500, body: "<error><details>The requested object : #{vm} could not be found. Object identifiers are case sensitive.</details><errorCode>202</errorCode><moduleName>core-services</moduleName></error>")
          expect(http_client).to receive(:put).with("https://#{nsx_address}/api/2.0/services/securitytags/tag/fake-tag-id/vm/#{vm}", nil)
            .exactly(VSphereCloud::NSX::MAX_TRIES).times
            .and_return(put_response)

          expect {
            nsx.apply_tag_to_vm(tag_name, vm)
          }.to raise_error(/could not be found/)
        end

        it 'returns an error when the call is not retryable' do
          create_response = double('response', status: 200, body: 'fake-tag-id')
          expect(http_client).to receive(:post).and_return(create_response)

          put_response = double('response', status: 500, body: 'fake-nsx-error')
          expect(http_client).to receive(:put).with("https://#{nsx_address}/api/2.0/services/securitytags/tag/fake-tag-id/vm/#{vm}", nil)
                                   .and_return(put_response)

          expect {
            nsx.apply_tag_to_vm(tag_name, vm)
          }.to raise_error(/fake-nsx-error/)
        end
      end
    end

    describe '#delete_tag' do
      it 'deletes a security tag' do
        response_document= Oga.parse_xml("<securityTags><securityTag><name>#{tag_name}</name><objectId>#{tag_id}</objectId></securityTag></securityTags>")
        response = double('response', status: 200, body: response_document.to_xml)
        expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitytags/tag")
                                 .and_return(response)

        delete_response = double('response', status: 200, body: '')
        expect(http_client).to receive(:delete).with("https://#{nsx_address}/api/2.0/services/securitytags/tag/fake-tag-id")
                                 .and_return(delete_response)
        nsx.delete_tag(tag_name)
      end

      context 'when it fails' do
        it 'deletes a security tag' do
          response_document= Oga.parse_xml("<securityTags><securityTag><name>#{tag_name}</name><objectId>#{tag_id}</objectId></securityTag></securityTags>")
          response = double('response', status: 200, body: response_document.to_xml)
          expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitytags/tag")
                                   .and_return(response)

          delete_response = double('response', status: 500, body: 'fake-nsx-error')
          expect(http_client).to receive(:delete).with("https://#{nsx_address}/api/2.0/services/securitytags/tag/fake-tag-id")
                                   .and_return(delete_response)

          expect {
            nsx.delete_tag(tag_name)
          }.to raise_error(/fake-nsx-error/)
        end
      end
    end

    describe '#get_vms_for_tag' do
      it 'queries the security tag for a list of VMs' do
        response_document= Oga.parse_xml("<securityTags><securityTag><name>#{tag_name}</name><objectId>#{tag_id}</objectId></securityTag></securityTags>")
        response = double('response', status: 200, body: response_document.to_xml)
        expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitytags/tag")
                                 .and_return(response)

        response_document= Oga.parse_xml("<basicinfolist><basicinfo><name>#{vm}</name></basicinfo></basicinfolist>")
        response = double('response', status: 200, body: response_document.to_xml)
        expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitytags/tag/#{tag_id}/vm")
                                 .and_return(response)

        expect(nsx.get_vms_for_tag(tag_name)).to eq([vm])
      end

      context 'when the HTTP call fails' do
        it 'returns an error' do
          response_document = Oga.parse_xml("<securityTags><securityTag><name>#{tag_name}</name><objectId>#{tag_id}</objectId></securityTag></securityTags>")
          response = double('response', status: 200, body: response_document.to_xml)
          expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitytags/tag")
                                   .and_return(response)


          response = double('response', status: 500, body: 'fake-nsx-error')
          expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitytags/tag/#{tag_id}/vm")
                                   .and_return(response)

          expect {
            nsx.get_vms_for_tag(tag_name)
          }.to raise_error(/fake-nsx-error/)
        end
      end
    end
  end
end
