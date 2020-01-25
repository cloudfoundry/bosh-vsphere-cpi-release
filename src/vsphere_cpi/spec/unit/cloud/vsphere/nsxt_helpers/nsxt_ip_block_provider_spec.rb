require 'spec_helper'

module VSphereCloud
  xdescribe NSXTIpBlockProvider, fake_logger: true do
    let(:client) { instance_double(NSXT::ApiClient) }
    let(:pool_api) { instance_double(NSXT::PoolManagementApi) }

    subject(:ip_block_provider) {
      described_class.new(client)
    }

    before do
      allow(ip_block_provider).to receive(:pool_api).and_return(pool_api)
    end

    describe '#allocate_cidr_range' do
      context 'when ip block exist' do
        let(:subnet) { instance_double(NSXT::IpBlockSubnet) }
        let(:allocated_subnet) { instance_double(NSXT::IpBlockSubnet, cidr: '192.168.1.0/25') }

        it 'allocates ip block of given size' do
          expect(NSXT::IpBlockSubnet).to receive(:new)
            .with(block_id: 'block-id', size: 32).and_return(subnet)
          expect(pool_api).to receive(:create_ip_block_subnet)
            .with(subnet).and_return(allocated_subnet)
          expect(ip_block_provider.allocate_cidr_range('block-id', 32))
            .to eq(allocated_subnet)
        end
      end
    end

    describe '#release_subnet' do
      context 'when subnet was allocated' do
        it 'releases it' do
          expect(pool_api).to receive(:delete_ip_block_subnet)
            .with('subnet-id')
          ip_block_provider.release_subnet('subnet-id')
        end
      end
    end
  end
end
