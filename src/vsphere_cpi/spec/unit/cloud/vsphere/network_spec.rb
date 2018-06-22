require 'spec_helper'

module VSphereCloud
  describe Network, fake_logger: true do
    subject(:network) { Network.build(switch_provider, router_provider, ip_block_provider) }
    let(:nsxt_provider) { instance_double(VSphereCloud::NSXTProvider) }
    let(:switch_provider) { instance_double(VSphereCloud::NSXTSwitchProvider) }
    let(:router_provider) { instance_double(VSphereCloud::NSXTRouterProvider) }
    let(:ip_block_provider) { instance_double(VSphereCloud::NSXTIpBlockProvider) }
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
      }
    }
    let(:range) { '192.168.111.0/24' }
    let(:gateway) {'192.168.111.1'}
    let(:t0_router_id) { 't0-router-id' }
    let(:transport_zone_id) { 'zone-id' }

    describe '#validate' do
      context 'when invalid network_definition is given' do
        let(:validate) { network.create(network_definition) }
        context 'when cloud_properties is empty' do
          let(:cloud_props) { '' }

          it 'raises an error' do
            expect{ validate }.to raise_error('cloud_properties must be provided')
          end
        end
        context 'when no cloud_properties given' do
          let(:network_definition) { {
              'range' => '192.168.111.0/24',
              'gateway' => '192.168.111.1'}
          }

          it 'raises an error' do
            expect{ validate }.to raise_error('cloud_properties must be provided')
          end
        end

        context 'when t0_router_id is not provided' do
          let(:cloud_props) { {
              'transport_zone_id' => 'zone-id',
          } }

          it 'raises an error' do
            expect{ validate }.to raise_error('t0_router_id cloud property can not be empty')
          end
        end
        context 'when t0_router_id is empty' do
          let(:t0_router_id) { '' }
          it 'raises an error' do
            expect{ validate }.to raise_error('t0_router_id cloud property can not be empty')
          end
        end

        context 'when transport_zone_id is not provided' do
          let(:cloud_props) { {
              't0_router_id' => t0_router_id
          } }
          it 'raises an error' do
            expect{ validate }.to raise_error('transport_zone_id cloud property can not be empty')
          end
        end
        context 'when transport_zone_id is empty' do
          let(:transport_zone_id) { '' }

          it 'raises an error' do
            expect{ validate }.to raise_error('transport_zone_id cloud property can not be empty')
          end
        end

        context 'when netmask_bits is not provided' do

          context 'when incorrect range is provided' do
            let(:range) { '192.168.111.111/33' }
            it 'raises an error' do
              expect{ validate }.to raise_error(/Netmask, 33, is out of bounds for IPv4/)
            end
          end

          context 'when gateway is empty' do
            let(:gateway) { '' }
            it 'raises an error' do
              expect{ validate }.to raise_error('Incorrect network definition. Proper gateway must be given')
            end
          end

          context 'when gateway is not provided' do
            let(:network_definition) { {
                'range' => range,
                'cloud_properties' => cloud_props }
            }

            it 'raises an error' do
              expect{ validate }.to raise_error('Incorrect network definition. Proper gateway must be given')
            end
          end

          context 'when incorrect gateway is provided' do
            let(:gateway) { '192.168.111.111/31' }
            it 'raises an error' do
              expect{ validate }.to raise_error('Incorrect network definition. Proper gateway must be given')
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
              expect{ validate }.to raise_error(/Incorrect network definition. Proper CIDR block range or netmask bits must be given/)
            end
          end

          context 'when netmask_bits is outside of range' do
            let(:netmask_bits) { '33' }
            it 'raises an error' do
              expect{ validate }.to raise_error(/Incorrect network definition. Proper CIDR block range or netmask bits must be given/)
            end
          end

          context 'when gateway is provided' do
            let(:network_definition) { {
                'gateway' => '192.168.111.1',
                'netmask_bits' => '23',
                'cloud_properties' => cloud_props }
            }

            it 'raises an error' do
              expect{ validate }.to raise_error(/Incorrect network definition. Gateway must not be provided when using netmask bits/)
            end
          end

          context 'when ip block id is not provided' do
            let(:netmask_bits) { '24' }
            let(:cloud_props) { {
                't0_router_id' => t0_router_id,
                'transport_zone_id' => transport_zone_id
            } }
            it 'raises an error' do
              expect{ validate }.to raise_error(/ip_block_id does not exist in cloud_properties/)
            end
          end
        end
      end
    end

    describe '#create' do
      let(:logical_switch) { instance_double(NSXT::LogicalSwitch,
                                             :id => 'switch-id',
                                             :display_name => 'switch-name') }
      let(:t1_router) { instance_double(NSXT::LogicalRouter,
                                        id: 't1-router-id',
                                        display_name: 'router-name' ) }
      let(:network_result) { instance_double(Network::ManagedNetwork) }
      let(:existing_logical_switches) { [] }
      let(:logical_port) { instance_double(NSXT::LogicalPort, id: 'logical-port-id') }
      let(:netaddr_gateway) { instance_double(NetAddr::CIDRv4, size: 1, ip: '192.168.111.1') }
      let(:netaddr_range) { instance_double(NetAddr::CIDRv4, netmask: '/24') }

      it 'creates T1 router and attaches it to T0, creates logical switch and attaches it to T1' do
        expect(router_provider).to receive(:get_edge_cluster_id)
          .with('t0-router-id').and_return('cluster-id')
        expect(switch_provider).to receive(:get_switches_by_name)
          .with('switch-name').and_return(existing_logical_switches)
        expect(router_provider).to receive(:create_t1_router)
          .with('cluster-id', 'router-name').and_return(t1_router)
        expect(router_provider).to receive(:enable_route_advertisement)
          .with('t1-router-id')
        expect(router_provider).to receive(:attach_t1_to_t0)
          .with('t0-router-id', 't1-router-id')
        expect(switch_provider).to receive(:create_logical_switch)
          .with('zone-id', {name: 'switch-name'}).and_return(logical_switch)

        expect(switch_provider).to receive(:create_logical_port)
           .with('switch-id').and_return(logical_port)
        expect(router_provider).to receive(:attach_switch_to_t1)
          .with('logical-port-id', 't1-router-id', instance_of(NSXT::IPSubnet))
        expect(NetAddr::CIDR).to receive(:create)
         .with('192.168.111.0/24').and_return(netaddr_range)
        expect(NetAddr::CIDR).to receive(:create)
          .with(gateway).and_return(netaddr_gateway)
        expect(Network::ManagedNetwork).to receive(:new)
          .with(logical_switch, nil, netaddr_gateway).and_return(network_result)
        expect(network.create(network_definition)).to eq(network_result)
      end

      context 'when range is not provided' do
        let(:network_definition) { {
            'netmask_bits' => 24,
            'cloud_properties' => cloud_props }
        }
        let(:cloud_props) { {
            't0_router_id' => t0_router_id,
            'transport_zone_id' => transport_zone_id,
            'ip_block_id' => 'block-id'
        }
        }
        let(:allocated_subnet) { instance_double(NSXT::IpBlockSubnet, id: 'subnet-id',
                                                 cidr: '192.168.1.0/24')}
        let(:tag) { instance_double(NSXT::Tag) }
        let(:ip_subnet) {instance_double(NSXT::IPSubnet)}
        let(:block_subnet_cidr) { '3232235776' }
        let(:gateway) { instance_double(NetAddr::CIDRv4, ip: '192.168.1.1') }

        context 'when netmask_bits are provided' do
          it 'gets subnet from ip block' do
            expect(router_provider).to receive(:get_edge_cluster_id)
              .with('t0-router-id').and_return('cluster-id')
            expect(router_provider).to receive(:create_t1_router)
              .with('cluster-id', nil).and_return(t1_router)
            expect(router_provider).to receive(:enable_route_advertisement)
              .with('t1-router-id')
            expect(router_provider).to receive(:attach_t1_to_t0)
              .with('t0-router-id', 't1-router-id')

            expect(ip_block_provider).to receive(:allocate_cidr_range)
              .with('block-id', 256).and_return(allocated_subnet)

            expect(NSXT::Tag).to receive(:new)
              .with({scope: 'bosh_cpi_subnet_id', tag: 'subnet-id'}).and_return(tag)
            expect(switch_provider).to receive(:create_logical_switch)
              .with('zone-id', {tags: [tag], name: nil}).and_return(logical_switch)

            expect(switch_provider).to receive(:create_logical_port)
              .with('switch-id').and_return(logical_port)
            expect( NSXT::IPSubnet).to receive(:new)
              .with({ip_addresses: ['192.168.1.1'],
                     prefix_length: 24}).and_return(ip_subnet)
            expect(router_provider).to receive(:attach_switch_to_t1)
              .with('logical-port-id', 't1-router-id', ip_subnet)
            expect(NetAddr::CIDR).to receive(:create)
              .with('192.168.1.0/24').and_return(block_subnet_cidr)
            expect(NetAddr::CIDR).to receive(:create)
              .with(3232235777).and_return(gateway)

            expect(Network::ManagedNetwork).to receive(:new)
              .with(logical_switch, allocated_subnet, '192.168.1.1').and_return(network_result)
            expect(network.create(network_definition)).to eq(network_result)
          end
        end

        context 'when netmask_bits are not provided' do
          let(:network_definition) { {
              'cloud_properties' => cloud_props } }

          it 'defaults value to DEFAULT_NETMASK_BITS' do
            expect(router_provider).to receive(:get_edge_cluster_id)
               .with('t0-router-id').and_return('cluster-id')
            expect(router_provider).to receive(:create_t1_router)
               .with('cluster-id', nil).and_return(t1_router)
            expect(router_provider).to receive(:enable_route_advertisement)
               .with('t1-router-id')
            expect(router_provider).to receive(:attach_t1_to_t0)
                .with('t0-router-id', 't1-router-id')
            expect(ip_block_provider).to receive(:allocate_cidr_range)
                .with('block-id', 256).and_return(allocated_subnet)

            expect(NSXT::Tag).to receive(:new)
                 .with({scope: 'bosh_cpi_subnet_id', tag: 'subnet-id'}).and_return(tag)
            expect(switch_provider).to receive(:create_logical_switch)
                 .with('zone-id', {tags: [tag], name: nil}).and_return(logical_switch)

            expect(switch_provider).to receive(:create_logical_port)
                 .with('switch-id').and_return(logical_port)
            expect( NSXT::IPSubnet).to receive(:new)
                 .with({ip_addresses: ['192.168.1.1'],
                        prefix_length: 24}).and_return(ip_subnet)
            expect(router_provider).to receive(:attach_switch_to_t1)
                 .with('logical-port-id', 't1-router-id', ip_subnet)
            expect(NetAddr::CIDR).to receive(:create)
                 .with('192.168.1.0/24').and_return(block_subnet_cidr)
            expect(NetAddr::CIDR).to receive(:create)
                 .with(3232235777).and_return(gateway)

            expect(Network::ManagedNetwork).to receive(:new)
                 .with(logical_switch, allocated_subnet, '192.168.1.1')
                 .and_return(network_result)
            expect(network.create(network_definition)).to eq(network_result)
          end
        end
      end

      context 'when optional params are not provided' do
        let(:network_definition) { {
            'range' => '192.168.111.0/24',
            'gateway' => '192.168.111.1',
            'cloud_properties' => {
                't0_router_id' => 't0-router-id',
                'transport_zone_id' => 'zone-id',
            } } }
        let(:logical_switch) { instance_double(NSXT::LogicalSwitch,
                                               :id => 'switch-id',
                                               :display_name => 'switch-id') }
        let(:t1_router) { instance_double(NSXT::LogicalRouter,
                                          id: 't1-router-id',
                                          display_name: 't1-router-id' ) }
        let(:netaddr_gateway) { instance_double(NetAddr::CIDRv4, size: 1, ip: '192.168.111.1') }
        let(:netaddr_range) { instance_double(NetAddr::CIDRv4, netmask: '/24') }

        it 'creates T1 router and attaches it to T0, creates logical switch and attaches it to T1' do
          expect(router_provider).to receive(:get_edge_cluster_id)
             .with('t0-router-id').and_return('cluster-id')
          expect(switch_provider).not_to receive(:get_switches_by_name)
             .with(nil)
          expect(router_provider).to receive(:create_t1_router)
             .with('cluster-id', nil).and_return(t1_router)
          expect(router_provider).to receive(:enable_route_advertisement)
             .with('t1-router-id')
          expect(router_provider).to receive(:attach_t1_to_t0)
             .with('t0-router-id', 't1-router-id')
          expect(switch_provider).to receive(:create_logical_switch)
             .with('zone-id', {name: nil}).and_return(logical_switch)

          expect(switch_provider).to receive(:create_logical_port)
            .with('switch-id').and_return(logical_port)
          expect(router_provider).to receive(:attach_switch_to_t1)
            .with('logical-port-id', 't1-router-id', instance_of(NSXT::IPSubnet))

          expect(NetAddr::CIDR).to receive(:create)
            .with('192.168.111.0/24').and_return(netaddr_range)
          expect(NetAddr::CIDR).to receive(:create)
            .with('192.168.111.1').and_return(netaddr_gateway)
          expect(Network::ManagedNetwork).to receive(:new)
            .with(logical_switch, nil, netaddr_gateway).and_return(network_result)

          expect(network.create(network_definition)).to eq(network_result)
        end
      end

      context 'when NSXT API returns an error' do

        context 'when failed to enable_route_advertisement' do
          it 'deletes created router' do
            expect(router_provider).to receive(:get_edge_cluster_id)
               .with('t0-router-id').and_return('cluster-id')
            expect(switch_provider).to receive(:get_switches_by_name)
               .with('switch-name').and_return(existing_logical_switches)
            expect(router_provider).to receive(:create_t1_router)
               .with('cluster-id','router-name').and_return(t1_router)
            expect(router_provider).to receive(:enable_route_advertisement)
               .with('t1-router-id').and_raise('Some nsxt error')
            expect(router_provider).to receive(:delete_t1_router)
               .with('t1-router-id')
            expect { network.create(network_definition) }
                .to raise_error(/Failed to create network/)
          end
        end
        context 'when failed to attach_t1_to_t0' do
          it 'deletes created router' do
            expect(router_provider).to receive(:get_edge_cluster_id)
               .with('t0-router-id').and_return('cluster-id')
            expect(switch_provider).to receive(:get_switches_by_name)
               .with('switch-name').and_return(existing_logical_switches)
            expect(router_provider).to receive(:create_t1_router)
               .with('cluster-id','router-name').and_return(t1_router)
            expect(router_provider).to receive(:enable_route_advertisement)
               .with('t1-router-id')
            expect(router_provider).to receive(:attach_t1_to_t0)
               .with('t0-router-id', 't1-router-id').and_raise('Some nsxt error')
            expect(router_provider).to receive(:delete_t1_router)
               .with('t1-router-id')
            expect { network.create(network_definition) }
                .to raise_error(/Failed to create network/)
          end
        end
        context 'when failed to attach_switch_to_t1' do
          it 'deletes created router and switch' do
            expect(router_provider).to receive(:get_edge_cluster_id)
               .with('t0-router-id').and_return('cluster-id')
            expect(switch_provider).to receive(:get_switches_by_name)
               .with('switch-name').and_return(existing_logical_switches)
            expect(router_provider).to receive(:create_t1_router)
               .with('cluster-id','router-name').and_return(t1_router)
            expect(router_provider).to receive(:enable_route_advertisement)
               .with('t1-router-id')
            expect(router_provider).to receive(:attach_t1_to_t0)
               .with('t0-router-id', 't1-router-id')
            expect(switch_provider).to receive(:create_logical_switch)
               .with('zone-id', {name: 'switch-name'}).and_return(logical_switch)
            expect(switch_provider).to receive(:create_logical_port)
               .with('switch-id').and_raise('Some nsxt error')

            expect(router_provider).to receive(:delete_t1_router)
               .with('t1-router-id')
            expect(switch_provider).to receive(:delete_logical_switch)
               .with('switch-id')
            expect {network.create(network_definition) }
                .to raise_error(/Failed to create network/)
          end
        end

        context 'when netmask_bits are provided' do
          let(:network_definition) { {
              'netmask_bits' => '24',
              'cloud_properties' => cloud_props }
          }

          let(:cloud_props) { {
              't0_router_id' => t0_router_id,
              'transport_zone_id' => transport_zone_id,
              'ip_block_id' => 'block-id'
          } }
          let(:allocated_subnet) { instance_double(NSXT::IpBlockSubnet, id: 'subnet-id',
                                                   cidr: '192.168.1.0/24')}

          it 'releases subnet' do
            expect(router_provider).to receive(:get_edge_cluster_id)
             .with('t0-router-id').and_raise('Some nsxt error')

            expect(ip_block_provider).to receive(:allocate_cidr_range)
             .with('block-id', 256).and_return(allocated_subnet)

            expect(ip_block_provider).to receive(:release_subnet)
             .with('subnet-id')
            expect {network.create(network_definition) }
              .to raise_error(/Failed to create network/)
          end
        end
      end

      context 'when switch with given name already exists' do
        let(:existing_logical_switches) { [ instance_double(NSXT::LogicalSwitch) ] }

        it 'throws error' do
          expect(switch_provider).to receive(:get_switches_by_name)
            .with('switch-name').and_return(existing_logical_switches)
          expect(router_provider).to receive(:get_edge_cluster_id)
            .with('t0-router-id').and_return('cluster-id')
          expect { network.create(network_definition) }
              .to raise_error(/Failed to create network/)
        end
      end
    end

    describe '#destroy' do
      let(:logical_switch) { instance_double(NSXT::LogicalSwitch, tags: nil) }
      let(:switch_ports) { [instance_double(NSXT::LogicalPort)] }

      context 'when switch id is provided' do
        it 'deletes switch and attached router' do
          expect(router_provider).to receive(:get_attached_router_ids)
             .with('switch-id').and_return(['t1-router-id'])
          expect(router_provider).to receive(:delete_t1_router)
             .with('t1-router-id')
          expect(switch_provider).to receive(:get_attached_switch_ports)
             .with('switch-id').and_return(switch_ports)
          expect(router_provider).to receive(:get_attached_switches_ids)
             .with('t1-router-id').and_return([])
          expect(switch_provider).to receive(:get_switch_by_id)
             .with('switch-id').and_return(logical_switch)
          expect(router_provider).to receive(:detach_t1_from_t0)
              .with('t1-router-id')
          expect(switch_provider).to receive(:delete_logical_switch)
             .with('switch-id')
          network.destroy('switch-id')
        end
      end

      context 'when multiple switches attached to router' do
        it 'raises an error' do
          expect(router_provider).to receive(:get_attached_router_ids)
             .with('switch-id').and_return(['t1-router-id'])
          expect(router_provider).to receive(:get_attached_switches_ids)
             .with('t1-router-id').and_return(['switch2-id'])
          expect(switch_provider).to receive(:get_attached_switch_ports)
             .with('switch-id').and_return(switch_ports)
          expect(switch_provider).to receive(:get_switch_by_id)
             .with('switch-id').and_return(logical_switch)
          expect(switch_provider).to receive(:delete_logical_switch)
             .with('switch-id')
          expect { network.destroy('switch-id') }
              .to raise_error('Can not delete router t1-router-id. It has extra ports that are not created by BOSH.')
        end
      end

      context 'when not 1 router attached to switch' do
        context 'when no routers attached' do
          it 'raises an error' do
            expect(router_provider).to receive(:get_attached_router_ids)
                .with('switch-id').and_return([])
            expect(switch_provider).not_to receive(:get_attached_switch_ports)
            expect(switch_provider).to receive(:get_switch_by_id)
                .with('switch-id')
            expect {
              network.destroy('switch-id')
            }.to raise_error('Expected switch switch-id to have one router attached. Found 0')
          end
        end
        context 'when more than one router attached' do
          it 'raises an error' do
            expect(router_provider).to receive(:get_attached_router_ids)
               .with('switch-id').and_return(['router-id','router-id2'])
            expect(switch_provider).not_to receive(:get_attached_switch_ports)
            expect(switch_provider).to receive(:get_switch_by_id)
               .with('switch-id').and_return(logical_switch)
            expect {
              network.destroy('switch-id')
            }.to raise_error('Expected switch switch-id to have one router attached. Found 2')
          end
        end
      end

      context 'when not 1 port attached to switch' do
        context 'if 0 ports attached 'do
          let(:switch_ports) { [] }
          it 'raises an error' do
            expect(router_provider).to receive(:get_attached_router_ids)
               .with('switch-id').and_return(['t1-router-id'])
            expect(switch_provider).to receive(:get_attached_switch_ports)
               .with('switch-id').and_return(switch_ports)
            expect(switch_provider).to receive(:get_switch_by_id)
               .with('switch-id').and_return(logical_switch)
            expect{
              network.destroy('switch-id')
            }.to raise_error('Expected switch switch-id to have only one port. Got 0')
          end
        end

        context 'if more than 1 attached' do
          let(:switch_ports) { [instance_double(NSXT::LogicalPort), instance_double(NSXT::LogicalPort)] }
          it 'raises an error' do
            expect(router_provider).to receive(:get_attached_router_ids)
              .with('switch-id').and_return(['t1-router-id'])
            expect(switch_provider).to receive(:get_attached_switch_ports)
              .with('switch-id').and_return(switch_ports)
            expect(switch_provider).to receive(:get_switch_by_id)
             .with('switch-id').and_return(logical_switch)
            expect{
              network.destroy('switch-id')
            }.to raise_error('Expected switch switch-id to have only one port. Got 2')
          end
        end
      end

      context 'when switch id is nil' do
        it 'raises an error' do
          expect{  network.destroy(nil) }
              .to raise_error('switch id must be provided for deleting a network')
        end
      end

      context 'when switch has bosh_cpi_subnet_id tag' do
        let(:tag) { instance_double(NSXT::Tag, scope: 'bosh_cpi_subnet_id', tag: 'subnet-id') }
        let(:logical_switch) { instance_double(NSXT::LogicalSwitch, tags: [tag]) }

        it 'releases subnet with id' do
          expect(router_provider).to receive(:get_attached_router_ids)
           .with('switch-id').and_return(['t1-router-id'])
          expect(router_provider).to receive(:detach_t1_from_t0)
           .with('t1-router-id')
          expect(router_provider).to receive(:delete_t1_router)
           .with('t1-router-id')
          expect(switch_provider).to receive(:get_attached_switch_ports)
           .with('switch-id').and_return(switch_ports)
          expect(router_provider).to receive(:get_attached_switches_ids)
           .with('t1-router-id').and_return([])
          expect(switch_provider).to receive(:delete_logical_switch)
           .with('switch-id')

          expect(switch_provider).to receive(:get_switch_by_id)
           .with('switch-id').and_return(logical_switch)
          expect(ip_block_provider).to receive(:release_subnet)
            .with('subnet-id')
          network.destroy('switch-id')
        end
      end
    end

    describe 'ManagedNetwork' do
      let(:logical_switch) { instance_double(NSXT::LogicalSwitch,
                                             :id => 'switch-id',
                                             :display_name => 'switch-name') }
      let(:gateway) { '192.168.1.1' }

      context 'when block subnet is provided' do
        let(:block_subnet) { instance_double(NSXT::IpBlockSubnet, cidr: '192.168.1.0/24') }

        it 'deserializes to correct JSON with subnet' do
          result = Network::ManagedNetwork.new(logical_switch, block_subnet, gateway)
          expect(JSON.dump(result)).to eq("[\"switch-id\",{\"range\":\"192.168.1.0/24\",\"gateway\":\"192.168.1.1\",\"reserved\":[]},{\"name\":\"switch-name\"}]")
        end
      end

      context 'when block subnet is not provided' do
        let(:block_subnet) { nil }
        it 'deserializes to correct JSON without subnet' do
          result = Network::ManagedNetwork.new(logical_switch, block_subnet, gateway)
          expect(JSON.dump(result)).to eq("[\"switch-id\",{},{\"name\":\"switch-name\"}]")
        end
      end
    end
  end
end