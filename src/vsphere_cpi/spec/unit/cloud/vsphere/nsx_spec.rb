require 'spec_helper'
require 'oga'

module VSphereCloud
  describe NSX do

    let(:http_client)           { instance_double(NsxHttpClient) }
    let(:logger)                { instance_double('Logger', info: nil, debug: nil) }
    let(:retryer)               { Retryer.new }
    let(:vm_id)                 { 'my-vm-id' }
    let(:vm_name)               { 'my-vm-name' }
    let(:nsx_address)           { 'my-nsx-manager' }
    let(:edge_name)             { 'fake-edge' }
    let(:edge_id)               { 'fake-edge-id' }
    let(:pool_name)             { 'fake-pool' }
    let(:pool_id)               { 'fake-pool-id' }
    let(:pool_port)             { 443 }
    let(:pool_monitor_port)     { 8443 }
    let(:sg_name)               { 'fake-security-group-name' }
    let(:sg_id)                 { 'fake-security-group-id' }
    let(:algorithm)             { 'fake-algo' }
    let(:existing_edges) do
      [
        { 'id' => edge_id, 'name' => edge_name }
      ]
    end
    let(:existing_pool_members) {
      [
        {
          'security_group_name' => sg_name,
          'security_group_id' => sg_id,
          'port' => pool_port,
          'monitor_port' => pool_monitor_port,
        }
      ]
    }

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
        expect_POST_security_group_happy
        expect_PUT_security_group_vm_happy

        nsx.add_vm_to_security_group(sg_name, vm_id)
      end

      context 'when the Security Group already exists' do
        it 'adds the VM to the existing Security Group' do
          expect_POST_security_group_conflict
          expect_GET_security_groups_happy
          expect_PUT_security_group_vm_happy

          nsx.add_vm_to_security_group(sg_name, vm_id)
        end
      end

      context 'when VM is already part of the Security Group' do
        it 'does not update the Security Group' do
          expect_POST_security_group_conflict
          expect_GET_security_groups_happy
          expect_PUT_security_group_vm_duplicate

          nsx.add_vm_to_security_group(sg_name, vm_id)
        end
      end

      context 'when the create Security Group HTTP request fails' do
        it 'returns an error' do
          expect_POST_security_group_sad

          expect {
            nsx.add_vm_to_security_group(sg_name, vm_id)
          }.to raise_error(/fake-nsx-error/)
        end
      end

      context 'when the get Security Group ID HTTP request fails' do
        it 'returns an error' do
          expect_POST_security_group_conflict
          expect_GET_security_group_sad

          expect {
            nsx.add_vm_to_security_group(sg_name, vm_id)
          }.to raise_error(/fake-nsx-error/)
        end
      end

      context 'when the add VM to Security Group HTTP request fails' do
        it 'retries until the apply succeeds when call is retryable' do
          expect(retryer).to receive(:sleep).once

          expect_POST_security_group_happy
          expect_PUT_security_group_vm_sad_retryable
          expect_PUT_security_group_vm_happy

          nsx.add_vm_to_security_group(sg_name, vm_id)
        end

        it "returns an error after #{VSphereCloud::Retryer::MAX_TRIES} retries when call is retryable" do
          expect(retryer).to receive(:sleep).exactly(VSphereCloud::NSX::MAX_TRIES - 1).times

          expect_POST_security_group_happy

          VSphereCloud::NSX::MAX_TRIES.times do
            expect_PUT_security_group_vm_sad_retryable
          end

          expect {
            nsx.add_vm_to_security_group(sg_name, vm_id)
          }.to raise_error(/could not be found/)
        end

        it 'returns an error when the call is not retryable' do
          expect_POST_security_group_happy
          expect_PUT_security_group_vm_sad_non_retryable

          expect {
            nsx.add_vm_to_security_group(sg_name, vm_id)
          }.to raise_error(/fake-nsx-error/)
        end
      end
    end

    describe '#delete_tag' do
      it 'deletes a security tag' do
        expect_GET_security_groups_happy
        expect_DELETE_security_group_happy

        nsx.delete_security_group(sg_name)
      end

      context 'when it fails' do
        it 'deletes a security tag' do
          expect_GET_security_groups_happy
          expect_DELETE_security_group_sad

          expect {
            nsx.delete_security_group(sg_name)
          }.to raise_error(/fake-nsx-error/)
        end
      end
    end

    describe '#get_vms_for_security_group' do
      it 'queries the Security Group for a list of VMs' do
        expect_GET_security_groups_happy
        expect_GET_security_group_vms_happy

        expect(nsx.get_vms_in_security_group(sg_name)).to eq([vm_name])
      end

      context 'when the HTTP call fails' do
        it 'returns an error' do
          expect_GET_security_groups_happy
          expect_GET_security_group_vms_sad

          expect {
            nsx.get_vms_in_security_group(sg_name)
          }.to raise_error(/fake-nsx-error/)
        end
      end
    end

    describe '#get_pool_members' do
      it 'queries the pool for its configuration' do
        expect_GET_edges_happy(existing_edges)
        expect_GET_pools_happy(edge_id, pool_id, pool_name, existing_pool_members)

        pool_security_groups = nsx.get_pool_members(edge_name, pool_name)
        expect(pool_security_groups).to eq([{
          'port' => pool_port.to_s,
          'monitor_port' => pool_monitor_port.to_s,
          'group_name' => sg_name,
        }])
      end

      context 'when the HTTP calls fail' do
        it 'returns an error when edge lookup fails' do
          expect_GET_edges_sad
          expect {
            nsx.get_pool_members(edge_name, pool_name)
          }.to raise_error(/fake-nsx-edge/)
        end

        it 'returns an error when pool lookup fails' do
          expect_GET_edges_happy(existing_edges)
          expect_GET_pools_sad
          expect {
            nsx.get_pool_members(edge_name, pool_name)
          }.to raise_error(/fake-pool-error/)
        end
      end

      context 'when the provided edge-name does not exist' do
        it 'returns an error' do
          expect_GET_edges_happy(existing_edges)

          expect {
            nsx.get_pool_members('invalid-edge-name', pool_name)
          }.to raise_error(/invalid-edge-name/)
        end
      end

      context 'when the provided pool-name does not exist' do
        it 'returns an error' do
          expect_GET_edges_happy(existing_edges)
          expect_GET_pools_happy(edge_id, pool_id, pool_name)

          expect {
            nsx.get_pool_members(edge_name, 'invalid-pool-name')
          }.to raise_error(/invalid-pool-name/)
        end
      end
    end

    describe '#remove_pool_members' do
      it 'clears out the members from the pool' do
        expect_GET_edges_happy(existing_edges)
        expect_GET_pools_happy(edge_id, pool_id, pool_name, existing_pool_members)
        expect_PUT_pool_happy(edge_id, pool_id, pool_name, [])

        nsx.remove_pool_members(edge_name, pool_name)
      end

      context 'when the HTTP calls fail' do
        it 'returns an error when update pool fails' do
          expect_GET_edges_happy(existing_edges)
          expect_GET_pools_happy(edge_id, pool_id, pool_name, existing_pool_members)
          expect_PUT_pool_sad

          expect {
            nsx.remove_pool_members(edge_name, pool_name)
          }.to raise_error(/fake-nsx-error/)
        end
      end
    end

    describe '#add_members_to_lbs' do
      it 'adds the specified security group to the LB\'s pool' do
        expect_GET_edges_happy(existing_edges)
        expect_GET_pools_happy(edge_id, pool_id, pool_name)
        expect_GET_security_groups_happy
        expected_members = [
          {
            'security_group_name' => sg_name,
            'security_group_id' => sg_id,
            'port' => 443,
            'monitor_port' => 8443,
          },
          {
            'security_group_name' => sg_name,
            'security_group_id' => sg_id,
            'port' => 80,
            'monitor_port' => 80,
          }
        ]
        expect_PUT_pool_happy(edge_id, pool_id, pool_name, expected_members)

        nsx.add_members_to_lbs([
          {
            'edge_name' => edge_name,
            'pool_name' => pool_name,
            'security_group' => sg_name,
            'port' => 443,
            'monitor_port' => 8443,
          },
          {
            'edge_name' => edge_name,
            'pool_name' => pool_name,
            'security_group' => sg_name,
            'port' => 80,
          }
        ])
      end

      context 'when the specified security group already exists in the LB\'s pool' do
        it 'doesn\'t try to add security group' do
          expect_GET_edges_happy(existing_edges)
          expect_GET_pools_happy(edge_id, pool_id, pool_name, existing_pool_members)
          expect_GET_security_groups_happy

          nsx.add_members_to_lbs([
            {
              'edge_name' => edge_name,
              'pool_name' => pool_name,
              'security_group' => sg_name,
              'port' => pool_port,
              'monitor_port' => pool_monitor_port,
            }
          ])

        end
      end

      # same lb, same pool, multiple sgs
      context 'when two security groups are in the same pool' do
        let(:second_sg_name)           { 'fake-second-security-group-name' }
        let(:second_sg_id)             { 'fake-second-security-group-id' }

        it 'adds both security groups' do
          expect_GET_edges_happy(existing_edges)
          expect_GET_pools_happy(edge_id, pool_id, pool_name)
          expect_GET_two_security_groups_happy
          expected_members = [
            {
              'security_group_name' => sg_name,
              'security_group_id' => sg_id,
              'port' => pool_port,
              'monitor_port' => pool_monitor_port,
            },
            {
              'security_group_name' => second_sg_name,
              'security_group_id' => second_sg_id,
              'port' => pool_port,
              'monitor_port' => pool_monitor_port,
            }
          ]
          expect_PUT_pool_happy(edge_id, pool_id, pool_name, expected_members)

          nsx.add_members_to_lbs([
            {
              'edge_name' => edge_name,
              'pool_name' => pool_name,
              'security_group' => sg_name,
              'port' => pool_port,
              'monitor_port' => pool_monitor_port,
            },
            {
              'edge_name' => edge_name,
              'pool_name' => pool_name,
              'security_group' => second_sg_name,
              'port' => pool_port,
              'monitor_port' => pool_monitor_port,
            }
          ])
        end
      end

      context 'two security groups belong to different LBs and different pools' do
        let(:second_edge_name)             { 'second-fake-edge' }
        let(:second_edge_id)               { 'second-fake-edge-id' }
        let(:second_pool_name)             { 'second-fake-pool' }
        let(:second_pool_id)               { 'second-fake-pool-id' }
        let(:existing_pool_members)        { [] }
        let(:existing_edges) do
          [
            { 'id' => edge_id, 'name' => edge_name },
            { 'id' => second_edge_id, 'name' => second_edge_name },
          ]
        end

        it 'adds both security groups' do
          expect_GET_edges_happy(existing_edges)
          expect_GET_pools_happy(edge_id, pool_id, pool_name, existing_pool_members)
          expect_GET_pools_happy(second_edge_id, second_pool_id, second_pool_name, existing_pool_members)
          expect_GET_security_groups_happy

          expected_pool_members = [
            {
              'security_group_name' => sg_name,
              'security_group_id' => sg_id,
              'port' => pool_port,
              'monitor_port' => pool_monitor_port,
            }
          ]
          expect_PUT_pool_happy(edge_id, pool_id, pool_name, expected_pool_members)
          expect_PUT_pool_happy(second_edge_id, second_pool_id, second_pool_name, expected_pool_members)

          nsx.add_members_to_lbs([
            {
              'edge_name' => edge_name,
              'pool_name' => pool_name,
              'security_group' => sg_name,
              'port' => pool_port,
              'monitor_port' => pool_monitor_port,
            },
            {
              'edge_name' => second_edge_name,
              'pool_name' => second_pool_name,
              'security_group' => sg_name,
              'port' => pool_port,
              'monitor_port' => pool_monitor_port,
            }
          ])
        end
      end

      context 'when two security groups belong to different LBs and pools with same name' do
        let(:second_edge_name)         { 'second-fake-edge' }
        let(:second_edge_id)           { 'second-fake-edge-id' }
        let(:existing_edges) do
          [
            { 'id' => edge_id, 'name' => edge_name },
            { 'id' => second_edge_id, 'name' => second_edge_name },
          ]
        end

        it 'adds both security groups' do
          expect_GET_edges_happy(existing_edges)
          expect_GET_pools_happy(edge_id, pool_id, pool_name)
          expect_GET_pools_happy(second_edge_id, pool_id, pool_name)
          expect_GET_security_groups_happy

          expected_pool_members = [
            {
              'security_group_name' => sg_name,
              'security_group_id' => sg_id,
              'port' => pool_port,
              'monitor_port' => pool_monitor_port,
            }
          ]
          expect_PUT_pool_happy(edge_id, pool_id, pool_name, expected_pool_members)
          expect_PUT_pool_happy(second_edge_id, pool_id, pool_name, expected_pool_members)

          nsx.add_members_to_lbs([
            {
              'edge_name' => edge_name,
              'pool_name' => pool_name,
              'security_group' => sg_name,
              'port' => pool_port,
              'monitor_port' => pool_monitor_port,
            },
            {
              'edge_name' => second_edge_name,
              'pool_name' => pool_name,
              'security_group' => sg_name,
              'port' => pool_port,
              'monitor_port' => pool_monitor_port,
            }
          ])
        end
      end


      context 'when pool_monitor_port is omitted' do
        let(:pool_monitor_port) { pool_port }

        it 'defaults `monitor_port` to `port` value' do
          expect_GET_edges_happy(existing_edges)
          expect_GET_pools_happy(edge_id, pool_id, pool_name)
          expect_GET_security_groups_happy

          expected_pool_members = [
            {
              'security_group_name' => sg_name,
              'security_group_id' => sg_id,
              'port' => pool_port,
              'monitor_port' => pool_monitor_port,
            }
          ]
          expect_PUT_pool_happy(edge_id, pool_id, pool_name, expected_pool_members)

          nsx.add_members_to_lbs([
            {
              'edge_name' => edge_name,
              'pool_name' => pool_name,
              'security_group' => sg_name,
              'port' => pool_port,
              'monitor_port' => pool_monitor_port,
            }
          ])
        end
      end

      context 'when the HTTP calls fail' do
        it 'returns an error' do
          expect_GET_edges_happy(existing_edges)
          expect_GET_pools_happy(edge_id, pool_id, pool_name)
          expect_GET_security_groups_happy
          expect_PUT_pool_sad

          expect {
            nsx.add_members_to_lbs([
              {
                'edge_name' => edge_name,
                'pool_name' => pool_name,
                'security_group' => sg_name,
                'port' => pool_port,
                'monitor_port' => pool_monitor_port,
              }
            ])
          }.to raise_error(/fake-nsx-error/)
        end
      end
    end

    def expect_POST_security_group_happy
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
        expect(security_group.xpath('description').text).to match(/^created by BOSH at/i)

        double('response', status: 200, body: sg_id)
      end
    end

    def expect_PUT_security_group_vm_happy
      put_response = double('response', status: 200, body: nil)
      expect(http_client).to receive(:put).with("https://#{nsx_address}/api/2.0/services/securitygroup/#{sg_id}/members/#{vm_id}", nil)
                               .and_return(put_response)
    end

    def expect_PUT_security_group_vm_duplicate
      put_response = double('response', status: 500, body: "<error><details>The object #{vm_id} is already present in the system.</details><errorCode>203</errorCode><moduleName>core-services</moduleName></error>")
      expect(http_client).to receive(:put).with("https://#{nsx_address}/api/2.0/services/securitygroup/#{sg_id}/members/#{vm_id}", nil)
                               .and_return(put_response)
    end

    def expect_PUT_security_group_vm_sad_retryable
      put_response = double('response', status: 500, body: "<error><details>The requested object : #{vm_id} could not be found. Object identifiers are case sensitive.</details><errorCode>300</errorCode><moduleName>core-services</moduleName></error>")
      expect(http_client).to receive(:put).with("https://#{nsx_address}/api/2.0/services/securitygroup/#{sg_id}/members/#{vm_id}", nil)
                               .and_return(put_response)
    end

    def expect_PUT_security_group_vm_sad_non_retryable
      put_response = double('response', status: 500, body: 'fake-nsx-error')
      expect(http_client).to receive(:put)
        .with("https://#{nsx_address}/api/2.0/services/securitygroup/#{sg_id}/members/#{vm_id}", nil)
        .and_return(put_response)
    end

    def expect_GET_security_group_vms_happy
      response_document= Oga.parse_xml("<vmnodes><vmnode><vmName>#{vm_name}</vmName><vmId>#{vm_id}</vmId></vmnode></vmnodes>")
      response = double('response', status: 200, body: response_document.to_xml)
      expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitygroup/#{sg_id}/translation/virtualmachines")
                               .and_return(response)
    end

    def expect_GET_security_group_vms_sad
      response = double('response', status: 500, body: 'fake-nsx-error')
      expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitygroup/#{sg_id}/translation/virtualmachines")
                               .and_return(response)
    end

    def expect_GET_security_groups_happy
      response_document= Oga.parse_xml("<list><securitygroup><name>#{sg_name}</name><objectId>#{sg_id}</objectId></securitygroup></list>")
      response = double('response', status: 200, body: response_document.to_xml)
      expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitygroup/scope/globalroot-0")
                               .and_return(response)
    end

    def expect_GET_two_security_groups_happy
      response_document= Oga.parse_xml("<list><securitygroup><name>#{sg_name}</name><objectId>#{sg_id}</objectId></securitygroup><securitygroup><name>#{second_sg_name}</name><objectId>#{second_sg_id}</objectId></securitygroup></list>")
      response = double('response', status: 200, body: response_document.to_xml)
      expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitygroup/scope/globalroot-0")
                               .and_return(response)
    end

    def expect_POST_security_group_conflict
      create_document = Oga.parse_xml('<error><description>fake security_group already exists msg</description><errorCode>210</errorCode></error>')
      create_response = double('response', status: 400, body: create_document.to_xml)
      expect(http_client).to receive(:post).and_return(create_response)
    end

    def expect_POST_security_group_sad
      create_response = double('response', status: 500, body: 'fake-nsx-error')
      expect(http_client).to receive(:post)
        .with("https://#{nsx_address}/api/2.0/services/securitygroup/bulk/globalroot-0", anything, anything)
        .and_return(create_response)
    end

    def expect_GET_security_group_sad
      find_sg_response = double('response', status: 500, body: 'fake-nsx-error')
      expect(http_client).to receive(:get).with("https://#{nsx_address}/api/2.0/services/securitygroup/scope/globalroot-0")
        .and_return(find_sg_response)
    end

    def expect_DELETE_security_group_happy
      delete_response = double('response', status: 200, body: '')
      expect(http_client).to receive(:delete).with("https://#{nsx_address}/api/2.0/services/securitygroup/#{sg_id}")
        .and_return(delete_response)
    end

    def expect_DELETE_security_group_sad
      delete_response = double('response', status: 500, body: 'fake-nsx-error')
      expect(http_client).to receive(:delete).with("https://#{nsx_address}/api/2.0/services/securitygroup/#{sg_id}")
                               .and_return(delete_response)
    end

    def expect_GET_edges_happy(edges)
      edge_list = {
        'edgePage' => [],
      }
      edges.each do |edge|
        edge_list['edgePage'] << {
          'edgeSummary' => {
            'objectId' => edge['id'],
            'name' => edge['name'],
          },
        }
      end

      response_body = Helpers::XML.ruby_struct_to_xml('pagedEdgeList', edge_list)
      edges_response = double('response', status: 200, body: response_body)
      expect(http_client).to receive(:get).with("https://#{nsx_address}/api/4.0/edges")
                               .and_return(edges_response)
    end

    def expect_GET_pools_happy(edge_id, pool_id, pool_name, members = [])
      pool_list = {
        'pool' => [
          { 'algorithm' => algorithm },
          { 'poolId' => pool_id },
          { 'name' => pool_name }
        ]
      }

      members.each do |member|
        pool_list['pool'] << {
          'member' => {
            'groupingObjectId' => member['security_group_id'],
            'groupingObjectName' => member['security_group_name'],
            'port' => member['port'],
            'monitorPort' => member['monitor_port'],
          }
        }
      end

      pool_list_response = double('response', status: 200, body: Helpers::XML.ruby_struct_to_xml('loadBalancer', pool_list))
      expect(http_client).to receive(:get).with("https://#{nsx_address}/api/4.0/edges/#{edge_id}/loadbalancer/config/pools")
                               .and_return(pool_list_response)
    end

    def expect_GET_edges_sad
      edge_name_response = double('response', status: 500, body: 'fake-nsx-edge')
      expect(http_client).to receive(:get).with("https://#{nsx_address}/api/4.0/edges")
                               .and_return(edge_name_response)
    end

    def expect_GET_pools_sad
      pool_name_response = double('response', status: 500, body: 'fake-pool-error')
      expect(http_client).to receive(:get).with("https://#{nsx_address}/api/4.0/edges/#{edge_id}/loadbalancer/config/pools")
                               .and_return(pool_name_response)
    end

    def expect_PUT_pool_happy(edge_id, pool_id, pool_name, members)
      expect(http_client).to receive(:put) do |url, body, headers|
        expect(url).to eq("https://#{nsx_address}/api/4.0/edges/#{edge_id}/loadbalancer/config/pools/#{pool_id}")
        expect(headers).to eq({'Content-Type' => 'text/xml'})

        element = Oga.parse_xml(body)
        target_pool_name = element.xpath('pool/name').text
        expect(target_pool_name).to eq(pool_name)
        new_algo = element.xpath('pool/algorithm').text
        expect(new_algo).to eq(algorithm)
        pool_members = element.xpath('pool/member')
        expect(pool_members.length).to eq(members.length), "Expected XML to have a #{members.length} members, but it had #{pool_members.length}"

        members.each_index do |i|
          expected_member = members[i]
          actual_member = pool_members[i]
          expect(actual_member.xpath('name').text).to eq("BOSH-#{expected_member['security_group_id']}-#{expected_member['port']}-#{expected_member['monitor_port']}")
          expect(actual_member.xpath('groupingObjectId').text).to eq(expected_member['security_group_id'])
          expect(actual_member.xpath('groupingObjectName').text).to eq(expected_member['security_group_name'])
          expect(actual_member.xpath('port').text).to eq(expected_member['port'].to_s)
          expect(actual_member.xpath('monitorPort').text).to eq(expected_member['monitor_port'].to_s)
        end

        double('response', status: 200)
      end
    end

    def expect_PUT_pool_sad
      expect(http_client).to receive(:put)
        .with("https://#{nsx_address}/api/4.0/edges/#{edge_id}/loadbalancer/config/pools/#{pool_id}", anything, anything)
        .and_return(double('response', status: 500, body: 'fake-nsx-error'))
    end
  end
end
