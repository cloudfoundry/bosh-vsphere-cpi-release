require 'cloud/vsphere/logger'

module VSphereCloud
  class DrsLock
    include Logger

    DRS_LOCK_NAME = 'drs_lock'
    MAX_LOCK_TIMEOUT_IN_SECONDS = 30

    class LockError < RuntimeError; end
    class TimeoutError < RuntimeError; end

    def initialize(vm_attribute_manager, drs_lock_suffix='')
      @vm_attribute_manager = vm_attribute_manager
      @drs_lock_suffix = drs_lock_suffix
    end

    def with_drs_lock
      acquire_lock
      logger.debug('Acquired drs lock')
      # Ensure to release the lock only after it is successfully acquired
      begin
        yield
      ensure
        logger.debug('Releasing drs lock')
        release_lock
      end
    end

    private

    def drs_lock_name
      DRS_LOCK_NAME + @drs_lock_suffix
    end

    def acquire_lock
      # vm_attribute_manager.create will raise DuplicateName exception if that field already exists
      # Retrying until the call succeeds ensures that only one CPI process is modifying a DRS Group at a time
      retry_with_timeout do
        @vm_attribute_manager.create(drs_lock_name)
      end
    rescue TimeoutError
      logger.debug("Failed to acquire drs lock: #{drs_lock_name}")
      raise LockError.new("Failed to acquire DRS lock: #{drs_lock_name}")
    end

    def release_lock
      @vm_attribute_manager.delete(drs_lock_name)
    end

    def retry_with_timeout
      deadline = Time.now.to_i + MAX_LOCK_TIMEOUT_IN_SECONDS
      begin
        yield
      rescue
        if deadline - Time.now.to_i > 0
          sleep 0.5
          retry
        end
        raise TimeoutError
      end
    end
  end
end
