require 'spec_helper'

module VSphereCloud
  describe Client do
    include FakeFS::SpecHelpers

    subject(:client) { described_class.new('fake-host', soap_log: 'fake-soap-log') }
    let(:fake_service_content) { double('service content', root_folder: double('fake-root-folder')) }

    let(:fake_search_index) { double(:search_index) }

    let(:logger) { instance_double('Logger') }
    before { class_double('Bosh::Clouds::Config', logger: logger).as_stubbed_const }

    before do
      fake_instance = double('service instance', content: fake_service_content)
      allow(VimSdk::Vim::ServiceInstance).to receive(:new).and_return(fake_instance)
      allow(fake_service_content).to receive(:search_index).and_return(fake_search_index)
    end

    describe '#initialize' do
      it 'creates soap stub' do
        stub_adapter = instance_double('VimSdk::Soap::StubAdapter')
        soap_stub = instance_double('VSphereCloud::SoapStub', create: stub_adapter)
        expect(SoapStub).to receive(:new).with('fake-host', 'fake-soap-log').and_return(soap_stub)
        expect(client.soap_stub).to eq(stub_adapter)
      end
    end

    describe '#find_by_inventory_path' do
      context 'given a string' do
        it 'passes the path to a SearchIndex object when path contains no slashes' do
          expect(fake_search_index).to receive(:find_by_inventory_path).with('foobar')
          client.find_by_inventory_path("foobar")
        end

        it 'does not escape slashes into %2f' +
            'because we want to allow users to specify nested objects' do
          expect(fake_search_index).to receive(:find_by_inventory_path).with('foo/bar')
          client.find_by_inventory_path("foo/bar")
        end
      end

      context 'given a flat array of strings' do
        it 'joins them with slashes' do
          expect(fake_search_index).to receive(:find_by_inventory_path).with('foo/bar')
          client.find_by_inventory_path(['foo', 'bar'])
        end

        it 'does not escape slashes into %2f' +
            'because we want to allow users to specify nested objects' do
          expect(fake_search_index).to receive(:find_by_inventory_path).with('foo/bar/baz')
          client.find_by_inventory_path(['foo', 'bar/baz'])
        end
      end

      context 'given a nested array of strings' do
        it 'joins them with slashes recursively' do
          expect(fake_search_index).to receive(:find_by_inventory_path).with('foo/bar/baz')
          client.find_by_inventory_path(['foo', ['bar', 'baz']])
        end

        it 'does not escape slashes into %2f' +
            'because we want to allow users to specify nested objects' do
          expect(fake_search_index).to receive(:find_by_inventory_path).with('foo/bar/baz/jaz')
          client.find_by_inventory_path(['foo', ['bar', 'baz/jaz']])
        end
      end
    end

    describe '#create_folder' do
      it 'calls create folder on service content root folder' do
        expect(fake_service_content.root_folder).to receive(:create_folder).with('fake-folder-name')
        client.create_folder('fake-folder-name')
      end
    end

    describe '#delete_path' do
      let(:datacenter) { instance_double('VimSdk::Vim::Datacenter') }
      let(:task) { instance_double('VimSdk::Vim::Task') }
      let(:file_manager) { instance_double('VimSdk::Vim::FileManager') }

      before do
        allow(fake_service_content).to receive(:file_manager).and_return(file_manager)
      end

      context 'when the path exits' do
        it 'calls delete_file on file manager' do
          expect(client).to receive(:wait_for_task).with(task)

          expect(file_manager).to receive(:delete_file).
              with('[some-datastore] some/path', datacenter).
              and_return(task)

          client.delete_path(datacenter, '[some-datastore] some/path')
        end
      end

      context 'when file manager raises "File not found" error' do
        it 'does not raise error' do
          expect(client).to receive(:wait_for_task).with(task).
              and_raise(RuntimeError.new('File [some-datastore] some/path was not found'))

          expect(file_manager).to receive(:delete_file).
              with('[some-datastore] some/path', datacenter).
              and_return(task)

          expect {
            client.delete_path(datacenter, '[some-datastore] some/path')
          }.to_not raise_error
        end
      end

      context 'when file manager raises other error' do
        it 'raises that error' do
          error = RuntimeError.new('Invalid datastore path some/path')
          expect(client).to receive(:wait_for_task).with(task).
              and_raise(error)
          expect(file_manager).to receive(:delete_file).
              with('some/path', datacenter).
              and_return(task)

          expect {
            client.delete_path(datacenter, 'some/path')
          }.to raise_error(error)
        end
      end
    end

    describe '#delete_disk' do
      let(:datacenter) { instance_double('VimSdk::Vim::Datacenter') }
      let(:vmdk_task) { instance_double('VimSdk::Vim::Task') }
      let(:flat_vmdk_task) { instance_double('VimSdk::Vim::Task') }
      let(:file_manager) { instance_double('VimSdk::Vim::FileManager') }

      before do
        allow(fake_service_content).to receive(:file_manager).and_return(file_manager)
      end

      context 'when the disk exists' do
        it 'calls delete_file on file manager for each vmdk' do
          expect(client).to receive(:wait_for_task).with(vmdk_task)
          expect(client).to receive(:wait_for_task).with(flat_vmdk_task)

          expect(file_manager).to receive(:delete_file).
              with('[some-datastore] some/path.vmdk', datacenter).
              and_return(vmdk_task)
          expect(file_manager).to receive(:delete_file).
              with('[some-datastore] some/path-flat.vmdk', datacenter).
              and_return(flat_vmdk_task)

          client.delete_disk(datacenter, '[some-datastore] some/path')
        end
      end

      context 'when file manager raises "File not found" error for the .vmdk' do
        it 'does not raise error' do
          expect(client).to receive(:wait_for_task).with(vmdk_task).
              and_raise(RuntimeError.new('File [some-datastore] some/path.vmdk was not found'))
          expect(client).to receive(:wait_for_task).with(flat_vmdk_task)

          expect(file_manager).to receive(:delete_file).
              with('[some-datastore] some/path.vmdk', datacenter).
              and_return(vmdk_task)
          expect(file_manager).to receive(:delete_file).
              with('[some-datastore] some/path-flat.vmdk', datacenter).
              and_return(flat_vmdk_task)

          expect {
            client.delete_disk(datacenter, '[some-datastore] some/path')
          }.to_not raise_error
        end
      end

      context 'when file manager raises "File not found" error for the -flat.vmdk' do
        it 'does not raise error' do
          expect(client).to receive(:wait_for_task).with(vmdk_task)
          expect(client).to receive(:wait_for_task).with(flat_vmdk_task).
              and_raise(RuntimeError.new('File [some-datastore] some/path-flat.vmdk was not found'))

          expect(file_manager).to receive(:delete_file).
              with('[some-datastore] some/path.vmdk', datacenter).
              and_return(vmdk_task)
          expect(file_manager).to receive(:delete_file).
              with('[some-datastore] some/path-flat.vmdk', datacenter).
              and_return(flat_vmdk_task)

          expect {
            client.delete_disk(datacenter, '[some-datastore] some/path')
          }.to_not raise_error
        end
      end

      context 'when file manager raises other error' do
        it 'raises that error' do
          error = RuntimeError.new('Invalid datastore path some/path.vmdk')
          expect(client).to receive(:wait_for_task).with(vmdk_task).
              and_raise(error)
          expect(file_manager).to receive(:delete_file).
              with('some/path.vmdk', datacenter).
              and_return(vmdk_task)

          expect {
            client.delete_disk(datacenter, 'some/path.vmdk')
          }.to raise_error(error)
        end
      end
    end

    describe '#create_disk' do
      let(:file_manager) do
        instance_double('VimSdk::Vim::FileManager',
          make_directory: nil
        )
      end

      before do
        allow(fake_service_content).to receive(:file_manager).and_return(file_manager)
      end

      let(:datacenter) do
        instance_double('Resources::Datacenter', mob: 'fake-mob')
      end

      let(:datastore) do
        instance_double('Resources::Datastore', name: 'fake-datastore')
      end

      let(:disk_folder) { instance_double('VimSdk::Vim::Folder') }
      let(:disk_spec) do
        instance_double('VimSdk::Vim::VirtualDiskManager::FileBackedVirtualDiskSpec')
      end

      before do
        allow(disk_spec).to receive(:capacity_kb=)
        allow(disk_spec).to receive(:adapter_type=)
      end

      let(:disk_manager) do
        instance_double('VimSdk::Vim::VirtualDiskManager',
          create_virtual_disk: nil,
        )
      end

      before do
        allow(fake_service_content).to receive(:virtual_disk_manager).and_return(disk_manager)
      end

      before do
        allow(
          VimSdk::Vim::VirtualDiskManager::FileBackedVirtualDiskSpec
        ).to receive(:new).and_return(disk_spec)
      end

      before do
        allow(client).to receive(:wait_for_task)
      end

      context 'when specifying a valid disk type' do
        it 'creates a disk' do
          expect(disk_spec).to receive(:disk_type=).with('eagerZeroedThick')
          client.create_disk(datacenter, datastore, 'disk_cid', disk_folder, 10, 'eagerZeroedThick')
        end
      end

      context 'when the type is nil' do
        it 'raises an error' do
          expect {
            client.create_disk(datacenter, datastore, 'disk_cid', disk_folder, 10, nil)
          }.to raise_error 'no disk type specified'
        end
      end

    end

    describe '#delete_folder' do
      let(:folder) { instance_double('VimSdk::Vim::Folder') }

      it 'calls destroy on folder and waits for task' do
        task = double('fake-task')

        expect(folder).to receive(:destroy).and_return(task)
        expect(client).to receive(:wait_for_task).with(task)
        client.delete_folder(folder)
      end
    end

    describe '#create_datastore_folder' do
      let(:datacenter) { instance_double('VimSdk::Vim::Datacenter') }
      let(:file_manager) { instance_double('VimSdk::Vim::FileManager') }
      before { allow(fake_service_content).to receive(:file_manager).and_return(file_manager) }

      it 'creates a folder in datastore' do
        expect(file_manager).to receive(:make_directory).with('[fake-datastore-name] fake-folder-name', datacenter, true)
        client.create_datastore_folder('[fake-datastore-name] fake-folder-name', datacenter)
      end
    end

    describe '#power_on_vm' do
      let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }
      let(:datacenter) { instance_double('VimSdk::Vim::Datacenter') }
      let(:vm) { instance_double('VimSdk::Vim::Vm') }
      let(:task) { instance_double('VimSdk::Vim::Task') }
      let(:result) { double('RuntimeGeneratedResultClass') }

      let(:properties) {
        {
          task => {
            'info.progress' => 0,
            'info.state' => VimSdk::Vim::TaskInfo::State::SUCCESS,
            'info.result' => result,
            'info.error' => nil,
          }
        }
      }

      before do
        client.instance_variable_set('@cloud_searcher', cloud_searcher)
        expect(datacenter).to receive(:power_on_vm).with([vm], nil).and_return(task)
        allow(cloud_searcher).to receive(:get_properties).and_return(properties)
      end

      context 'when the task has attempted to power on the vm' do
        let(:first_attempt) { double('RuntimeGeneratedAttemptClass') }

        it 'returns info.result from the remote call' do
          expect(result).to receive(:recommendations).and_return(Array.new)
          expect(result).to receive(:attempted).twice.and_return([first_attempt])
          expect(first_attempt).to receive(:task).and_return(task)
          expect(client.power_on_vm(datacenter, vm)).to eq(result)
        end
      end

      context 'when the task has not attempted to power on the vm' do
        let(:not_attempted_info) { instance_double('VimSdk::Vim::Cluster::NotAttemptedVmInfo') }
        let(:not_attempted_info_fault) { instance_double('VimSdk::Vim::Fault::NumVirtualCpuExceedsLimit') }
        let(:msg) { "The total number of virtual CPUs present or requested in virtual machines' configuration has exceeded the limit on the host: 300." }

        it 'raises "Cloud not power on VM" with error details' do
          expect(result).to receive(:recommendations).and_return(Array.new)
          expect(result).to receive(:attempted).and_return(Array.new)
          expect(result).to receive(:not_attempted).and_return([not_attempted_info])
          expect(not_attempted_info).to receive(:fault).and_return(not_attempted_info_fault)
          expect(not_attempted_info_fault).to receive(:msg).and_return(msg)
          expect { client.power_on_vm(datacenter, vm) }.to raise_error("Could not power on VM '#{vm}': #{msg}")
        end
      end

      context 'when recommendations are detected' do
        it 'returns info.result from the remote call' do
          expect(result).to receive(:recommendations).and_return(['recommendation one'])
          expect { client.power_on_vm(datacenter, vm) }.to raise_error('Recommendations were detected, you may be running in Manual DRS mode. Aborting.')
        end
      end
    end
  end
end
