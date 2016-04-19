require 'spec_helper'
# require 'cloud/vsphere/vm_creator_builder'

module VSphereCloud
  describe VmCreatorBuilder do
    describe '#build' do
      let(:memory) { double('memory in mb') }
      let(:disk) { double('disk in mb') }
      let(:cpu) { double('number of cpus') }
      let(:vm_creator) { double('vm creator') }
      let(:drs_rules) { double('drs_rules') }
      let(:client) { double('client') }
      let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }
      let(:logger) { double('logger') }
      let(:cpi) { double('cpi') }
      let(:agent_env) { double('agent_env') }
      let(:file_provider) { double('file_provider') }
      let(:datacenter) { double('datacenter') }

      let(:cloud_properties) do
        {
          'ram' => memory,
          'disk' => disk,
          'cpu' => cpu,
        }
      end

      before do
        allow(class_double('VSphereCloud::VmCreator').as_stubbed_const).to receive(:new).and_return(vm_creator)
      end

      context 'when nested_hardware_virtualization is not specified' do
        it 'injects the memory size, disk size, number of cpu, cpu hot add enable, mem hot add enable, vsphere client, logger, drs rules and the cpi into the VmCreator instance' do
          expect(VSphereCloud::VmCreator).to receive(:new).with(
              memory,
              disk,
              cpu,
              false,
              false,
              false,
              drs_rules,
              client,
              cloud_searcher,
              logger,
              cpi,
              agent_env,
              file_provider,
              datacenter,
              nil
            )

          expect(
            subject.build(cloud_properties, client, cloud_searcher, logger, cpi, agent_env, file_provider, datacenter, nil, drs_rules)
          ).to eq(vm_creator)
        end
      end

      context 'when nested_hardware_virtualization is customized' do
        before do
          cloud_properties['nested_hardware_virtualization'] = true
        end

        it 'uses the configured value' do
          expect(VSphereCloud::VmCreator).to receive(:new).with(
              memory,
              disk,
              cpu,
              false,
              false,
              true,
              drs_rules,
              client,
              cloud_searcher,
              logger,
              cpi,
              agent_env,
              file_provider,
              datacenter,
              nil
            )

          expect(
            subject.build(cloud_properties, client, cloud_searcher, logger, cpi, agent_env, file_provider, datacenter, nil, drs_rules)
          ).to eq(vm_creator)
        end
      end
    end
  end
end
