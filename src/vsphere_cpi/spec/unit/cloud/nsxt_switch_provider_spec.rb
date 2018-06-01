require 'digest'
require 'spec_helper'

describe VSphereCloud::NSXTSwitchProvider, fake_logger: true do
  let(:nsxt_config) { VSphereCloud::NSXTConfig.new('fake-host', 'fake-username', 'fake-password') }
  let(:client) { instance_double(NSXT::ApiClient) }
  subject(:switch_provider) do
    described_class.new(client)
  end
  
  describe '#create_logical_switch' do
    let(:switch_api) { instance_double(NSXT::LogicalSwitchingApi) }
    let(:logical_switch) { instance_double(NSXT::LogicalSwitch) }
    before do
      allow(switch_provider).to receive(:switch_api).and_return(switch_api)
    end
    context 'when transport zone id is provided' do
      it 'creates switch' do
        expect(NSXT::LogicalSwitch).to receive(:new)
                                           .with({ :admin_state => 'UP',
                                                   :transport_zone_id => 'zone_id',
                                                   :replication_mode => 'MTEP',
                                                   :display_name => 'Switch name'})
                                           .and_return(logical_switch)
        expect(switch_api).to receive(:create_logical_switch)
                                  .with(logical_switch)
        switch_provider.create_logical_switch('zone_id', 'Switch name')
      end
    end

    context 'when switch name is empty' do
      it 'Does not fail' do
        expect(NSXT::LogicalSwitch).to receive(:new)
                                           .with({ :admin_state => 'UP',
                                                   :transport_zone_id => 'zone_id',
                                                   :replication_mode => 'MTEP',
                                                   :display_name => nil})
                                           .and_return(logical_switch)
        expect(switch_api).to receive(:create_logical_switch)
                                  .with(logical_switch)
        switch_provider.create_logical_switch('zone_id')
      end
    end
  end

  describe '#delete_logical_switch' do
    let(:switch_api) { instance_double(NSXT::LogicalSwitchingApi) }
    before do
      allow(switch_provider).to receive(:switch_api).and_return(switch_api)
    end

    it 'deletes logical switch with force and cascade' do
      expect(switch_api).to receive(:delete_logical_switch)
                                .with('switch-id', :cascade => true, :detach => true)
      switch_provider.delete_logical_switch('switch-id')
    end
  end

  describe '#get_attached_switch_ports' do
    let(:switch_api) { instance_double(NSXT::LogicalSwitchingApi)}
    before do
      allow(switch_provider).to receive(:switch_api).and_return(switch_api)
    end

    context 'when switch id is provided' do
      let(:switch_port) { instance_double(NSXT::LogicalPort) }
      let(:switch_ports) { instance_double(NSXT::LogicalPortListResult,
                                           :results => [switch_port]) }

      it 'returns switch ports' do
        expect(switch_api).to receive(:list_logical_ports)
                                  .with(:logical_switch_id => 'switch-id').and_return(switch_ports)
        result = switch_provider.get_attached_switch_ports('switch-id')
        expect(result.length).to eq(1)
      end
    end
  end

  describe '#get_switches_by_name' do
    let(:switch_api) { instance_double(NSXT::LogicalSwitchingApi) }
    let(:results) { [
        instance_double(NSXT::LogicalSwitch, :id => '1', :display_name => 'switch'),
        instance_double(NSXT::LogicalSwitch, :id => '2', :display_name => 'switch2'),
        instance_double(NSXT::LogicalSwitch, :id => '3', :display_name => 'switch'),
    ]}
    let(:logical_switches) {
      instance_double(NSXT::LogicalSwitchListResult, :results => results)
    }
    before do
      allow(switch_provider).to receive(:switch_api).and_return(switch_api)
    end
    it 'returns switches with given name' do
      expect(switch_api).to receive(:list_logical_switches)
                                .and_return(logical_switches)
      switches = switch_provider.get_switches_by_name('switch')
      expect(switches.length).to eq(2)
      expect(switches.first.id).to eq('1')
      expect(switches.last.id).to eq('3')
    end
  end
end