require 'spec_helper'

module VSphereCloud
  describe DatastorePicker do
    let(:available_datastores) do
      {
        "datastore-1" => 51200,
        "datastore-2" => 10240,
        "datastore-3" => 20480,
        "filtered-ds" => 10240
      }
    end

    describe '#suitable_datastores' do
      context 'given a list of datastores, a filter, and remaining capacities in MB' do
        it 'returns a list of datastores that can allocate X amount of space with 1GB headroom' do
          picker = DatastorePicker.new
          picker.update(available_datastores)
          expect(picker.suitable_datastores(19456)).to eq({
            "datastore-1" => 51200,
            "datastore-3" => 20480
          })
          expect(picker.suitable_datastores(19457)).to eq({
            "datastore-1" => 51200,
          })
          expect(picker.suitable_datastores(10240)).to eq({
            "datastore-1" => 51200,
            "datastore-3" => 20480
          })
          expect(picker.suitable_datastores(10000)).to eq({
            "datastore-1" => 51200,
            "datastore-3" => 20480
          })
          expect(picker.suitable_datastores(9216)).to eq( {
            "datastore-1" => 51200,
            "datastore-2" => 10240,
            "datastore-3" => 20480,
            "filtered-ds" => 10240
          })
        end

        context 'given a filter' do
          it 'includes only datastores that match the filter' do
            picker = DatastorePicker.new
            picker.update(available_datastores)
            expect(picker.suitable_datastores(1, /filtered-.*/)).to eq({
              "filtered-ds" => 10240
            })

            expect(picker.suitable_datastores(1, /datastore-.*/)).to eq({
              "datastore-1" => 51200,
              "datastore-2" => 10240,
              "datastore-3" => 20480
            })

            expect(picker.suitable_datastores(1, /bogus/)).to eq({})
          end
        end
      end
    end

    describe '#can_accomodate_disks' do
      let(:available_datastores) do
        {
          "datastore-1" => 1024,
          "datastore-2" => 2048,
          "filtered-ds" => 102400,
        }
      end
      context 'positive cases' do
        [
          [1024, 1024],
          [1024, 1024, 1024],
        ].each do |requested_sizes|
          it "is able to accomodate the given disk sizes: #{requested_sizes}" do
            picker = DatastorePicker.new(0)
            picker.update(available_datastores)
            expect(picker.can_accomodate_disks?(requested_sizes, /datastore-.*/)).to eq(true)
          end
        end
      end
      context 'negative cases' do
        [
          [2048, 2048],
          [1024, 2048],
        ].each do |requested_sizes|
          it "is not able to accomodate the given disk sizes: #{requested_sizes}" do
            picker = DatastorePicker.new(0)
            picker.update(available_datastores)
            expect(picker.can_accomodate_disks?(requested_sizes, /datastore-.*/)).to eq(false)
          end
        end
      end
      context 'given disk headroom' do
        it 'is able to factor in the headroom in the accomodation calculation' do
          bad_requested_sizes = [1024, 1024, 1024]
          good_requested_sizes = [512, 1024, 512]
          picker = DatastorePicker.new(512)
          picker.update(available_datastores)
          expect(picker.can_accomodate_disks?(bad_requested_sizes, /datastore-.*/)).to eq(false)
          expect(picker.can_accomodate_disks?(good_requested_sizes, /datastore-.*/)).to eq(true)
        end
      end
      context 'given datastores with free space [300, 512]' do
        let(:available_datastores) do
          {
            "datastore-1" => 300,
            "datastore-2" => 512,
            "filtered-ds" => 102400,
          }
        end
        good_order = [256, 256, 300]
        bad_order = [300, 256, 256]
        it "is able to accomodate persistent disks if they are attached in this order: #{good_order}" do
          picker = DatastorePicker.new(0)
          picker.update(available_datastores)
          expect(picker.can_accomodate_disks?(good_order, /datastore-.*/)).to eq(true)
        end
        it "is not able to accomodate persistent disks if they are attached in this order: #{bad_order}" do
          picker = DatastorePicker.new(0)
          picker.update(available_datastores)
          expect(picker.can_accomodate_disks?(bad_order, /datastore-.*/)).to eq(false)
        end
      end
    end

    describe '#pick_datastore' do
      it 'picks a datastore from a provided list of datastores given a scoring function' do
        picker = DatastorePicker.new
        picker.update(available_datastores)
        expect(
          picker.pick_datastore(1) { |name, free_space| (name == "datastore-1") ? 1 : 0 }
        ).to eq("datastore-1")
        expect(
          picker.pick_datastore(1) { |name, free_space| (free_space == 20480) ? 1 : 0 }
        ).to eq("datastore-3")

        expect_any_instance_of(Object).to receive(:rand).with(92160).and_return(81919)
        expect(
          picker.pick_datastore(1) { |name, free_space| free_space }
        ).to eq("datastore-3")
      end

      context 'when there is no matching/available datastore' do
        it 'raises an error' do
          picker = DatastorePicker.new
          expect {
            picker.pick_datastore(1)
          }.to raise_error Bosh::Clouds::CloudError, /Could not find any suitable datastores matching filter:.*, with size:.*\. Available datastores:.*/
        end
      end

      context 'when a scoring function is not provided' do
        let(:available_datastores) do
          {
            "datastore-1" => 1,
            "datastore-2" => 2,
            "datastore-3" => 3,
          }
        end

        it 'defaults the scoring function to free_space' do
          picker = DatastorePicker.new(0)
          picker.update(available_datastores)
          6.times do |i|
            allow_any_instance_of(Object).to receive(:rand).with(6).and_return(i)
            expect(picker.pick_datastore(1))
              .to eq(picker.pick_datastore(1) { |name, free_space| free_space })
          end
        end
      end

      context 'given a filter' do
        it 'picks a datastore matching the filter' do
          common_size = 10240
          picker = DatastorePicker.new
          picker.update(available_datastores)

          10.times do
            expect(
              picker.pick_datastore(1, /filtered-.*/) { |name, free_space| (free_space == common_size) ? 1 : 0 }
            ).to eq("filtered-ds")
          end
        end
      end
    end

    describe '#best_disk_placement' do

      context 'when a single DS is available' do
        let(:available_datastores) do
         {
           'ds-1' => {
             free_space: 1024,
           },
         }
        end
        let(:already_placed_disk) do
          {
            size: 256,
            existing_datastore_name: 'ds-1',
            target_datastore_pattern: '.*',
          }
        end
        let(:moved_disk) do
          {
            size: 512,
            target_datastore_pattern: '.*',
          }
        end

        it 'returns the only valid placement' do
          picker = DatastorePicker.new(0)
          picker.update(available_datastores)
          disks = [already_placed_disk, moved_disk]

          expect(picker.best_disk_placement(disks)).to eq({
            'ds-1' => {
              free_space: 1024 - 512,
              disks: disks,
            }
          })
        end

        context 'when no valid placement exists' do
          let(:large_disk) do
            {
              size: 999999,
              target_datastore_pattern: '.*',
            }
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
      end

      context 'when a multiple DS are available' do
        let(:available_datastores) do
         {
           'ds-1' => {
             free_space: 512,
           },
           'ds-2' => {
             free_space: 1024,
           },
         }
        end
        let(:disk1) do
          {
            size: 256,
            target_datastore_pattern: 'ds-2',
          }
        end
        let(:disk2) do
          {
            size: 512,
            target_datastore_pattern: '.*',
          }
        end

        it 'places the disks into the datastores' do
          picker = DatastorePicker.new(0)
          picker.update(available_datastores)

          disks = [disk1, disk2]
          expect(picker.best_disk_placement(disks)).to eq({
            'ds-1' => {
              free_space: 0,
              disks: [disk2],
            },
            'ds-2' => {
              free_space: 768,
              disks: [disk1],
            },
          })
        end

        context 'when given existing_datastore_name' do
          let(:disk1) do
            {
              size: 256,
              existing_datastore_name: 'ds-2',
              target_datastore_pattern: '.*',
            }
          end
          let(:disk2) do
            {
              size: 512,
              target_datastore_pattern: '.*',
            }
          end

          it 'keeps the disk in its existing datastore to minimize disk migrations' do
            picker = DatastorePicker.new(0)
            picker.update(available_datastores)

            disks = [disk1, disk2]
            expect(picker.best_disk_placement(disks)).to eq({
              'ds-1' => {
                free_space: 0,
                disks: [disk2],
              },
              'ds-2' => {
                free_space: 1024,
                disks: [disk1],
              },
            })
          end
        end

        context 'when given existing_datastore_name that is not available' do
          let(:disk1) do
            {
              size: 256,
              existing_datastore_name: 'non-accessible-ds',
              target_datastore_pattern: '.*',
            }
          end
          let(:disk2) do
            {
              size: 512,
              target_datastore_pattern: '.*',
            }
          end

          it 'places the disk in an available datastore' do
            picker = DatastorePicker.new(0)
            picker.update(available_datastores)

            disks = [disk1, disk2]
            expect(picker.best_disk_placement(disks)).to eq({
              'ds-1' => {
                free_space: 256,
                disks: [disk1],
              },
              'ds-2' => {
                free_space: 512,
                disks: [disk2],
              },
            })
          end
        end
      end
    end
  end
end
