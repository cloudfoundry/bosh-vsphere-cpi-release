require 'spec_helper'

module VSphereCloud
  describe NetworkDefinition, fake_logger: true do
    subject(:network) { NetworkDefinition.new(network_definition) }
    let(:network_definition) { {
        'range' => range,
        'gateway' => gateway,
        'cloud_properties' => cloud_props }
    }
    let(:cloud_props) { {
        't0_router_id' => t0_router_id,
        't1_name' => 'router-name',
        'transport_zone_id' => transport_zone_id,
        'switch_name' => 'switch-name',
    }}
    let(:range) { '192.168.111.0/24' }
    let(:gateway) {'192.168.111.1'}
    let(:t0_router_id) { 't0-router-id' }
    let(:transport_zone_id) { 'zone-id' }

    describe '#validate' do
      context 'when invalid network_definition is given' do

        context 'when cloud_properties is empty' do
          let(:cloud_props) { '' }

          it 'raises an error' do
            expect{ network }.to raise_error('cloud_properties must be provided')
          end
        end
        context 'when no cloud_properties given' do
          let(:network_definition) { {
              'range' => '192.168.111.0/24',
              'gateway' => '192.168.111.1'}
          }

          it 'raises an error' do
            expect{ network }.to raise_error('cloud_properties must be provided')
          end
        end

        context 'when t0_router_id is not provided' do
          let(:cloud_props) { {
              'transport_zone_id' => 'zone-id',
          } }

          it 'raises an error' do
            expect{ network }.to raise_error('t0_router_id cloud property can not be empty')
          end
        end
        context 'when t0_router_id is empty' do
          let(:t0_router_id) { '' }
          it 'raises an error' do
            expect{ network }.to raise_error('t0_router_id cloud property can not be empty')
          end
        end

        context 'when transport_zone_id is not provided' do
          let(:cloud_props) { {
              't0_router_id' => t0_router_id
          } }
          it 'raises an error' do
            expect{ network }.to raise_error('transport_zone_id cloud property can not be empty')
          end
        end
        context 'when transport_zone_id is empty' do
          let(:transport_zone_id) { '' }

          it 'raises an error' do
            expect{ network }.to raise_error('transport_zone_id cloud property can not be empty')
          end
        end

        context 'when netmask_bits is not provided' do

          context 'when incorrect range is provided' do
            let(:range) { '192.168.111.111/33' }
            it 'raises an error' do
              expect{ network }.to raise_error(/Netmask, 33, is out of bounds for IPv4/)
            end
          end

          context 'when gateway is empty' do
            let(:gateway) { '' }
            it 'raises an error' do
              expect{ network }.to raise_error('Incorrect network definition. Proper gateway must be given')
            end
          end

          context 'when gateway is not provided' do
            let(:network_definition) { {
                'range' => range,
                'cloud_properties' => cloud_props }
            }

            it 'raises an error' do
              expect{ network }.to raise_error('Incorrect network definition. Proper gateway must be given')
            end
          end

          context 'when incorrect gateway is provided' do
            let(:gateway) { '192.168.111.111/31' }
            it 'raises an error' do
              expect{ network }.to raise_error('Incorrect network definition. Proper gateway must be given')
            end
          end
        end

        context 'when range is not provided' do
          let(:cloud_props) { {
              't0_router_id' => t0_router_id,
              'transport_zone_id' => transport_zone_id,
              'ip_block_id' => 'block-id'
          } }

          let(:network_definition) { {
              'netmask_bits' => netmask_bits,
              'cloud_properties' => cloud_props }
          }

          context 'when netmask_bits is not a number' do
            let(:netmask_bits) { '255.255.255.0' }
            it 'raises an error' do
              expect{ network }.to raise_error(/Incorrect network definition. Proper CIDR block range or netmask bits must be given/)
            end
          end

          context 'when netmask_bits is outside of range' do
            let(:netmask_bits) { '33' }
            it 'raises an error' do
              expect{ network }.to raise_error(/Incorrect network definition. Proper CIDR block range or netmask bits must be given/)
            end
          end

          context 'when gateway is provided' do
            let(:network_definition) { {
                'gateway' => '192.168.111.1',
                'netmask_bits' => '23',
                'cloud_properties' => cloud_props }
            }

            it 'raises an error' do
              expect{ network }.to raise_error(/Incorrect network definition. Gateway must not be provided when using netmask bits/)
            end
          end

          context 'when ip block id is not provided' do
            let(:netmask_bits) { '24' }
            let(:cloud_props) { {
                't0_router_id' => t0_router_id,
                'transport_zone_id' => transport_zone_id
            } }
            it 'raises an error' do
              expect{ network }.to raise_error(/ip_block_id does not exist in cloud_properties/)
            end
          end
        end
      end
    end

    describe '#has_range?' do
      context 'when network_definition has range' do
        it 'returns true' do
          expect(network.has_range?).to be true
        end
      end

      context 'when network_definition has netmask_bits' do
        let(:network_definition) { {
            'netmask_bits' => 24,
            'cloud_properties' => cloud_props }
        }

        let(:cloud_props) { {
            't0_router_id' => t0_router_id,
            'transport_zone_id' => transport_zone_id,
            'ip_block_id' => 'ip-block-id',
        }}

        it 'returns false' do
          expect(network.has_range?).to be false
        end
      end
    end

    describe '#getters' do
      context 'when network_definition has range' do
        it 'returns correct values' do
          expect(network.netmask_bits).to be_nil
          expect(network.range_prefix).to eq(24)
          expect(network.gateway).to eq('192.168.111.1')
          expect(network.t0_router_id).to eq('t0-router-id')
          expect(network.transport_zone_id).to eq('zone-id')
          expect(network.switch_name).to eq('switch-name')
          expect(network.t1_name).to eq('router-name')
        end
      end

      context 'when switch name and t1_name are empty' do
        let(:cloud_props) { {
            't0_router_id' => t0_router_id,
            't1_name' => '',
            'transport_zone_id' => transport_zone_id,
            'switch_name' => '',
        }}
        it 'return nil' do
          expect(network.switch_name).to be_nil
          expect(network.t1_name).to be_nil
        end
      end

      context 'when network_definition has netmask_bits'  do
        let(:network_definition) { {
            'netmask_bits' => 24,
            'cloud_properties' => cloud_props }
        }

        let(:cloud_props) {{
            't0_router_id' => t0_router_id,
            'transport_zone_id' => transport_zone_id,
            'ip_block_id' => 'ip-block-id',
        }}

        it 'returns correct values' do
          expect(network.netmask_bits).to eq(24)
          expect(network.gateway).to be_nil
          expect(network.t0_router_id).to eq('t0-router-id')
          expect(network.transport_zone_id).to eq('zone-id')
          expect(network.ip_block_id).to eq('ip-block-id')
        end
      end
    end
  end
end
