module VSphereCloud
  module SdkHelpers
    class RetryJudge

      # A failed call must satisfy all criteria for at least one hash below to be deemed non-retryable
      NON_RETRYABLE_CRITERIA = [
        {
          # The CPI rescues on this fault to avoid race conditions
          fault_class: VimSdk::Vim::Fault::DuplicateName,
        },
        {
          # Don't retry delete as sometimes the file is already gone
          fault_class: VimSdk::Vim::Fault::FileFault,
          entity_class: VimSdk::Vim::FileManager,
          method_name: 'DeleteDatastoreFile_Task',
        },
        {
          # Don't retry delete as sometimes the disk is already gone
          fault_class: VimSdk::Vim::Fault::FileFault,
          entity_class: VimSdk::Vim::VirtualDiskManager,
          method_name: 'DeleteVirtualDisk_Task',
        },
        {
          # moving persistent data would be dangerous to retry
          entity_class: VimSdk::Vim::VirtualDiskManager,
          method_name: 'MoveVirtualDisk_Task',
        },
        {
          # only called by tests, not by CPI; leave in blacklist as it moves disks
          entity_class: VimSdk::Vim::VirtualMachine,
          method_name: 'RelocateVM_Task',
        },
        {
          # this class requires permission on the vCenter Root rather than a datacenter which may not be present
          # used in set_vm_metadata where failure is only cosmetic and error is swallowed
          # also used in drs_lock where failure will cause deploy to fail
          entity_class: VimSdk::Vim::CustomFieldsManager,
          fault_class: VimSdk::Vim::Fault::NoPermission,
        },
        {
          # sometimes called to confirm a disk does not exist
          method_name: 'SearchDatastore_Task',
          fault_class: VimSdk::Vim::Fault::FileNotFound,
        }
      ]

      def retryable?(entity, method_name, fault)
        NON_RETRYABLE_CRITERIA.none? do |criterion|
          criterion.all? do |key, value|
            case key
            when :entity_class
              value == entity.class
            when :method_name
              value == method_name
            when :fault_class
              value == fault.class
            end
          end
        end
      end
    end
  end
end
