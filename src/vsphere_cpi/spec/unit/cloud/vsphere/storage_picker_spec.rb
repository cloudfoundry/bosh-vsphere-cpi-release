require 'spec_helper'

module VSphereCloud
  describe StoragePicker do

    describe '.choose_best_from' do
      let(:datastore) {double('Datastore', :free_space => 10)}
      let(:datastore_cluster) {double('StoragePod', :free_space => 100000)}
      let(:storage_objects) { [datastore, datastore_cluster]}

      it 'picks the best storage object based on free space' do
        expect(described_class.choose_best_from(storage_objects)).to eq(datastore_cluster)
      end
    end

    describe '.choose_persistent_pattern' do
      let(:fake_logger) { instance_double('Logger', info: nil) }
      let(:global_datastore_pattern) { 'global-persistent-ds' }
      let(:datacenter) { double('Datacenter', persistent_pattern: global_datastore_pattern)}
      let(:disk_pool) { DiskPool.new(datacenter, 'eagerZeroedThick', datastores) }
      let(:datastore_clusters) { [{ 'sp-1' => {} }, { 'sp-2' => {} }, { 'sp-3' => {} }] }

      let(:datastore1) {double('Datastore', name: 'sp-1-ds-1')}
      let(:datastore2) {double('Datastore', name: 'sp-2-ds-1')}
      let(:sdrs_enabled_datastore_cluster1) { double('StoragePod', drs_enabled?: true, datastores: [datastore1], free_space: 20)}
      let(:sdrs_enabled_datastore_cluster2) { double('StoragePod', drs_enabled?: true, datastores: [datastore2], free_space: 120000)}
      let(:sdrs_disabled_datastore_cluster) { double('StoragePod', drs_enabled?: false)}

      context 'datastore clusters' do
        context 'with sdrs enabled on some' do
          before do
            allow(disk_pool).to receive(:datastore_clusters).and_return([sdrs_enabled_datastore_cluster1, sdrs_enabled_datastore_cluster2, sdrs_disabled_datastore_cluster])
          end
          context 'along with datastores' do
            let(:datastores) { ['ds-1', 'ds-2', 'clusters' => datastore_clusters] }

            it 'includes a pattern constructed from datastores and datastores from best sdrs enabled datastore cluster' do
              persistent_pattern = described_class.choose_persistent_pattern(disk_pool, fake_logger)
              expect(persistent_pattern).to eq('^(ds\-1|ds\-2|sp\-2\-ds\-1)$')
            end
          end
          context 'and no datastores are specified' do
            let(:datastores) { ['clusters' => datastore_clusters] }

            it 'includes the datastores from the best sdrs enabled datastore cluster' do
              persistent_pattern = described_class.choose_persistent_pattern(disk_pool, fake_logger)
              expect(persistent_pattern).to eq('^(sp\-2\-ds\-1)$')
            end
          end
        end
        context 'with sdrs disabled on all' do
          let(:datastores) { ['clusters' => [{ 'sp-3' => {} }] ] }

          before do
            allow(disk_pool).to receive(:datastore_clusters).and_return([sdrs_disabled_datastore_cluster])
          end
          it 'should be empty when there are no sdrs enabled datastore cluster' do
            persistent_pattern = described_class.choose_persistent_pattern(disk_pool, fake_logger)
            expect(persistent_pattern).to eq('^()$')
          end
        end
      end
      context 'with no datastores' do
        let(:datastores) { [] }

        it 'includes the global persistent pattern' do
          persistent_pattern = described_class.choose_persistent_pattern(disk_pool, fake_logger)
          expect(persistent_pattern).to eq(global_datastore_pattern)
        end end
    end
  end
end
