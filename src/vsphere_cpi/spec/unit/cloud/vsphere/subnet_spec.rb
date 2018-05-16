require 'spec_helper'

module VSphereCloud
  describe Subnet do
    subject(:subnet) { Subnet.build(subnet_definition) }
    let(:subnet_definition) { {
      'range' => range,
      'gateway' => gateway,
      'cloud_properties' => cloud_props }
    }
    let(:cloud_props) { {
          'edge_cluster_id' => edge_cluster_id,
          't0_router_id' => t0_router_id,
          't1_name' => 'router-name',
          'transport_zone_id' => transport_zone_id,
          'switch_name' => 'switch-name',
      }
    }
    let(:range) { '192.168.111.0/24' }
    let(:gateway) {'192.168.111.1'}
    let(:t0_router_id) { 't0-router-id' }
    let(:transport_zone_id) { 'zone-id' }
    let(:edge_cluster_id) { 'cluster_id' }

    context 'when invalid subnet_definition is given' do
      context 'when cloud_properties is empty' do
        let(:cloud_props) { '' }

        it 'raises an error' do
          expect{ subnet }.to raise_error('cloud_properties must be provided')
        end
      end
      context 'when no cloud_properties given' do
        let(:subnet_definition) { {
            'range' => '192.168.111.0/24',
            'gateway' => '192.168.111.1'}
        }

        it 'raises an error' do
          expect{ subnet }.to raise_error('cloud_properties must be provided')
        end
      end

      context 'when t0_router_id is not provided' do
        let(:cloud_props) { {
            'edge_cluster_id' => 'cluster_id',
            'transport_zone_id' => 'zone-id',
        } }

        it 'raises an error' do
          expect{ subnet }.to raise_error('t0_router_id cloud property can not be empty')
        end
      end
      context 'when t0_router_id is empty' do
        let(:t0_router_id) { '' }
        it 'raises an error' do
          expect{ subnet }.to raise_error('t0_router_id cloud property can not be empty')
        end
      end


      context 'when edge_cluster_id is not provided' do
        let(:cloud_props) { {
            't0_router_id' => t0_router_id,
            'transport_zone_id' => transport_zone_id,
        } }
        it 'raises an error' do
          expect{ subnet }.to raise_error('edge_cluster_id cloud property can not be empty')
        end
      end
      context 'when edge_cluster_id is empty' do
        let(:edge_cluster_id) { '' }

        it 'raises an error' do
          expect{ subnet }.to raise_error('edge_cluster_id cloud property can not be empty')
        end
      end

      context 'when transport_zone_id is not provided' do
        let(:cloud_props) { {
            'edge_cluster_id' => edge_cluster_id,
            't0_router_id' => t0_router_id
        } }
        it 'raises an error' do
          expect{ subnet }.to raise_error('transport_zone_id cloud property can not be empty')
        end
      end
      context 'when transport_zone_id is empty' do
        let(:transport_zone_id) { '' }

        it 'raises an error' do
          expect{ subnet }.to raise_error('transport_zone_id cloud property can not be empty')
        end
      end

      context 'when range is empty' do
        let(:range) { '' }
        it 'raises an error' do
          expect{ subnet }.to raise_error('Incorrect subnet definition. Proper CIDR block range must be given')
        end
      end

      context 'when range is not provided' do
        let(:subnet_definition) { {
            'gateway' => '192.168.111.1',
            'cloud_properties' => cloud_props }
        }
        it 'raises an error' do
          expect{ subnet }.to raise_error('Incorrect subnet definition. Proper CIDR block range must be given')
        end
      end

      context 'when incorrect range is provided' do
        let(:range) { '192.168.111.111/33' }
        it 'raises an error' do
          expect{ subnet }.to raise_error('Incorrect subnet definition. Proper CIDR block range must be given')
        end
      end

      context 'when gateway is empty' do
        let(:gateway) { '' }
        it 'raises an error' do
          expect{ subnet }.to raise_error('Incorrect subnet definition. Proper gateway must be given')
        end
      end

      context 'when gateway is not provided' do
        let(:subnet_definition) { {
            'range' => range,
            'cloud_properties' => cloud_props }
        }

        it 'raises an error' do
          expect{ subnet }.to raise_error('Incorrect subnet definition. Proper gateway must be given')
        end
      end

      context 'when incorrect gateway is provided' do
        let(:gateway) { '192.168.111.111/23' }
        it 'raises an error' do
          expect{ subnet }.to raise_error('Incorrect subnet definition. Proper gateway must be given')
        end
      end
    end
  end
end