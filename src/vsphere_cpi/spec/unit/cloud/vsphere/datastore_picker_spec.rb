require 'spec_helper'

module VSphereCloud
  describe DatastorePicker do
    before do
      allow(Random).to receive(:rand).and_return(1)
    end

    describe '#best_disk_placement' do
      context 'when a single DS is available' do
        before do
          allow(ds_1_mob).to receive_message_chain('summary.maintenance_mode').and_return(maintenance_mode)
        end
        let(:maintenance_mode) { "normal" }
        let(:ds_1_mob) { instance_double(VimSdk::Vim::Datastore) }
        let(:ds_1) { instance_double(VSphereCloud::Resources::Datastore, free_space: 1024, mob: ds_1_mob) }
        let(:available_datastores) do
         {
           'ds-1' => ds_1,
         }
        end
        let(:already_placed_disk) do
          instance_double(VSphereCloud::DiskConfig,
            size: 256,
            existing_datastore_name: 'ds-1',
            target_datastore_pattern: '.*',
          )
        end
        let(:moved_disk) do
          instance_double(VSphereCloud::DiskConfig,
            size: 512,
            existing_datastore_name: nil,
            target_datastore_pattern: '.*',
          )
        end
        context 'when datastore is in maintenance mode' do
          let(:maintenance_mode) { "inMaintenance" }
          it 'returns no valid placement' do
            picker = DatastorePicker.new(0)
            picker.update(available_datastores)
            disks = [already_placed_disk, moved_disk]

            expect {
              picker.best_disk_placement(disks)
            }.to raise_error(/Datastores matching criteria are in maintenance mode or not accessible/)
          end
        end
        context 'when datastore is not in maintenance mode' do
          let(:maintenance_mode) { "normal" }
          it 'returns the only valid placement' do
            picker = DatastorePicker.new(0)
            picker.update(available_datastores)
            disks = [already_placed_disk, moved_disk]

            expect(picker.best_disk_placement(disks)).to include({
              datastores: {
                'ds-1' => {
                  free_space: 1024 - 512,
                  disks: disks,
                  mob: ds_1_mob
                }
              }
            })
          end
        end
        context 'when no datastore can contain the disk' do
          let(:large_disk) do
            instance_double(VSphereCloud::DiskConfig,
              size: 999999,
              existing_datastore_name: nil,
              target_datastore_pattern: '.*',
            )
          end

          it 'raises an error' do
            picker = DatastorePicker.new(0)
            picker.update(available_datastores)
            disks = [large_disk]

            expect{
              picker.best_disk_placement(disks)
            }.to raise_error Bosh::Clouds::CloudError, /No valid placement/
          end
        end
        context 'when no target datastore pattern matches an available datastore' do
          let(:regular_disk) do
            instance_double(VSphereCloud::DiskConfig,
              size: 256,
              existing_datastore_name: nil,
              target_datastore_pattern: 'bad-pattern',
            )
          end

          it 'raises an error' do
            picker = DatastorePicker.new(0)
            picker.update(available_datastores)
            disks = [regular_disk]

            expect{
              picker.best_disk_placement(disks)
            }.to raise_error Bosh::Clouds::CloudError, /No valid placement/
          end
        end
      end

      context 'when multiple DSes are available' do
        before do
          allow(ds_1_mob).to receive_message_chain('summary.maintenance_mode').and_return(maintenance_mode)
        end
        let(:maintenance_mode) { "normal" }
        let(:ds_1_mob) { instance_double(VimSdk::Vim::Datastore) }
        let(:ds_1) { instance_double(VSphereCloud::Resources::Datastore, free_space: 512, mob: ds_1_mob) }
        let(:ds_2) { instance_double(VSphereCloud::Resources::Datastore, free_space: 1024, mob: ds_1_mob) }
        let(:available_datastores) do
         {
           'ds-1' => ds_1,
           'ds-2' => ds_2,
         }
        end
        let(:disk1) do
          instance_double(VSphereCloud::DiskConfig,
            size: 256,
            target_datastore_pattern: 'ds-2',
            existing_datastore_name: nil
          )
        end
        let(:disk2) do
          instance_double(VSphereCloud::DiskConfig,
            size: 512,
            target_datastore_pattern: '.*',
            existing_datastore_name: nil
          )
        end

        let(:picker) { DatastorePicker.new(0) }

        it 'places the disks into the datastores' do
          picker.update(available_datastores)

          disks = [disk1, disk2]
          expect(picker.best_disk_placement(disks)[:datastores]).to include({
            'ds-2' => {
              free_space: 256,
              disks: [disk1, disk2],
              mob: ds_1_mob
            },
          })
        end

        context 'when headroom is not specified' do
          let(:ds_1) { instance_double(VSphereCloud::Resources::Datastore, free_space: 1536, mob: ds_1_mob) }
          let(:ds_2) { instance_double(VSphereCloud::Resources::Datastore, free_space: 2048, mob: ds_1_mob) }
          let(:available_datastores) do
           {
             'ds-1' => ds_1,
             'ds-2' => ds_2,
           }
          end
          let(:disk1) do
            instance_double(VSphereCloud::DiskConfig,
              size: 256,
              target_datastore_pattern: 'ds-2',
              existing_datastore_name: nil
            )
          end
          let(:disk2) do
            instance_double(VSphereCloud::DiskConfig,
              size: 512,
              target_datastore_pattern: '.*',
              existing_datastore_name: nil
            )
          end

          it 'defaults headroom to 1024' do
            picker = DatastorePicker.new
            picker.update(available_datastores)

            disks = [disk1, disk2]
            expect(picker.best_disk_placement(disks)[:datastores]).to include(
              {
                'ds-1' => {
                  free_space: 0,
                  disks: [disk2],
                  mob: ds_1_mob
                },
                'ds-2' => {
                  free_space: 768,
                  disks: [disk1],
                  mob: ds_1_mob
                },
              }
            )
          end
        end

        context 'when headroom is specified' do
          let(:headroom) { 512}
          let(:ds_1) { instance_double(VSphereCloud::Resources::Datastore, free_space: 1536, mob: ds_1_mob) }
          let(:ds_2) { instance_double(VSphereCloud::Resources::Datastore, free_space: 1536, mob: ds_1_mob) }
          let(:available_datastores) do
           {
             'ds-1' => ds_1,
             'ds-2' => ds_2,
           }
          end
          let(:disk1) do
            instance_double(VSphereCloud::DiskConfig,
              size: 256,
              target_datastore_pattern: 'ds-2',
              existing_datastore_name: nil
            )
          end
          let(:disk2) do
            instance_double(VSphereCloud::DiskConfig,
              size: 512,
              target_datastore_pattern: '.*',
              existing_datastore_name: nil
            )
          end

          it 'accounts for additional headroom' do
            picker = DatastorePicker.new(headroom)
            picker.update(available_datastores)

            disks = [disk1, disk2]
            placements = picker.best_disk_placement(disks)
            expect(placements[:datastores].size).to eql(2)
            expect(placements[:datastores]['ds-1'][:disks].first).to_not eql(placements[:datastores]['ds-2'][:disks].first)
          end
        end

        context 'when given existing_datastore_name' do
          let(:disk1) do
            instance_double(VSphereCloud::DiskConfig,
              size: 256,
              existing_datastore_name: 'ds-2',
              target_datastore_pattern: '.*',
            )
          end
          let(:disk2) do
            instance_double(VSphereCloud::DiskConfig,
              size: 512,
              target_datastore_pattern: '.*',
              existing_datastore_name: nil
            )
          end

          it 'keeps the disk in its existing datastore to minimize disk migrations' do
            picker = DatastorePicker.new(0)
            picker.update(available_datastores)
            disks = [disk1, disk2]
            expect(picker.best_disk_placement(disks)[:datastores]).to include({
              'ds-2' => {
                free_space: 512,
                disks: [disk1, disk2],
                mob: ds_1_mob
              },
            })
          end
        end

        context 'when given existing_datastore_name that is not available' do
          let(:disk1) do
            instance_double(VSphereCloud::DiskConfig,
              size: 256,
              existing_datastore_name: 'non-available-ds',
              target_datastore_pattern: '.*',
            )
          end

          let(:available_datastores) { {'ds-1' => ds_1} }

          it 'places the disk in an available datastore and includes the migration size' do
            picker = DatastorePicker.new(0)
            picker.update(available_datastores)

            disks = [disk1]

            expect(picker.best_disk_placement(disks)).to include({
              migration_size: 256,
              datastores: {
                'ds-1' => {
                  disks: [disk1],
                  free_space: 256,
                  mob: ds_1_mob
                }
              }
            })
          end
        end

        describe ':balance_score' do
          it 'is calculated from (min + mean + median) free disk space, to balance things nicely' do
            [
              { datastore_space: [5,    5,    5],   balance_score: 15 },
              { datastore_space: [2000, 1,    1],   balance_score: 669 },
              { datastore_space: [100,  1000, 200], balance_score: 733 },
              { datastore_space: [500,  500,  400], balance_score: 1366 },
              { datastore_space: [700,  700],       balance_score: 2100 },
            ].each do |input|
              available_datastores = input[:datastore_space].each_with_index.map do |free_space, index|
                [ "ds-#{index}", instance_double(VSphereCloud::Resources::Datastore, free_space: free_space, mob: ds_1_mob) ]
              end.to_h

              disks = input[:datastore_space].each_with_index.map do |free_space, index|
                instance_double(VSphereCloud::DiskConfig, size: 0, target_datastore_pattern: "ds-#{index}", existing_datastore_name: nil)
              end

              picker = DatastorePicker.new(0)
              picker.update(available_datastores)

              expect(picker.best_disk_placement(disks)[:balance_score]).to eq(input[:balance_score])
            end
          end
        end
      end

      context 'simulating placement distribution of several datastores' do
        before do
          allow(ds_1_mob).to receive_message_chain('summary.maintenance_mode').and_return(maintenance_mode)
        end
        let(:maintenance_mode) { "normal" }
        let(:ds_1_mob) { instance_double(VimSdk::Vim::Datastore) }
        let(:datastore_1) { instance_double(VSphereCloud::Resources::Datastore, free_space: 51200, mob: ds_1_mob) }
        let(:datastore_2) { instance_double(VSphereCloud::Resources::Datastore, free_space: 10240, mob: ds_1_mob) }
        let(:datastore_3) { instance_double(VSphereCloud::Resources::Datastore, free_space: 20480, mob: ds_1_mob) }
        let(:datastore_4) { instance_double(VSphereCloud::Resources::Datastore, free_space: 10240, mob: ds_1_mob) }
        let(:available_datastores) do
          {
            'datastore-1' => datastore_1,
            'datastore-2' => datastore_2,
            'datastore-3' => datastore_3,
            'datastore-4' => datastore_4
          }
        end
        let(:disk1) do
          instance_double(VSphereCloud::DiskConfig,
            size: 256,
            target_datastore_pattern: '.*',
            existing_datastore_name: nil
          )
        end
        let(:disk2) do
          instance_double(VSphereCloud::DiskConfig,
            size: 512,
            target_datastore_pattern: '.*',
            existing_datastore_name: nil
          )
        end
        let(:disk3) do
          instance_double(VSphereCloud::DiskConfig,
            size: 512,
            target_datastore_pattern: '.*',
            existing_datastore_name: nil
          )
        end
        let(:disk4) do
          instance_double(VSphereCloud::DiskConfig,
            size: 1024,
            target_datastore_pattern: '.*',
            existing_datastore_name: nil
          )
        end

        it 'simulates placement' do
          picker = DatastorePicker.new(0)
          picker.update(available_datastores)
          disks = [disk1, disk2, disk3, disk4]
          allow(Random).to receive(:rand).and_call_original
          'ds-1 => [disk1, disk2]'
          disk_counts_hash = {}
          100.times do
            picker.best_disk_placement(disks)[:datastores].each do |ds_name, ds_props|
              disk_counts_hash[ds_name] ||= 0
              disk_counts_hash[ds_name] += ds_props[:disks].length
            end
          end
          sorted_datastores = available_datastores.sort do |x, y|
            y[1].free_space <=> x[1].free_space
          end
          puts 'Summary of simulated placements'
          sorted_datastores.each do |ds|
            print "#{ds[0]}: free_space => #{ds[1].free_space}, disk_counts => #{disk_counts_hash[ds[0]]}\n"
          end
        end
      end
    end

    describe '#pick_datastore_for_single_disk' do
      before do
        allow(ds_mob).to receive_message_chain('summary.maintenance_mode').and_return(maintenance_mode)
      end
      let(:ds_mob) { instance_double(VimSdk::Vim::Datastore) }
      let(:maintenance_mode) { "normal" }
      let(:smaller_ds) { instance_double(VSphereCloud::Resources::Datastore, free_space: 256, mob: ds_mob, accessible?: true) }
      let(:larger_ds) { instance_double(VSphereCloud::Resources::Datastore, free_space: 1024, mob: ds_mob, accessible?: true) }
      let(:available_datastores) do
       {
         'smaller-ds' => smaller_ds,
         'larger-ds' => larger_ds,
       }
      end
      let(:disk) do
        instance_double(VSphereCloud::DiskConfig,
          size: 512,
          target_datastore_pattern: '.*',
          existing_datastore_name: nil
        )
      end

      context 'when all the hosts for all the datastores are not in maintenance mode' do
        it 'returns the picked datastore name' do
          picker = DatastorePicker.new(0)
          picker.update(available_datastores)

          expect(picker.pick_datastore_for_single_disk(disk)).to eq('larger-ds')
        end
      end

      context 'when there are no valid datastores for the placement' do
        let(:available_datastores){ { 'smaller-ds' => smaller_ds } }

        it 'raises an error' do
          picker = DatastorePicker.new(0)
          picker.update(available_datastores)

          expect do
            picker.pick_datastore_for_single_disk(disk)

          end.to raise_error(/No valid placement found/)
        end
      end
    end

    describe 'Multiple clusters single datastore' do
      before do
        allow(ds_mob).to receive_message_chain('summary.maintenance_mode').and_return(maintenance_mode)
      end
      let(:ds_mob) { instance_double(VimSdk::Vim::Datastore) }
      let(:maintenance_mode) { "normal" }
      let(:cluster1_ds) { instance_double(VSphereCloud::Resources::Datastore, free_space: 256, mob:ds_mob) }
      let(:cluster2_ds) { instance_double(VSphereCloud::Resources::Datastore, free_space: 1024, mob:ds_mob) }
      let(:shared_ds) { instance_double(VSphereCloud::Resources::Datastore, free_space: 1024, mob:ds_mob) }
      let(:available_datastores_cluster1) do
       {
         'cluster1-ds' => cluster1_ds,
         'shared-ds' => shared_ds,
       }
      end
      let(:available_datastores_cluster2) do
       {
         'cluster2-ds' => cluster2_ds,
         'shared-ds' => shared_ds,
       }
      end

      let(:disk) do
        instance_double(VSphereCloud::DiskConfig,
          size: 128,
          target_datastore_pattern: 'shared-ds',
          existing_datastore_name: nil
        )
      end
    
      it 'calculates the same balance score for both clusters' do
        picker = DatastorePicker.new(0)
        picker.update(available_datastores_cluster1)
        placeholders_cluster1 = picker.best_disk_placement([disk])

        picker2 = DatastorePicker.new(0)
        picker2.update(available_datastores_cluster2)
        placeholders_cluster2 = picker2.best_disk_placement([disk])

        expect(placeholders_cluster1[:balance_score]).to eq(placeholders_cluster2[:balance_score])
      end
    end
  end
end
