require 'digest'
require 'spec_helper'

describe VSphereCloud::NSXTSwitchProvider, fake_logger: true do
  let(:switch_api) { instance_double(NSXT::LogicalSwitchingApi) }
  let(:client) { instance_double(NSXT::ApiClient) }
  subject(:switch_provider) do
    described_class.new(client)
  end

  before do
    allow(switch_provider).to receive(:switch_api).and_return(switch_api)
  end
  
  describe '#create_logical_switch' do
    let(:logical_switch) { instance_double(NSXT::LogicalSwitch) }

    context 'when switch name is provided' do
      it 'creates switch with given name' do
        expect(NSXT::LogicalSwitch).to receive(:new)
         .with({ admin_state: 'UP',
                 transport_zone_id: 'zone_id',
                 replication_mode: 'MTEP',
                 display_name: 'Switch name'})
         .and_return(logical_switch)
        expect(switch_api).to receive(:create_logical_switch)
         .with(logical_switch)
        switch_provider.create_logical_switch('zone_id', {name: 'Switch name'})
      end
    end

    context 'when switch name and tags are empty' do
      it 'creates a switch' do
        expect(NSXT::LogicalSwitch).to receive(:new)
         .with({ admin_state: 'UP',
                 transport_zone_id: 'zone_id',
                 replication_mode: 'MTEP'})
         .and_return(logical_switch)
        expect(switch_api).to receive(:create_logical_switch)
         .with(logical_switch)
        switch_provider.create_logical_switch('zone_id', {name: nil, tags: nil})
      end
    end

    context 'when no optional params are provided' do
      it 'creates a switch' do
        expect(NSXT::LogicalSwitch).to receive(:new)
         .with({ admin_state: 'UP',
                 transport_zone_id: 'zone_id',
                 replication_mode: 'MTEP'})
         .and_return(logical_switch)
        expect(switch_api).to receive(:create_logical_switch)
          .with(logical_switch)
        switch_provider.create_logical_switch('zone_id')
      end
    end

    context 'when tags are provided' do
      let(:tag) { instance_double(NSXT::Tag) }

      it 'creates switch with tags' do
        expect(NSXT::LogicalSwitch).to receive(:new)
         .with({ admin_state: 'UP',
                 transport_zone_id: 'zone_id',
                 replication_mode: 'MTEP',
                 tags: [tag] })
         .and_return(logical_switch)
        expect(switch_api).to receive(:create_logical_switch)
          .with(logical_switch)
        switch_provider.create_logical_switch('zone_id',
                                              {tags: [ tag ]})
      end
    end
  end

  describe '#delete_logical_switch' do
    it 'deletes logical switch with force and cascade' do
      expect(switch_api).to receive(:delete_logical_switch)
                                .with('switch-id', cascade: true, detach: true)
      switch_provider.delete_logical_switch('switch-id')
    end
  end

  describe '#get_attached_switch_ports' do
    context 'when switch id is provided' do
      let(:switch_port) { instance_double(NSXT::LogicalPort) }
      let(:switch_ports) { instance_double(NSXT::LogicalPortListResult,
                                           results: [switch_port]) }

      it 'returns switch ports' do
        expect(switch_api).to receive(:list_logical_ports)
            .with(logical_switch_id: 'switch-id').and_return(switch_ports)
        result = switch_provider.get_attached_switch_ports('switch-id')
        expect(result.length).to eq(1)
      end
    end
  end

  describe '#get_switches_by_name' do
    let(:results) { [
        instance_double(NSXT::LogicalSwitch, id: '1', display_name: 'switch'),
        instance_double(NSXT::LogicalSwitch, id: '2', display_name: 'switch2'),
        instance_double(NSXT::LogicalSwitch, id: '3', display_name: 'switch'),
    ]}
    let(:logical_switches) {
      instance_double(NSXT::LogicalSwitchListResult, results: results)
    }

    it 'returns switches with given name' do
      expect(switch_api).to receive(:list_logical_switches)
                                .and_return(logical_switches)
      switches = switch_provider.get_switches_by_name('switch')
      expect(switches.length).to eq(2)
      expect(switches.first.id).to eq('1')
      expect(switches.last.id).to eq('3')
    end
  end

  describe '#create_logical_port' do
    let(:logical_port_obj) { instance_double(NSXT::LogicalPort) }
    let(:created_logical_port) { instance_double(NSXT::LogicalPort)}

    context 'when switch id is valid' do
      it 'creates logical port' do
        expect(NSXT::LogicalPort).to receive(:new)
          .with({admin_state: 'UP',
                 logical_switch_id: 'switch-id'})
          .and_return(logical_port_obj)

        expect(switch_api).to receive(:create_logical_port)
          .with(logical_port_obj).and_return(created_logical_port)
        expect(switch_provider.create_logical_port('switch-id'))
            .to eq(created_logical_port)
      end
    end

    context 'when api returns an exception' do
      it 'raises an error with switch id' do
        expect(switch_api).to receive(:create_logical_port)
          .with(any_args).and_raise('Some IAAS exception')
        expect {
          switch_provider.create_logical_port('switch-id')
        }.to raise_error{ |error|
          expect(error.to_s).to match(/switch-id/)
        }
      end
    end
  end

  describe '#get_switch_by_id' do
    context 'when switch id is provided' do
      let(:switch) { instance_double(NSXT::LogicalSwitch)}
      it 'gets switch' do
        expect(switch_api).to receive(:get_logical_switch)
          .with('switch-id').and_return(switch)
        expect(switch_provider.get_switch_by_id('switch-id'))
            .to eq(switch)
      end
    end
  end
end