require 'digest'
require 'spec_helper'

describe VSphereCloud::NSXTRouterProvider, fake_logger: true do
  let(:router_api) { instance_double(NSXT::LogicalRoutingAndServicesApi) }
  let(:client) { instance_double(NSXT::ApiClient) }
  subject(:router_provider) do
    described_class.new(client)
  end

  before do
    allow(router_provider).to receive(:router_api).and_return(router_api)
  end

  describe '#create_t1_router' do
    let(:router_name) { 'router-name' }
    let(:t1_router) { instance_double(NSXT::LogicalRouter,
                                      id: 't1-router-id',
                                      display_name: router_name ) }

    context 'when all params are correct' do
      it 'creates t1 logical router with given name' do
        expect(router_api).to receive(:create_logical_router)
          .with( { edge_cluster_id: 'edge-cluster',
                   router_type: 'TIER1',
                   display_name: 'router-name' } )
          .and_return(t1_router)
        result = router_provider.create_t1_router('edge-cluster', 'router-name')
        expect(result).not_to be_nil
        expect(result.id).not_to be_nil
        expect(result.display_name).to eq('router-name')
      end
    end

    context 'when display_name is empty' do
      let(:router_name) { nil }
      let(:random_name) { 'very random' }
      it 'randomly generates name' do
        expect(router_api).to receive(:create_logical_router)
                                  .with( { edge_cluster_id: 'edge-cluster',
                                           router_type: 'TIER1',
                                           display_name: nil } )
                                  .and_return(t1_router)
        result = router_provider.create_t1_router('edge-cluster', router_name)
        expect(result).not_to be_nil
      end
    end

    context 'when api call is failing' do
      it 'propogates an error' do
        expect(router_api).to receive(:create_logical_router)
                                  .with(any_args)
                                  .and_raise('NSXT API error')
        expect {
          router_provider.create_t1_router('c9c4d0b1-47f7-4975-bdfa-ba7bdfecea28')
        }.to raise_error('NSXT API error')
      end
    end
  end

  describe '#delete_t1_router' do
    it 'deletes router with force' do
      expect(router_api).to receive(:delete_logical_router)
                                .with('t1-router-id', :force => true)
      router_provider.delete_t1_router('t1-router-id')
    end
  end

  describe '#get_edge_cluster_id' do
    context 'when t0 router exists' do
      context 'when it has edge_cluster_id' do
        let(:t0_router) { instance_double(NSXT::LogicalRouter,
                                          :edge_cluster_id => 'edge-cluster-id') }
        it 'returns edge_cluster_id' do
          expect(router_api).to receive(:read_logical_router)
                                    .with('t0-router-id').and_return(t0_router)
          edge_cluster_id = router_provider.get_edge_cluster_id('t0-router-id')
          expect(edge_cluster_id).to eq('edge-cluster-id')
        end
      end
      context 'when it does not have edge_cluster_id' do
        let(:t0_router) { instance_double(NSXT::LogicalRouter,
                                          :edge_cluster_id => nil) }
        it 'raises an error' do
          expect(router_api).to receive(:read_logical_router)
                                    .with('t0-router-id').and_return(t0_router)
          expect{ router_provider.get_edge_cluster_id('t0-router-id') }
              .to raise_error(/Router t0-router-id does not have edge cluster id./)
        end
      end
    end
    context 'when rt0 router does not exist' do
      it 'raises an error' do
        expect(router_api).to receive(:read_logical_router)
                                  .with('t0-router-id').and_raise('T0 router not found')
        expect { router_provider.get_edge_cluster_id('t0-router-id') }
            .to raise_error('T0 router not found')
      end
    end
  end

  describe '#enable_route_advertisement' do
    let(:router_id) { 't1-router-id' }
    let(:advertisement_config) { instance_double(NSXT::AdvertisementConfig) }
    before do
      allow(NSXT::AdvertisementConfig).to receive(:new)
        .with({:advertise_nsx_connected_routes => true,
               :enabled => true})
        .and_return(advertisement_config)
    end

    context 'when route id is provided' do
      it 'enables route advertisement' do
        expect(router_api).to receive(:read_advertisement_config)
          .with('t1-router-id').and_return(advertisement_config)
        expect(advertisement_config).to receive(:advertise_nsx_connected_routes=)
          .with(true)
        expect(advertisement_config).to receive(:enabled=)
          .with(true)
        expect(router_api).to receive(:update_advertisement_config) do |router_id, ad_config|
          expect(router_id).to eq('t1-router-id')
          expect(ad_config).to eq(advertisement_config)
        end

        router_provider.enable_route_advertisement(router_id)
      end
    end
  end

  describe '#get_attached_router_ids' do
    let(:router_port) { instance_double(NSXT::LogicalRouterPort,
                                        :logical_router_id => 'router-id') }
    let(:router_ports) { instance_double(NSXT::LogicalRouterPortListResult,
                                         :results => [ router_port ]) }

    context 'when one router attached' do
      it 'returns array with one router id' do
        expect(router_api).to receive(:list_logical_router_ports)
                                  .with(:logical_switch_id => 'switch-id').and_return(router_ports)
        expect(router_provider.get_attached_router_ids('switch-id'))
            .to eq(['router-id'])
      end
    end

    context 'when multiple routers attached ' do
      let(:router_port2) { instance_double(NSXT::LogicalRouterPort,
                                           :logical_router_id => 'router-id2') }

      let(:router_ports) { instance_double(NSXT::LogicalRouterPortListResult,
                                           :results => [ router_port, router_port2 ]) }
      it 'returns all router ids' do
        expect(router_api).to receive(:list_logical_router_ports)
                                  .with(:logical_switch_id => 'switch-id').and_return(router_ports)
        expect(router_provider.get_attached_router_ids('switch-id'))
            .to eq(['router-id','router-id2'])
      end
    end

    context 'when no routers attached' do
      let(:router_ports) { instance_double(NSXT::LogicalRouterPortListResult,
                                           :results => [ ]) }
      it 'returns empty array' do
        expect(router_api).to receive(:list_logical_router_ports)
                                  .with(:logical_switch_id => 'switch-id').and_return(router_ports)
        expect(router_provider.get_attached_router_ids('switch-id'))
            .to eq([])
      end
    end
  end

  describe '#get_attached_switches_ids' do
    let(:switch_port_ref) { instance_double(NSXT::ResourceReference,
                                            :is_valid => true,
                                            :target_id => 'switch-id'
    ) }
    let(:invalid_switch_port_ref) { instance_double(NSXT::ResourceReference,
                                                    :is_valid => false
    ) }

    let(:router_port) { instance_double(NSXT::LogicalRouterDownLinkPort,
                                        :linked_logical_switch_port_id =>
                                            switch_port_ref) }
    let(:invalid_port) {  instance_double(NSXT::LogicalRouterDownLinkPort,
                                          :linked_logical_switch_port_id =>
                                              invalid_switch_port_ref) }
    let(:router_ports) { instance_double(NSXT::LogicalRouterPortListResult,
                                         :results => [ router_port, invalid_port ]) }

    context 'when router id is provided' do
      it 'returns attached switches ids with valid ports' do
        expect(router_api).to receive(:list_logical_router_ports)
                                  .with(:logical_router_id => 't1-router-id',:resource_type => 'LogicalRouterDownLinkPort')
                                  .and_return(router_ports)
        expect(router_provider.get_attached_switches_ids('t1-router-id'))
            .to eq(['switch-id'])
      end
    end
  end

  describe '#attach_t1_to_t0' do
    let(:t0_router_port) {
      instance_double(NSXT::LogicalRouterLinkPortOnTIER0,
                      :id => 't0_port_id').as_null_object
    }

    context 'when T0 router exists' do
      let(:t1_router_port) { instance_double(NSXT::LogicalRouterLinkPortOnTIER1) }
      let(:t0_reference) { instance_double(NSXT::ResourceReference) }

      context 'when T1 router exists' do
        it 'creates T1 logical router port and attaches it to T0' do
          expect(NSXT::LogicalRouterLinkPortOnTIER0).to receive(:new)
                                                            .with({:logical_router_id => 't0_router_id',
                                                                   :resource_type => 'LogicalRouterLinkPortOnTIER0'})
                                                            .and_return(t0_router_port)
          expect(router_api).to receive(:create_logical_router_port)
                                    .with(t0_router_port).and_return(t0_router_port)

          expect(NSXT::ResourceReference).to receive(:new)
                                                 .with({ :target_id => 't0_port_id',
                                                         :target_type => 'LogicalRouterLinkPortOnTIER0',
                                                         :is_valid => true })
                                                 .and_return(t0_reference)
          expect(NSXT::LogicalRouterLinkPortOnTIER1).to receive(:new)
                                                            .with({:logical_router_id => 't1_router_id',
                                                                   :linked_logical_router_port_id => t0_reference,
                                                                   :resource_type => 'LogicalRouterLinkPortOnTIER1'})
                                                            .and_return(t1_router_port)
          expect(router_api).to receive(:create_logical_router_port)
                                    .with(t1_router_port)
          router_provider.attach_t1_to_t0('t0_router_id', 't1_router_id')
        end
      end

      context 'when failing to create T1 port' do
        it 'throws error with T0 router port id and T1 router id' do
          expect(NSXT::LogicalRouterLinkPortOnTIER0).to receive(:new)
                                                            .with({:logical_router_id => 't0_router_id',
                                                                   :resource_type => 'LogicalRouterLinkPortOnTIER0'})
                                                            .and_return(t0_router_port)
          expect(router_api).to receive(:create_logical_router_port)
                                    .with(t0_router_port).and_return(t0_router_port)

          expect(NSXT::LogicalRouterLinkPortOnTIER1).to receive(:new)
                                                            .with(any_args).and_return(t1_router_port)

          expect(router_api).to receive(:create_logical_router_port)
                                    .with(t1_router_port).and_raise('CPI error without router id')
          expect {
            router_provider.attach_t1_to_t0('t0_router_id', 't1_router_id')
          }.to raise_error { |error|
            expect(error.to_s).to match /t0_port_id/
            expect(error.to_s).to match /t1_router_id/
          }
        end
      end
    end

    context 'when failing to create T0 router port' do
      it 'raises an error with T0 id' do
        expect(NSXT::LogicalRouterLinkPortOnTIER0).to receive(:new)
                                                          .with({:logical_router_id => 't0_router_id',
                                                                 :resource_type => 'LogicalRouterLinkPortOnTIER0'})
                                                          .and_return(t0_router_port)
        expect(router_api).to receive(:create_logical_router_port)
                                  .with(t0_router_port).and_raise('CPI error without router id')

        expect {
          router_provider.attach_t1_to_t0('t0_router_id', 't1_router_id')
        }.to raise_error { |error|
          expect(error.to_s).to match /t0_router_id/
        }
      end
    end
  end

  describe '#attach_switch_to_t1' do
    let(:subnet) { instance_double(NSXT::IPSubnet) }

    context 'when input is correct' do
      let(:logical_port) { instance_double(NSXT::LogicalPort, :id => 'logical-port-id') }
      let(:switch_port_ref) { instance_double(NSXT::ResourceReference) }

      it 'attaches switch to router ' do
        expect(NSXT::ResourceReference).to receive(:new)
         .with({:target_id => 'logical-port-id',
                :target_type => 'LogicalPort',
                :is_valid => true})
         .and_return(switch_port_ref)
        expect(NSXT::LogicalRouterDownLinkPort).to receive(:new)
         .with({ :logical_router_id => 't1-router-id',
                 :linked_logical_switch_port_id => switch_port_ref,
                 :resource_type => 'LogicalRouterDownLinkPort',
                 :subnets => [subnet]
               }).and_return(logical_port)
        expect(router_api).to receive(:create_logical_router_port)
          .with(logical_port)

        router_provider.attach_switch_to_t1('logical-port-id', 't1-router-id', subnet)
      end
    end

    context 'when api call fails' do
      it 'raises an error with switch port id and router ids' do
        expect(router_api).to receive(:create_logical_router_port)
          .with(any_args).and_raise('Some IAAS exception')
        expect {
          router_provider.attach_switch_to_t1('logical-port-id', 't1-router-id', subnet)
        }.to raise_error{ |error|
          expect(error.to_s).to match(/logical-port-id/)
          expect(error.to_s).to match(/t1-router-id/)
        }
      end
    end
  end

  describe '#detach_t1_from_t0' do
    context 'when t1 attached to t0' do
      let(:router_port_id) { instance_double(NSXT::ResourceReference,
                                  target_type: 'LogicalRouterLinkPortOnTIER0',
                                  target_id: 't0-router-port-id') }
      let(:t1_router_port) { instance_double(NSXT::LogicalRouterLinkPortOnTIER1, resource_type: 'LogicalRouterLinkPortOnTIER1',
                                               linked_logical_router_port_id: router_port_id) }
      let(:t1_router_ports) { instance_double(NSXT::LogicalRouterPortListResult,
                                              :results => [ t1_router_port ]) }
      it 'detaches it' do
        expect(router_api).to receive(:list_logical_router_ports)
          .with({logical_router_id: 't1-router-id'}).and_return(t1_router_ports)
        expect(router_api).to receive(:delete_logical_router_port)
          .with('t0-router-port-id', force: true)
        router_provider.detach_t1_from_t0('t1-router-id')
      end
    end

    context 'when T1 is not attached to T0' do
      let(:switch_port_id) { instance_double(NSXT::ResourceReference) }
      let(:t1_router_port) { instance_double(NSXT::LogicalRouterDownLinkPort, resource_type: 'LogicalRouterDownLinkPort',
                                             linked_logical_switch_port_id: switch_port_id) }
      let(:t1_router_ports) { instance_double(NSXT::LogicalRouterPortListResult,
                                              :results => [ t1_router_port ]) }

      it 'does nothing' do
        expect(router_api).to receive(:list_logical_router_ports)
          .with({logical_router_id: 't1-router-id'}).and_return(t1_router_ports)
        expect(router_api).not_to receive(:delete_logical_router_port)
          .with('t0-router-port-id', force: true)
        router_provider.detach_t1_from_t0('t1-router-id')
      end
    end
  end
end