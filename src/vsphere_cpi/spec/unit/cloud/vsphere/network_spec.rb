require 'spec_helper'

module VSphereCloud
  describe Network, fake_logger: true do
    subject(:network) { Network.new(switch_provider, router_provider, ip_block_provider) }
    let(:nsxt_provider) { instance_double(VSphereCloud::NSXTProvider) }
    let(:switch_provider) { instance_double(VSphereCloud::NSXTSwitchProvider) }
    let(:router_provider) { instance_double(VSphereCloud::NSXTRouterProvider) }
    let(:ip_block_provider) { instance_double(VSphereCloud::NSXTIpBlockProvider) }
    let(:network_definition) { instance_double(VSphereCloud::NetworkDefinition,
                                  transport_zone_id: 'zone-id',
                                  gateway: gateway,
                                  range_prefix: 24,
                                  t0_router_id: t0_router_id,
                                  switch_name: 'switch-name',
                                  t1_name: 'router-name') }

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

    describe '#create' do
      let(:logical_switch) { instance_double(NSXT::LogicalSwitch,
                                             :id => 'switch-id',
                                             :display_name => 'switch-name') }
      let(:t1_router) { instance_double(NSXT::LogicalRouter,
                                        id: 't1-router-id',
                                        display_name: 'router-name' ) }
      let(:network_result) { instance_double(VSphereCloud::ManagedNetwork) }
      let(:existing_logical_switches) { [] }
      let(:logical_port) { instance_double(NSXT::LogicalPort, id: 'logical-port-id') }
      let(:netaddr_gateway) { instance_double(NetAddr::CIDRv4, size: 1, ip: '192.168.111.1') }
      let(:netaddr_range) { instance_double(NetAddr::CIDRv4, netmask: '/24') }

      context 'when range is provided' do
        it 'creates T1 router and attaches it to T0, creates logical switch and attaches it to T1' do
          expect(network_definition).to receive(:has_range?)
            .and_return(true)
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
            .with('zone-id', name: 'switch-name', tags: nil).and_return(logical_switch)

          expect(switch_provider).to receive(:create_logical_port)
             .with('switch-id').and_return(logical_port)
          expect(router_provider).to receive(:attach_switch_to_t1)
            .with('logical-port-id', 't1-router-id', '192.168.111.1', 24)

          expect(VSphereCloud::ManagedNetwork).to receive(:new)
            .with(logical_switch).and_return(network_result)
          expect(network.create(network_definition)).to eq(network_result)
        end
      end

      context 'when range and optional params are not provided ' do
        let(:network_definition) { instance_double(VSphereCloud::NetworkDefinition,
                                                   netmask_bits: 24,
                                                   ip_block_id: 'block-id',
                                                   transport_zone_id: 'zone-id',
                                                   t0_router_id: t0_router_id,
                                                   switch_name: nil,
                                                   t1_name: nil) }
        let(:cloud_props) { {
            't0_router_id' => t0_router_id,
            'transport_zone_id' => transport_zone_id,
            'ip_block_id' => 'block-id'
        }}
        let(:allocated_subnet) { instance_double(NSXT::IpBlockSubnet, id: 'subnet-id',
                                                 cidr: '192.168.1.0/24')}
        let(:tag) { instance_double(NSXT::Tag) }
        let(:ip_subnet) {instance_double(NSXT::IPSubnet)}
        let(:block_subnet_cidr) { '3232235776' }
        let(:gateway) { instance_double(NetAddr::CIDRv4, ip: '192.168.1.1') }

        it 'gets subnet from ip block' do
          expect(network_definition).to receive(:has_range?)
            .and_return(false)
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
          expect(router_provider).to receive(:attach_switch_to_t1)
            .with('logical-port-id', 't1-router-id', '192.168.1.1', 24)
          expect(NetAddr::CIDR).to receive(:create)
            .with('192.168.1.0/24').and_return(block_subnet_cidr)
          expect(NetAddr::CIDR).to receive(:create)
            .with(3232235777).and_return(gateway)

          expect(VSphereCloud::ManagedNetwork).to receive(:new)
            .with(logical_switch, '192.168.1.0/24', '192.168.1.1').and_return(network_result)
          expect(network.create(network_definition)).to eq(network_result)
        end
      end

      context 'when NSXT API returns an error' do
        context 'when failed to enable_route_advertisement' do
          it 'deletes created router' do
            expect(network_definition).to receive(:has_range?)
              .and_return(true)
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
            expect(network_definition).to receive(:has_range?)
              .and_return(true)
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
            expect(network_definition).to receive(:has_range?)
              .and_return(true)
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
               .with('zone-id', name: 'switch-name', tags: nil).and_return(logical_switch)
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
          let(:network_definition) { instance_double(VSphereCloud::NetworkDefinition,
                                                     netmask_bits: 24,
                                                     ip_block_id: 'block-id',
                                                     transport_zone_id: 'zone-id',
                                                     t0_router_id: t0_router_id,
                                                     switch_name: nil,
                                                     t1_name: nil) }

          let(:cloud_props) { {
              't0_router_id' => t0_router_id,
              'transport_zone_id' => transport_zone_id,
              'ip_block_id' => 'block-id'
          } }
          let(:allocated_subnet) { instance_double(NSXT::IpBlockSubnet, id: 'subnet-id',
                                                   cidr: '192.168.1.0/24')}

          it 'releases subnet' do
            expect(network_definition).to receive(:has_range?)
              .and_return(false)
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
          expect(network_definition).to receive(:has_range?)
            .and_return(true)
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
      let(:logical_port) { instance_double(NSXT::LogicalPort, id: 12345) }
      let(:switch_ports) { [logical_port] }

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
          expect(switch_provider).to receive(:get_logical_port_status)
             .and_return("UP")
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
          expect(logical_port).to receive(:id)
             .and_return("12345")
          expect(switch_provider).to receive(:get_logical_port_status)
             .and_return("UP")
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
            }.to raise_error(NetworkDeletionError)
          end
        end

        context 'if more than 1 attached' do
          let(:switch_ports) { [logical_port, logical_port] }
          it 'raises an error' do
            expect(router_provider).to receive(:get_attached_router_ids)
              .with('switch-id').and_return(['t1-router-id'])
            expect(switch_provider).to receive(:get_attached_switch_ports)
              .with('switch-id').and_return(switch_ports)
            expect(switch_provider).to receive(:get_switch_by_id)
             .with('switch-id').and_return(logical_switch)

            expect(switch_provider).to receive(:get_logical_port_status)
             .twice.and_return("UP")
            expect{
              network.destroy('switch-id')
            }.to raise_error(NetworkDeletionError)
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
          expect(logical_port).to receive(:id)
             .and_return("12345")
          expect(switch_provider).to receive(:get_logical_port_status)
             .and_return("UP")
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
  end
end