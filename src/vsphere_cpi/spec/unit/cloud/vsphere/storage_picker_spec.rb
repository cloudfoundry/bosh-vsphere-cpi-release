require 'spec_helper'

module VSphereCloud
  describe StoragePicker, fake_logger: true do
    let(:global_ephemeral_pattern) { 'global-ephemeral-ds' }
    let(:global_persistent_pattern) { 'global-persistent-ds' }
    let(:datacenter) { double('Datacenter', ephemeral_pattern: global_ephemeral_pattern, persistent_pattern: global_persistent_pattern) }

    let(:datastore1) {double('Datastore', name: 'sp-1-ds-1')}
    let(:datastore2) {double('Datastore', name: 'sp-2-ds-1')}

    let(:sdrs_enabled_datastore_cluster1) { double('StoragePod', drs_enabled?: true, datastores: [datastore1], free_space: 20, name: 'sp2')}
    let(:sdrs_enabled_datastore_cluster2) { double('StoragePod', drs_enabled?: true, datastores: [datastore2], free_space: 120000, name: 'sp1')}
    let(:sdrs_disabled_datastore_cluster) { double('StoragePod', drs_enabled?: false, name: 'sp3')}


    describe '.choose_best_from' do
      let(:datastore) {double('Datastore', :free_space => 10)}
      let(:datastore_cluster) {double('StoragePod', :free_space => 100000)}
      let(:storage_objects) { [datastore, datastore_cluster]}

      it 'picks the best storage object based on free space' do
        expect(described_class.choose_best_from(storage_objects)).to eq(datastore_cluster)
      end
    end

    describe '.choose_persistent_pattern' do
      let(:disk_pool) { DiskPool.new(datacenter, []) }

      subject {  described_class.choose_persistent_pattern(disk_pool) }

      before do
        allow(disk_pool).to receive(:datastore_clusters).and_return(datastore_clusters)
        allow(disk_pool).to receive(:datastore_names).and_return(datastore_names)
      end

      context 'with datastore clusters' do
        context 'and sdrs enabled on some' do
          let(:datastore_clusters) { [sdrs_enabled_datastore_cluster1, sdrs_enabled_datastore_cluster2, sdrs_disabled_datastore_cluster] }
          context 'along with datastores' do
            let(:datastore_names) { ['ds-1', 'ds-2'] }
            it 'includes a pattern constructed from datastores and datastores from best sdrs enabled datastore cluster' do
              expect(subject).to eq('^(ds\-1|ds\-2|sp\-2\-ds\-1)$')
            end
          end

          context 'and no datastores' do
            let(:datastore_names) { [] }
            it 'includes the datastores from the best sdrs enabled datastore cluster' do
              expect(subject).to eq('^(sp\-2\-ds\-1)$')
            end
          end
        end

        context 'and sdrs disabled on all and no datastores' do
          let(:datastore_clusters) { [sdrs_disabled_datastore_cluster] }
          let(:datastore_names) { [] }
          it 'should be empty' do
            expect(subject).to eq('^()$')
          end
        end
      end

      context 'with no datastores and datastore_clusters' do
        let(:datastore_names) { [] }
        let(:datastore_clusters) { [] }
        it 'includes the global persistent pattern' do
          expect(subject).to eq(global_persistent_pattern)
        end
      end
    end

    describe '.choose_ephemeral_pattern' do
      let(:pbm) { instance_double(Pbm) }
      let(:vm_type) { VmType.new(datacenter, {}, pbm) }
      let(:global_config) {instance_double('VSphereCloud::Config', vm_storage_policy_name: global_storage_policy)}
      let(:global_storage_policy) { nil }
      let(:vm_type_storage_policy){ nil }
      let(:global_ephemeral_pattern) { nil }
      let(:datastore_clusters) { [] }
      let(:datastore_names) { [] }
      let(:compatible_datastores_vm_type) { [] }
      let(:global_compatible_datastores) { [] }


      subject {  described_class.choose_ephemeral_pattern(global_config, vm_type) }

      before do
        allow(vm_type).to receive(:datastore_clusters).and_return(datastore_clusters)
        allow(vm_type).to receive(:datastore_names).and_return(datastore_names)
        allow(vm_type).to receive(:storage_policy_name).and_return(vm_type_storage_policy)
        allow(vm_type).to receive(:storage_policy_datastores).with(global_storage_policy).and_return(
            global_compatible_datastores)
        allow(vm_type).to receive(:storage_policy_datastores).with(vm_type_storage_policy).and_return(
            compatible_datastores_vm_type)
        allow(vm_type).to receive_message_chain(:datacenter, :ephemeral_pattern).and_return(global_ephemeral_pattern)
        allow(global_config).to receive(:vm_storage_policy_name).and_return(global_storage_policy)
      end

      context 'with storage policy defined in vm_type' do
        context 'with datastore pattern(vm_type, global both) defined and global storage policy is also defined' do
          let(:global_ephemeral_pattern) { 'global-ds-0' }
          let(:datastore_clusters) { ['fake-1'] }
          let(:datastore_names) { ['ds-0', 'ds-1'] }
          let(:vm_type_storage_policy) {'Gold Policy'}
          let(:compatible_datastores_vm_type) { [ double('Datastore', name: 'ds-5'), double('Datastore', name: 'ds-6') ]}
          let(:compatible_pattern_vm_type) { '^(ds\-5|ds\-6)$' }
          let(:global_compatible_datastores) { [ double('Datastore', name: 'ds-7'), double('Datastore', name: 'ds-8') ]}
          let(:global_compatible_datastores_pattern) { '^(ds\-7|ds\-8)$' }
          let(:global_storage_policy) { 'Global Gold Policy' }

          it 'includes all the compatible datastores from vm_type storage policy' do
            expect(vm_type).to_not receive(:datastore_names)
            expect(vm_type).to_not receive(:datastore_clusters)
            expect(vm_type).to_not receive(:datacenter)
            expect(global_config).to_not receive(:vm_storage_policy_name)
            expect(vm_type).to receive(:storage_policy_datastores).with(
                vm_type_storage_policy).and_return(compatible_datastores_vm_type)
            expect(vm_type).to receive(:storage_policy_name).exactly(4).times
            expect(subject).to eq([compatible_pattern_vm_type, vm_type_storage_policy])

          end
        end
      end

      context 'with NO storage policy defined in vm_type' do
        let(:vm_type_storage_policy) { nil }
        context 'with datastore entities/pattern(vm_type, global both) defined and global storage policy is also defined' do
          let(:global_ephemeral_pattern) { 'global-ds-0' }
          let(:global_compatible_datastores) { [ double('Datastore', name: 'ds-7'), double('Datastore', name: 'ds-8') ]}
          let(:global_compatible_datastores_pattern) { '^(ds\-7|ds\-8)$' }
          let(:global_storage_policy) { 'Global Gold Policy' }
          context 'with datastore clusters' do
            context 'and sdrs enabled on some' do
              let(:datastore_clusters) { [sdrs_enabled_datastore_cluster1, sdrs_enabled_datastore_cluster2, sdrs_disabled_datastore_cluster] }
              context 'along with datastores' do
                let(:datastore_names) { ['ds-1', 'ds-2'] }
                it 'includes a pattern constructed from datastores and datastores from all sdrs enabled datastore cluster' do
                  expect(vm_type).to receive(:storage_policy_name).once
                  expect(vm_type).to receive(:datastore_names).once
                  expect(vm_type).to receive(:datastore_clusters).twice
                  expect(vm_type).to_not receive(:datacenter)
                  expect(global_config).to_not receive(:vm_storage_policy_name)
                  expect(vm_type).to_not receive(:storage_policy_datastores)
                  expect(subject).to eq(['^(ds\-1|ds\-2|sp\-1\-ds\-1|sp\-2\-ds\-1)$', nil])
                end
              end

              context 'and no datastores' do
                let(:datastore_names) { [] }
                it 'includes the datastores from all sdrs enabled datastore cluster' do
                  expect(vm_type).to receive(:storage_policy_name).once
                  expect(vm_type).to receive(:datastore_names).once
                  expect(vm_type).to receive(:datastore_clusters).twice
                  expect(vm_type).to_not receive(:datacenter)
                  expect(global_config).to_not receive(:vm_storage_policy_name)
                  expect(vm_type).to_not receive(:storage_policy_datastores)
                  expect(subject).to eq(['^(sp\-1\-ds\-1|sp\-2\-ds\-1)$', nil])
                end
              end
            end
            context 'and sdrs disabled on all and no datastores' do
              let(:datastore_clusters) { [sdrs_disabled_datastore_cluster] }
              let(:datastore_names) { [] }
              it 'should be empty' do
                expect(vm_type).to receive(:storage_policy_name).once
                expect(vm_type).to receive(:datastore_names).once
                expect(vm_type).to receive(:datastore_clusters).thrice
                expect(vm_type).to_not receive(:datacenter)
                expect(global_config).to_not receive(:vm_storage_policy_name)
                expect(vm_type).to_not receive(:storage_policy_datastores)
                expect(subject).to eq(['^()$', nil])
              end
            end
          end
        end
        context 'with NO datastore entities defined in vm_type' do
          let(:datastore_names) { [] }
          let(:datastore_clusters) { [] }
          context 'with Global Storage Policy and global datastore pattern is defined' do
            let(:global_ephemeral_pattern) { 'global-ds-0' }
            let(:global_compatible_datastores) { [ double('Datastore', name: 'ds-7'), double('Datastore', name: 'ds-8') ]}
            let(:global_compatible_datastores_pattern) { '^(ds\-7|ds\-8)$' }
            let(:global_storage_policy) { 'Global Gold Policy' }
            it 'includes all compatible datastores from global storage policy' do
              expect(vm_type).to_not receive(:datacenter)
              expect(vm_type).to receive(:storage_policy_name).once
              expect(vm_type).to receive(:datastore_names).once
              expect(global_config).to receive(:vm_storage_policy_name).thrice
              expect(vm_type).to receive(:storage_policy_datastores).with(
                  global_storage_policy).and_return(global_compatible_datastores)
              pattern, policy = subject
              expect(pattern).to eq(global_compatible_datastores_pattern)
              expect(policy).to eq(global_storage_policy)
            end
          end
          context 'with NO Global Storage Policy' do
            let(:global_ephemeral_pattern) { 'global-ds-0' }
            let(:global_storage_policy) { nil }
            it 'includes all compatible datastores from global ephemeral pattern' do
              expect(vm_type).to receive(:datacenter).twice
              expect(vm_type).to receive(:storage_policy_name).once
              expect(vm_type).to receive(:datastore_names).once
              expect(global_config).to receive(:vm_storage_policy_name).once
              expect(vm_type).to_not receive(:storage_policy_datastores)
              expect(subject).to eq([global_ephemeral_pattern, nil])
            end
          end
        end
      end
    end

    describe '.choose_ephemeral_storage' do
      let(:target_datastore_name) { 'ds-1' }
      let(:accessible_datastores) { { target_datastore_name => datastore1} }
      let(:datastore1) {double('Datastore', name: 'sp-1-ds-1')}
      let(:pbm) { instance_double(Pbm) }
      let(:vm_type) { VmType.new(datacenter, {}, pbm) }

      context 'with datastore clusters' do
        before do
          allow(vm_type).to receive(:datastore_clusters).and_return(datastore_clusters)
        end

        context 'and sdrs enabled on some' do
          let(:datastore_clusters) { [sdrs_enabled_datastore_cluster1, sdrs_enabled_datastore_cluster2, sdrs_disabled_datastore_cluster] }
          context 'along with datastores' do
            it 'considers all sdrs enabled datastore cluster' do
              expected_storage_options = [datastore1, sdrs_enabled_datastore_cluster1, sdrs_enabled_datastore_cluster2]
              expect(described_class).to receive(:choose_best_from).with(expected_storage_options)
              described_class.choose_ephemeral_storage(target_datastore_name, accessible_datastores, vm_type)
            end

            it 'should not include nil datastore for unmatched target_datastore_pattern from accessibe_datastores' do
              expected_storage_options = [sdrs_enabled_datastore_cluster1, sdrs_enabled_datastore_cluster2]
              expect(described_class).to receive(:choose_best_from).with(expected_storage_options)
              described_class.choose_ephemeral_storage(target_datastore_name, {}, vm_type)
            end
          end
        end

        context 'and sdrs disabled on all' do
          let(:datastore_clusters) { [sdrs_disabled_datastore_cluster] }
          it 'should not consider any datastore cluster' do
            expect(described_class).to receive(:choose_best_from).with([datastore1])
            described_class.choose_ephemeral_storage(target_datastore_name, accessible_datastores, vm_type)
          end
        end
      end
    end
  end
end
