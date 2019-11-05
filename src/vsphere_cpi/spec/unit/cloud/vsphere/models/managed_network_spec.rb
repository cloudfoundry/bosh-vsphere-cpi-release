require 'spec_helper'

module VSphereCloud
  xdescribe ManagedNetwork, fake_logger: true do
    let(:logical_switch) { instance_double(NSXT::LogicalSwitch,
                                           :id => 'switch-id',
                                           :display_name => 'switch-name') }
    context 'when range and gateway are provided' do
      it 'deserializes to correct JSON with subnet' do
        result = VSphereCloud::ManagedNetwork.new(logical_switch, '192.168.1.0/24', '192.168.1.1')
        expect(JSON.dump(result)).to eq("[\"switch-id\",{\"range\":\"192.168.1.0/24\",\"gateway\":\"192.168.1.1\",\"reserved\":[]},{\"name\":\"switch-name\"}]")
      end
    end

    context 'when only switch is provided' do
      it 'deserializes to correct JSON without subnet' do
        result = VSphereCloud::ManagedNetwork.new(logical_switch)
        expect(JSON.dump(result)).to eq("[\"switch-id\",{},{\"name\":\"switch-name\"}]")
      end
    end
  end
end