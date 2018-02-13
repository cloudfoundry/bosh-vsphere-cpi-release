require 'spec_helper'
require 'rspec/its'

describe VSphereCloud::Resources::Datastore do
  subject do
    described_class.new('foo_lun', mob, true, 16 * 1024, 8 * 1024)
  end

  let(:mob) do
    instance_double('VimSdk::Vim::Datastore', to_s: 'mob_as_string')
  end

  describe '#mob' do
    it('returns the mob') { expect(subject.mob).to eq(mob) }
  end

  describe '#name' do
    it('returns the name') { expect(subject.name).to eq('foo_lun') }
  end

  context 'when inaccessible' do
    subject do
      described_class.new('foo_lun', mob, false, 16 * 1024, 8 * 1024)
    end

    its(:total_space) { is_expected.to eq(0) }
    its(:free_space) { is_expected.to eq(0) }
  end

  describe '#total_space' do
    it 'returns the total space' do
      expect(subject.total_space).to eq(16384)
    end
  end

  describe '#free_space' do
    it 'returns the free space' do
      expect(subject.free_space).to eq(8192)
    end
  end

  describe '#accessible?' do
    before do
      host_mount = instance_double(VimSdk::Vim::Datastore::HostMount)
      expect(host_mount).to receive_message_chain(:key, :runtime, :in_maintenance_mode).and_return(maintenance_mode)
      expect(mob).to receive(:host).and_return([host_mount])
    end

    context 'when all hosts are in maintenance mode' do
      let(:maintenance_mode) { true }

      it 'is false' do
        expect(subject).to_not be_accessible
      end
    end

    context 'when at least one of the hosts is not in maintenance mode' do
      let(:maintenance_mode) { false }

      it 'is false' do
        expect(subject).to be_accessible
      end
    end
  end

  describe '#accessible_from?' do

    context 'when a cluster with some hosts is defined' do
      let (:cluster) { instance_double(VSphereCloud::Resources::Cluster) }
      let (:host_mob) { instance_double(VimSdk::Vim::HostSystem) }
      let (:host_mount) { instance_double(VimSdk::Vim::Datastore::HostMount, key: host_mob) }

      before do
        expect(host_mount).to receive_message_chain(:key, :runtime, :in_maintenance_mode).and_return(maintenance_mode)
        expect(mob).to receive(:host).and_return([host_mount])
      end

      context 'when all hosts are in maintenance mode' do
        let(:maintenance_mode) { true }
        let(:is_included) { true }
        it 'is false' do
          expect(subject).to_not be_accessible_from(cluster)
        end
      end

      context 'when at least one of the hosts is not in maintenance mode' do
        before do
          expect(cluster).to receive_message_chain(:mob, :host, :include?).with(host_mob).and_return(is_included)
        end
        let(:maintenance_mode) { false }

        context 'when all hosts do not belong to the cluster' do
          let(:is_included) { false }
          it 'is false' do
            expect(subject).to_not be_accessible_from(cluster)
          end
        end
        context 'when at least one of the host belong to the cluster' do
          let(:is_included) { true }
          it 'is true' do
            expect(subject).to be_accessible_from(cluster)
          end
        end
      end
    end
  end

  describe '#inspect' do
    it 'returns the printable form' do
      expect(subject.inspect).to eq("<Datastore: #{mob} / foo_lun>")
    end
  end

  describe '#debug_info' do
    it 'returns the disk space info' do
      expect(subject.debug_info).to eq('foo_lun (8192MB free of 16384MB capacity)')
    end
  end

  describe '#to_s' do
    it 'show relevant info' do
      expect(subject.to_s).to eq(%Q[(#{described_class.name} (name="foo_lun", mob="mob_as_string"))])
    end
  end
end
