require 'spec_helper'

module VSphereCloud
  describe StoragePicker, fake_logger: true do
    let(:global_ephemeral_pattern) { 'global-ephemeral-ds' }
    let(:global_persistent_pattern) { 'global-persistent-ds' }
    let(:datastore_folder) { instance_double('VSphereCloud::Resources::Folder') }
    let(:datacenter_mob) {instance_double('VimSdk::Vim::Datacenter') }
    let(:datacenter) do
      instance_double(Resources::Datacenter,
             ephemeral_pattern: global_ephemeral_pattern,
             ephemeral_datastore_cluster_pattern: ephemeral_cluster_pattern, # nil,
             persistent_pattern: global_persistent_pattern,
             persistent_datastore_cluster_pattern: persistent_cluster_pattern, # nil,
             mob: datacenter_mob,
      )
    end
    let(:ephemeral_cluster_pattern) { nil }
    let(:persistent_cluster_pattern) { nil }

    let(:datastore1) {double('Datastore', name: 'sp-1-ds-1')}
    let(:datastore2) {double('Datastore', name: 'sp-2-ds-1')}

    let(:sdrs_enabled_datastore_cluster1) { double('StoragePod', drs_enabled?: true, datastores: [datastore1], free_space: 20, name: 'sp1')}
    let(:sdrs_enabled_datastore_cluster2) { double('StoragePod', drs_enabled?: true, datastores: [datastore2], free_space: 120000, name: 'sp2')}
    let(:sdrs_disabled_datastore_cluster) { double('StoragePod', drs_enabled?: false, name: 'sp3')}

    describe '.choose_best_from' do
      let(:datastore) {double('Datastore', :free_space => 10)}
      let(:datastore_cluster) {double('StoragePod', :free_space => 100000)}
      let(:storage_objects) { [datastore, datastore_cluster]}

      it 'picks the best storage object based on free space' do
        expect(described_class.choose_best_from(storage_objects)).to eq(datastore_cluster)
      end
    end

    describe '.choose_existing_disk_pattern' do
      let(:disk_cid) { double('DirectorDiskCID') }
      subject { described_class.choose_existing_disk_pattern(disk_cid, datacenter)}

      context 'with an encoded pattern in the disk CID' do
        before do
          allow(disk_cid).to receive(:target_datastore_pattern).and_return('foo')
        end
        it 'returns the cid pattern' do
          expect(subject).to eq('foo')
        end
      end

      context 'with no encoded pattern in the disk CID' do
        before do
          allow(disk_cid).to receive(:target_datastore_pattern).and_return(nil)
        end

        context 'and no global cluster pattern' do
          it 'returns the cid pattern' do
            expect(subject).to eq(global_persistent_pattern)
          end
        end
      end
    end

    describe '.choose_persistent_pattern' do
      let(:disk_pool) { DiskPool.new(datacenter, []) }

      subject {  described_class.choose_persistent_pattern(disk_pool) }

      before do
        allow(disk_pool).to receive(:datastore_clusters).and_return(datastore_clusters)
        allow(disk_pool).to receive(:datastore_names).and_return(datastore_names)
        allow(Resources::StoragePod).to receive(:find_storage_pod).and_return(sdrs_enabled_datastore_cluster1)
      end

      context 'with datastore clusters' do
        before do
          allow(Resources::StoragePod).to receive(:search_storage_pods).and_return(datastore_clusters)
        end
        context 'and sdrs enabled on some' do
          let(:datastore_clusters) { [sdrs_enabled_datastore_cluster1, sdrs_enabled_datastore_cluster2, sdrs_disabled_datastore_cluster] }
          context 'along with datastores' do
            let(:datastore_names) { ['ds-1', 'ds-2'] }
            it 'includes a pattern constructed from datastores and datastores from best sdrs enabled datastore cluster' do
              expect(subject).to eq('^(ds\-1|ds\-2|sp\-2\-ds\-1)$')
            end

            it 'logs the datastores excluded because they do not have drs' do
              expect(logger).to receive(:debug).with("Datastore Clusters excluded because they do not have DRS enabled: [sp3]")
              subject
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
        let(:global_datastore_clusters) { [sdrs_enabled_datastore_cluster1, sdrs_enabled_datastore_cluster2, sdrs_disabled_datastore_cluster] }
        before do
          allow(Resources::StoragePod).to receive(:search_storage_pods).and_return(global_datastore_clusters)
        end

        it 'includes the global persistent pattern' do
          expect(subject).to eq(global_persistent_pattern)
        end

        context 'with global persistent cluster pattern defined' do
          let(:persistent_cluster_pattern) { 'sp.' }
          it 'includes a pattern constructed from datastores from all SDRS-enabled global persistent datastore cluster and the global persistent pattern' do
            expect(subject).to eq('^(sp\-1\-ds\-1|sp\-2\-ds\-1)$|global-persistent-ds')
          end

          it 'logs the datastores excluded because they do not have drs' do
            expect(logger).to receive(:debug).with("Datastore Clusters excluded because they do not have DRS enabled: [sp3]")
            subject
          end

          context 'and no global persistent pattern' do
            let(:global_persistent_pattern) { nil }
            it 'returns a pattern with only the cluster datastores' do
              expect(subject).to eq('^(sp\-1\-ds\-1|sp\-2\-ds\-1)$')
            end
          end
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
                  expect(vm_type).to receive(:datastore_clusters).thrice
                  expect(vm_type).to_not receive(:datacenter)
                  expect(global_config).to_not receive(:vm_storage_policy_name)
                  expect(vm_type).to_not receive(:storage_policy_datastores)
                  expect(subject).to eq(['^(ds\-1|ds\-2|sp\-1\-ds\-1|sp\-2\-ds\-1)$', nil])
                end

                it 'logs the datastores excluded because they do not have drs' do
                  expect(logger).to receive(:debug).with("Datastore Clusters excluded because they do not have DRS enabled: [sp3]")
                  subject
                end
              end

              context 'and no datastores' do
                let(:datastore_names) { [] }
                it 'includes the datastores from all sdrs enabled datastore cluster' do
                  expect(vm_type).to receive(:storage_policy_name).once
                  expect(vm_type).to receive(:datastore_names).once
                  expect(vm_type).to receive(:datastore_clusters).thrice
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
                expect(vm_type).to receive(:datastore_clusters).exactly(4).times
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
            before do
              allow(vm_type).to receive(:datacenter).and_return(datacenter)
            end
            it 'includes all compatible datastores from global ephemeral pattern' do
              expect(vm_type).to receive(:storage_policy_name).once
              expect(vm_type).to receive(:datastore_names).once
              expect(global_config).to receive(:vm_storage_policy_name).once
              expect(vm_type).to_not receive(:storage_policy_datastores)
              expect(subject).to eq([global_ephemeral_pattern, nil])
            end
            context 'and a global ephemeral datastore cluster pattern is defined' do
              let(:global_datastore_clusters) { [sdrs_enabled_datastore_cluster1, sdrs_enabled_datastore_cluster2, sdrs_disabled_datastore_cluster] }
              let(:ephemeral_cluster_pattern) { 'sp*' }
              before do
                allow(Resources::StoragePod).to receive(:search_storage_pods).and_return(global_datastore_clusters)
              end
              it 'includes all compatible datastores from global ephemeral datastore cluster pattern' do
                expect(subject).to eq(['^(sp\-1\-ds\-1|sp\-2\-ds\-1)$|global-ds-0', nil])
              end
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

      it 'should return the previously selected datastore' do
        expect(described_class.choose_ephemeral_storage(target_datastore_name, accessible_datastores)).to eq(datastore1)
      end
    end
  end
end
