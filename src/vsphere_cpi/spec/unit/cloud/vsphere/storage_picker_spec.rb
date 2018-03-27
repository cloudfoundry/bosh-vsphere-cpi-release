require 'spec_helper'

module VSphereCloud
  describe StoragePicker do
    let(:fake_logger) { instance_double('Logger', info: nil, debug: nil) }

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

      subject {  described_class.choose_persistent_pattern(disk_pool, fake_logger) }

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
      let(:vm_type) { VmType.new(datacenter, {}) }

      subject {  described_class.choose_ephemeral_pattern(vm_type, fake_logger) }

      before do
        allow(vm_type).to receive(:datastore_clusters).and_return(datastore_clusters)
        allow(vm_type).to receive(:datastore_names).and_return(datastore_names)
      end

      context 'with datastore clusters' do
        context 'and sdrs enabled on some' do
          let(:datastore_clusters) { [sdrs_enabled_datastore_cluster1, sdrs_enabled_datastore_cluster2, sdrs_disabled_datastore_cluster] }
          context 'along with datastores' do
            let(:datastore_names) { ['ds-1', 'ds-2'] }
            it 'includes a pattern constructed from datastores and datastores from all sdrs enabled datastore cluster' do
              expect(subject).to eq('^(ds\-1|ds\-2|sp\-1\-ds\-1|sp\-2\-ds\-1)$')
            end
          end

          context 'and no datastores' do
            let(:datastore_names) { [] }
            it 'includes the datastores from all sdrs enabled datastore cluster' do
              expect(subject).to eq('^(sp\-1\-ds\-1|sp\-2\-ds\-1)$')
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
        it 'includes the global ephemeral pattern' do
          expect(subject).to eq(global_ephemeral_pattern)
        end
      end
    end

    describe '.choose_ephemeral_storage' do
      let(:target_datastore_name) { 'ds-1' }
      let(:accessible_datastores) { { target_datastore_name => datastore1} }
      let(:datastore1) {double('Datastore', name: 'sp-1-ds-1')}
      let(:vm_type) { VmType.new(datacenter, {}) }

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
              described_class.choose_ephemeral_storage(target_datastore_name, accessible_datastores, vm_type, fake_logger)
            end

            it 'should not include nil datastore for unmatched target_datastore_pattern from accessibe_datastores' do
              expected_storage_options = [sdrs_enabled_datastore_cluster1, sdrs_enabled_datastore_cluster2]
              expect(described_class).to receive(:choose_best_from).with(expected_storage_options)
              described_class.choose_ephemeral_storage(target_datastore_name, {}, vm_type, fake_logger)
            end
          end
        end

        context 'and sdrs disabled on all' do
          let(:datastore_clusters) { [sdrs_disabled_datastore_cluster] }
          it 'should not consider any datastore cluster' do
            expect(described_class).to receive(:choose_best_from).with([datastore1])
            described_class.choose_ephemeral_storage(target_datastore_name, accessible_datastores, vm_type, fake_logger)
          end
        end
      end
    end
  end
end
