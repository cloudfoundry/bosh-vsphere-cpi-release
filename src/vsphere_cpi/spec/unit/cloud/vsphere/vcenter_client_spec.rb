require 'spec_helper'
require 'timecop'

module VSphereCloud
  describe VCenterClient, fake_logger: true do
    include FakeFS::SpecHelpers

    subject(:client) do
      described_class.new(
        vcenter_api_uri: vcenter_api_uri,
        http_client: http_client
      )
    end
    let(:vcenter_api_uri) { URI.parse('https://fake-host') }
    let(:fake_service_content) { double('service content', root_folder: double('fake-root-folder')) }
    let(:fake_search_index) { double(:search_index) }
    let(:http_client) { instance_double(CpiHttpClient) }
    let(:cloud_searcher) { instance_double('VSphereCloud::CloudSearcher') }
    before { allow(CloudSearcher).to receive(:new).with(fake_service_content).and_return(cloud_searcher) }
    let(:task_runner) { instance_double(TaskRunner) }
    before { allow(TaskRunner).to receive(:new).with(cloud_searcher: cloud_searcher).and_return(task_runner) }

    before do
      fake_instance = double('service instance', content: fake_service_content)
      allow(VimSdk::Vim::ServiceInstance).to receive(:new).and_return(fake_instance)
      allow(fake_service_content).to receive(:search_index).and_return(fake_search_index)
    end

    describe '#initialize' do
      it 'creates soap stub' do
        stub_adapter = instance_double(VimSdk::Soap::StubAdapter)
        soap_stub = instance_double(VSphereCloud::SoapStub, create: stub_adapter)
        expect(SoapStub).to receive(:new).with(vcenter_api_uri, http_client).and_return(soap_stub)
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
      let(:datacenter) { instance_double(VimSdk::Vim::Datacenter) }
      let(:task) { instance_double(VimSdk::Vim::Task) }
      let(:file_manager) { instance_double(VimSdk::Vim::FileManager) }

      before do
        allow(fake_service_content).to receive(:file_manager).and_return(file_manager)
      end

      context 'when the path exits' do
        it 'calls delete_file on file manager' do
          expect(task_runner).to receive(:run) do |*args, &block|
            expect(block.call).to eq(task)
          end

          expect(file_manager).to receive(:delete_file).
              with('[some-datastore] some/path', datacenter).
              and_return(task)

          client.delete_path(datacenter, '[some-datastore] some/path')
        end
      end

      context 'when file manager raises "File not found" error' do
        it 'does not raise error' do
          expect(task_runner).to receive(:run) do |*args, &block|
            expect(block.call).to eq(task)
          end.and_raise(RuntimeError.new('File [some-datastore] some/path was not found'))

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
          expect(task_runner).to receive(:run) do |*args, &block|
            expect(block.call).to eq(task)
          end.and_raise(error)
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
      let(:datacenter) { instance_double(VimSdk::Vim::Datacenter) }
      let(:vmdk_task) { instance_double(VimSdk::Vim::Task) }
      let(:virtual_disk_manager) { instance_double(VimSdk::Vim::VirtualDiskManager) }

      before do
        allow(fake_service_content).to receive(:virtual_disk_manager).and_return(virtual_disk_manager)
      end

      context 'when the disk exists' do
        it 'calls delete_file on file manager for each vmdk' do
          expect(task_runner).to receive(:run) do |*args, &block|
            expect(block.call).to eq(vmdk_task)
          end

          expect(virtual_disk_manager).to receive(:delete_virtual_disk).
              with('[some-datastore] some/path', datacenter).
              and_return(vmdk_task)

          client.delete_disk(datacenter, '[some-datastore] some/path')
        end
      end

      context 'when file manager raises "File not found" error for the disk' do
        it 'does not raise error' do
          expect(task_runner).to receive(:run) do |*args, &block|
            expect(block.call).to eq(vmdk_task)
          end.and_raise(RuntimeError.new('File some/path was not found'))

          expect(virtual_disk_manager).to receive(:delete_virtual_disk).
              with('[some-datastore] some/path', datacenter).
              and_return(vmdk_task)
          expect {
            client.delete_disk(datacenter, '[some-datastore] some/path')
          }.to_not raise_error
        end
      end

      context 'when file manager raises other error' do
        it 'raises that error' do
          error = RuntimeError.new('Invalid datastore path some/path')
          expect(task_runner).to receive(:run) do |*args, &block|
            expect(block.call).to eq(vmdk_task)
          end.and_raise(error)
          expect(virtual_disk_manager).to receive(:delete_virtual_disk).
              with('some/path', datacenter).
              and_return(vmdk_task)

          expect {
            client.delete_disk(datacenter, 'some/path')
          }.to raise_error(error)
        end
      end
    end

    describe '#create_disk' do
      let(:file_manager) do
        instance_double(VimSdk::Vim::FileManager,
          make_directory: nil
        )
      end

      before do
        allow(fake_service_content).to receive(:file_manager).and_return(file_manager)
      end

      let(:datacenter) do
        instance_double(Resources::Datacenter, mob: 'fake-mob')
      end

      let(:datastore) do
        instance_double(Resources::Datastore, name: 'fake-datastore')
      end

      let(:disk_folder) { instance_double(VimSdk::Vim::Folder) }
      let(:disk_spec) do
        instance_double(VimSdk::Vim::VirtualDiskManager::FileBackedVirtualDiskSpec)
      end

      before do
        allow(disk_spec).to receive(:capacity_kb=)
        allow(disk_spec).to receive(:adapter_type=)
      end

      let(:disk_manager) do
        instance_double(VimSdk::Vim::VirtualDiskManager,
          create_virtual_disk: create_disk_task,
        )
      end
      let(:create_disk_task) { instance_double(VimSdk::Vim::Task) }

      before do
        allow(fake_service_content).to receive(:virtual_disk_manager).and_return(disk_manager)
      end

      before do
        allow(
          VimSdk::Vim::VirtualDiskManager::FileBackedVirtualDiskSpec
        ).to receive(:new).and_return(disk_spec)
      end

      context 'when specifying a valid disk type' do
        it 'creates a disk' do
          expect(task_runner).to receive(:run) do |*args, &block|
            expect(block.call).to eq(create_disk_task)
          end

          expect(disk_spec).to receive(:disk_type=).with('eagerZeroedThick')
          expect(Resources::PersistentDisk).to receive(:new).with(cid: 'disk_cid', size_in_mb: 10, datastore: datastore, folder: disk_folder)
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
      let(:folder) { instance_double(VimSdk::Vim::Folder) }

      it 'calls destroy on folder and waits for task' do
        task = double('fake-task')

        expect(folder).to receive(:destroy).and_return(task)
        expect(task_runner).to receive(:run) do |*args, &block|
          expect(block.call).to eq(task)
        end
        client.delete_folder(folder)
      end
    end

    describe '#create_datastore_folder' do
      let(:datacenter) { instance_double(VimSdk::Vim::Datacenter) }
      let(:file_manager) { instance_double(VimSdk::Vim::FileManager) }
      before { allow(fake_service_content).to receive(:file_manager).and_return(file_manager) }

      it 'creates a folder in datastore' do
        expect(file_manager).to receive(:make_directory).with('[fake-datastore-name] fake-folder-name', datacenter, true)
        client.create_datastore_folder('[fake-datastore-name] fake-folder-name', datacenter)
      end
    end

    describe '#power_off_vm' do
      let(:vm) { instance_double(VimSdk::Vim::VirtualMachine) }
      let(:task) { instance_double(VimSdk::Vim::Task) }

      it 'calls power off and waits for task' do
        expect(vm).to receive(:power_off).and_return(task)
        expect(task_runner).to receive(:run) do |*args, &block|
          expect(block.call).to eq(task)
        end
        client.power_off_vm(vm)
      end
    end

    describe '#power_on_vm' do
      let(:vm) { instance_double(VimSdk::Vim::VirtualMachine) }
      let(:datacenter) { instance_double(VimSdk::Vim::Datacenter) }
      let(:result) { double('RuntimeGeneratedResultClass', recommendations: [], attempted: attempted_tasks) }
      let(:attempted_tasks) { [double('power-on-task', task: vm_power_task)] }
      let(:task) { instance_double(VimSdk::Vim::Task) }
      let(:vm_power_task) { instance_double(VimSdk::Vim::Task) }
      let(:vm_power_result) { double('RuntimeGeneratedResultClass') }

      it 'calls power on and waits for task' do
        expect(datacenter).to receive(:power_on_vm).with([vm], nil).and_return(task)

        first_task = true
        expect(task_runner).to receive(:run).twice do |*args, &block|
          # pop tasks in reverse order as wait_for_task calls are nested
          if first_task
            first_task = false
            expect(block.call).to eq(vm_power_task)
            vm_power_result
          else
            expect(block.call).to eq(task)
            result
          end
        end
        client.power_on_vm(datacenter, vm)
      end

      context 'when recommendations are detected' do
        it 'returns info.result from the remote call' do
          expect(result).to receive(:recommendations).and_return(['recommendation one'])
          expect(datacenter).to receive(:power_on_vm).with([vm], nil).and_return(task)

          first_task = true
          expect(task_runner).to receive(:run).twice do |*args, &block|
            # pop tasks in reverse order as wait_for_task calls are nested
            if first_task
              first_task = false
              block.call
            else
              expect(block.call).to eq(task)
              result
            end
          end
          expect {
            client.power_on_vm(datacenter, vm)
          }.to raise_error('Recommendations were detected, you may be running in Manual DRS mode. Aborting.')
        end
      end
    end

    describe '#find_vm_by_name' do
      before do
        allow(cloud_searcher).to receive(:find_resource_by_property_path)
          .with('fake-datacenter-mob', 'VirtualMachine', 'name') do |&block|
            result = nil
            if block.call('foo')
              result = 'foo_vm'
            end
            result
          end
      end
      context 'when a VM with the name vm_name exists in the given datacenter' do
        it 'returns the VM' do
          expect(client.find_vm_by_name('fake-datacenter-mob', 'foo')).to eq('foo_vm')
        end
      end

      context 'when a VM with the name vm_name does not exist in the given datacenter' do
        it 'returns nil' do
          expect(client.find_vm_by_name('fake-datacenter-mob', 'nonexistent')).to be_nil
        end
      end
    end

    describe '#find_vm_by_disk_cid' do
      before do
        allow(cloud_searcher).to receive(:find_resource_by_property_path)
        .with('fake-datacenter-mob', 'VirtualMachine', 'config.vAppConfig.property') do |&block|
          records = [
            instance_double(VimSdk::Vim::VApp::PropertyInfo, label: 'disk0'),
            instance_double(VimSdk::Vim::VApp::PropertyInfo, label: 'disk1')
          ]
          if block.call(records)
            'foo_vm'
          else
            nil
          end
        end
      end

      context 'when a VM with the disk_cid exists in the given datacenter' do
        it 'returns the VM' do
          expect(client.find_vm_by_disk_cid('fake-datacenter-mob', 'disk1')).to eq('foo_vm')
        end
      end

      context 'when a VM with the disk_cid does not exist in the given datacenter' do
        it 'returns nil' do
          expect(client.find_vm_by_disk_cid('fake-datacenter-mob', 'disk2')).to eq(nil)
        end
      end
    end

    describe '#find_all_stemcell_replicas' do
      before do
        allow(cloud_searcher).to receive(:find_resources_by_property_path)
          .with('fake-datacenter-mob', 'VirtualMachine', 'name') do |&block|
            records = {
              'stemcell1' => 'stemcell-1234',
              'stemcell2' => 'stemcell-1234 %2f replica1',
              'stemcell3' => 'unmatched-stemcell'
            }

            results = []
            records.each do |key, value|
              if block.call(value)
                results << key
              end
            end
            results
        end
      end
      context 'when stemcell replicas exist in the given datacenter' do
        it 'returns list of matched replicas' do
          expect(client.find_all_stemcell_replicas('fake-datacenter-mob', 'stemcell-1234')).to match_array(['stemcell1', 'stemcell2'])
        end
      end

      context 'when stemcell replicas do not exist in the given datacenter' do
        it 'returns empty list of matched replicas' do
          expect(client.find_all_stemcell_replicas('fake-datacenter-mob', 'nonexistent')).to match_array([])
        end
      end
    end

    describe '#find_all_stemcell_replicas_in_datastore' do
      before do
        allow(cloud_searcher).to receive(:find_resources_by_property_path)
          .with('fake-datacenter-mob', 'VirtualMachine', 'name') do |&block|
            records = {
              'stemcell1' => 'stemcell-1234',
              'stemcell2' => 'stemcell-1234 %2f replica1',
              'stemcell3' => 'unmatched-stemcell'
            }

            results = []
            records.each do |key, value|
              if block.call(value)
                results << key
              end
            end
            results
        end

        allow(cloud_searcher).to receive(:get_property)
          .with('stemcell1', VimSdk::Vim::VirtualMachine, 'datastore', ensure_all: true)
          .and_return([instance_double('VimSdk::Vim::Datastore', name: 'replica0')])

        allow(cloud_searcher).to receive(:get_property)
          .with('stemcell2', VimSdk::Vim::VirtualMachine, 'datastore', ensure_all: true)
          .and_return([instance_double('VimSdk::Vim::Datastore', name: 'replica1')])
      end
      context 'when stemcell replicas exist in the given datacenter' do
        it 'returns list of matched replicas' do
          expect(client.find_all_stemcell_replicas_in_datastore('fake-datacenter-mob', 'stemcell-1234', 'replica1')).to match_array(['stemcell2'])
        end
      end

      context 'when stemcell replicas do not exist in the given datacenter' do
        it 'returns empty list of matched replicas' do
          expect(client.find_all_stemcell_replicas_in_datastore('fake-datacenter-mob', 'nonexistent', 'replica0')).to match_array([])
        end
      end
    end

    describe '#find_disk_size_using_browser?' do
      let(:datastore) { instance_double(Resources::Datastore, name: 'fake-datastore') }
      let(:datastore_mob) { instance_double(VimSdk::Vim::Datastore) }
      let(:datastore_browser) { instance_double(VimSdk::Vim::Host::DatastoreBrowser) }
      let(:task) { instance_double(VimSdk::Vim::Task) }
      let(:disk_infos) { double('VmDisksInfos') }
      let(:file) { double('some-file', capacity_kb: 2048)}

      before do
        allow(datastore).to receive(:mob).and_return(datastore_mob)
        allow(datastore_mob).to receive(:browser).and_return(datastore_browser)
      end

      context 'disk exists' do
        before do
          allow(disk_infos).to receive(:file).and_return([file])
        end

        it 'returns true' do
          expect(datastore_browser).to receive(:search).with('[fake-datastore] fake-disk-folder', anything).and_return(task)
          expect(task_runner).to receive(:run) do |*args, &block|
            expect(block.call).to eq(task)
            disk_infos
          end
          expect(client.find_disk_size_using_browser(datastore, 'fake-disk-cid', 'fake-disk-folder')).to eq(2)
        end
      end

      context 'path does not exist' do
        before do
          allow(disk_infos).to receive(:file).and_return([])
        end

        it 'returns false if the path does not' do
          expect(datastore_browser).to receive(:search).with('[fake-datastore] fake-disk-folder', anything).and_return(task)
          expect(task_runner).to receive(:run) do |*args, &block|
            expect(block.call).to eq(task)
            disk_infos
          end
          expect(client.find_disk_size_using_browser(datastore, 'fake-disk-cid', 'fake-disk-folder')).to be_nil
        end
      end
    end

    describe '#disk_path_exists?' do
      let(:vm_mob) { double('VimSdk::Vim::Vm') }
      let(:environment_browser) { instance_double(VimSdk::Vim::EnvironmentBrowser) }
      let(:datastore_browser) { instance_double(VimSdk::Vim::Host::DatastoreBrowser) }
      let(:task) { instance_double(VimSdk::Vim::Task) }
      let(:vm_disk_infos) { double('VmDisksInfos') }
      let(:properties) {
        {
          task => {
            'info.progress' => 0,
            'info.state' => VimSdk::Vim::TaskInfo::State::SUCCESS,
            'info.result' => vm_disk_infos,
            'info.error' => nil,
          }
        }
      }

      before do
        allow(environment_browser).to receive(:datastore_browser).and_return(datastore_browser)
        allow(vm_mob).to receive(:environment_browser).and_return(environment_browser)
      end

      context 'path exists' do
        before do
          allow(vm_disk_infos).to receive(:file).and_return(['some-file'])
        end

        it 'returns true' do
          expect(datastore_browser).to receive(:search).with('[datastore-name] disk-folder', anything).and_return(task)
          expect(task_runner).to receive(:run) do |*args, &block|
            expect(block.call).to eq(task)
            vm_disk_infos
          end
          expect(client.disk_path_exists?(vm_mob, '[datastore-name] disk-folder/disk-key.vmdk')).to be(true)
        end
      end

      context 'path does not exist' do
        before do
          allow(vm_disk_infos).to receive(:file).and_return([])
        end

        it 'returns false if the path does not' do
          expect(task_runner).to receive(:run) do |*args, &block|
            expect(block.call).to eq(task)
            vm_disk_infos
          end
          expect(datastore_browser).to receive(:search).with('[datastore-name] disk-folder', anything).and_return(task)
          expect(client.disk_path_exists?(vm_mob, '[datastore-name] disk-folder/disk-key.vmdk')).to be(false)
        end
      end
    end

    describe '#add_persistent_disk_property_to_vm' do
      let(:vm) { instance_double(VSphereCloud::Resources::VM, cid: 'vm-cid', mob: 'vm-mob')}
      let(:vm_disk) { instance_double(VimSdk::Vim::Vm::Device::VirtualDisk, key: 'disk-key') }
      let(:disk) { instance_double(VSphereCloud::Resources::PersistentDisk, cid: 'disk-cid', path: 'some-disk-path' )}
      before do
        allow(vm).to receive(:disk_by_cid).with(disk.cid).and_return(vm_disk)
        allow(vm).to receive(:get_vapp_property_by_key).with('disk-key').and_return(nil)
      end
      it 'reconfigures the vm' do
        expect(client).to receive(:reconfig_vm)
        client.add_persistent_disk_property_to_vm(vm, disk)
      end
      context 'disk property already exists on vm' do
        before do
          allow(vm).to receive(:get_vapp_property_by_key).with('disk-key').and_return('something')
        end

        it 'does not reconfigure vm' do
          expect(client).to_not receive(:reconfig_vm)
          client.add_persistent_disk_property_to_vm(vm, disk)
        end
      end
    end

    describe '#delete_persistent_disk_property_from_vm' do
      let(:vm) { instance_double(VSphereCloud::Resources::VM, cid: 'vm-cid', mob: 'vm-mob')}
      let(:vm_disk) { instance_double(VimSdk::Vim::Vm::Device::VirtualDisk, key: 'disk-key') }
      before do
        allow(vm).to receive(:get_vapp_property_by_key).with(vm_disk.key).and_return('something')
      end
      it 'reconfigures the vm' do
        expect(client).to receive(:reconfig_vm)
        client.delete_persistent_disk_property_from_vm(vm, vm_disk.key)
      end
      context 'disk property does not exist on vm' do
        before do
          allow(vm).to receive(:get_vapp_property_by_key).with(vm_disk.key).and_return(nil)
        end

        it 'does not reconfigure vm' do
          expect(client).to_not receive(:reconfig_vm)
          client.delete_persistent_disk_property_from_vm(vm, vm_disk.key)
        end
      end
    end

    describe '#set_custom_field' do
      let(:custom_fields_manager) { instance_double(VimSdk::Vim::CustomFieldsManager) }
      let(:vm_mob) { instance_double(VimSdk::Vim::VirtualMachine) }

      let(:first_field) do
        instance_double(
          VimSdk::Vim::CustomFieldsManager::FieldDef,
          name: 'key', key: 1, managed_object_type: vm_mob.class
        )
      end
      let(:second_field) do
        instance_double(
          VimSdk::Vim::CustomFieldsManager::FieldDef,
          name: 'other-key', key: 2, managed_object_type: vm_mob.class
        )
      end
      let(:custom_fields) { [first_field, second_field] }

      before do
        allow(fake_service_content).to receive(:custom_fields_manager).and_return(custom_fields_manager)
        allow(custom_fields_manager).to receive(:field).and_return(custom_fields)
      end

      context 'when called on existing key' do
        before do
          error = VimSdk::SoapError.new("message", VimSdk::Vim::Fault::DuplicateName.new)
          allow(custom_fields_manager).to receive(:add_field_definition).and_raise(error)
        end

        it 'does not raise an error and sets the metadata' do
          expect(custom_fields_manager).to receive(:set_field).with(vm_mob, 1, 'value')
          expect(custom_fields_manager).to receive(:set_field).with(vm_mob, 1, 'other-value')
          expect(custom_fields_manager).to receive(:set_field).with(vm_mob, 2, 'value')
          expect do
            client.set_custom_field(vm_mob, 'key', 'value')
            client.set_custom_field(vm_mob, 'key', 'other-value')
            client.set_custom_field(vm_mob, 'other-key', 'value')
          end.to_not raise_error
        end
      end
    end

    describe '#find_child_by_name' do
      context 'when the child is there' do
        let(:mob) {double('mob', child_entity: [child_entity])}
        let(:child_entity) {double('child_entity', name: 'child')}
        it 'finds it' do
          expect(client.find_child_by_name(mob, ['child'])).to eq(child_entity)
        end
      end

      context 'when the great-grandchild is there' do
        let(:mob) {double('mob', child_entity: [other_child_entity, child_entity])}
        let(:child_entity) {double('child_entity', name: 'child', child_entity: [grandchild_entity])}
        let(:other_child_entity) {double('other_child_entity', name: 'other_child')}
        let(:grandchild_entity) {double('grandchild_entity', name: 'grandchild', child_entity: [great_grandchild_entity])}
        let(:great_grandchild_entity) {double('great-grandchild_entity', name: 'great-grandchild')}
        it 'finds it' do
          expect(client.find_child_by_name(mob, ['child', 'grandchild', 'great-grandchild'])).to eq(great_grandchild_entity)
        end
      end

    end

    describe '#remove_custom_field_def' do
      let(:custom_fields_manager) { instance_double(VimSdk::Vim::CustomFieldsManager) }
      let(:vm_mob) { instance_double(VimSdk::Vim::VirtualMachine) }
      before do
        allow(fake_service_content).to receive(:custom_fields_manager).and_return(custom_fields_manager)
      end

      context 'when called on existing key' do
        let(:field) do
          instance_double(
            VimSdk::Vim::CustomFieldsManager::FieldDef,
            name: 'key', key: 1, managed_object_type: vm_mob.class
          )
        end

        let(:custom_fields) { [field] }
        before do
          allow(custom_fields_manager).to receive(:field).and_return(custom_fields)
        end

        it 'removes the field definition for the key and deletes all values attached to it' do
          expect(custom_fields_manager).to receive(:remove_field_definition).with(1)
          expect do
            client.remove_custom_field_def('key', vm_mob.class)
          end.to_not raise_error
        end
      end

      context 'when called on non-existing key' do
        before do
          allow(custom_fields_manager).to receive(:field).and_return([])
        end

        it 'does not error' do
          expect(custom_fields_manager).to_not receive(:remove_field_definition)
          expect do
            client.remove_custom_field_def('key', vm_mob.class)
          end.to_not raise_error
        end
      end
    end
  end
end
