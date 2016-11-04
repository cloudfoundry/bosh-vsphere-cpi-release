module VSphereCloud
  class DrsLock

    DRS_LOCK_NAME = 'drs_lock'
    MAX_LOCK_TIMEOUT_IN_SECONDS = 30

    class LockError < RuntimeError; end
    class TimeoutError < RuntimeError; end

    def initialize(vm_attribute_manager, logger)
      @vm_attribute_manager = vm_attribute_manager
      @logger = logger
    end

    def with_drs_lock
      acquire_lock
      @logger.debug('Acquired drs lock')
      # Ensure to release the lock only after it is successfully acquired
      begin
        yield
      ensure
        @logger.debug('Releasing drs lock')
        release_lock
      end
    end

    private

    def acquire_lock
      # vm_attribute_manager.create will raise DuplicateName exception if that field already exists
      # Retrying until the call succeeds ensures that only one CPI process is modifying a DRS Group at a time
      retry_with_timeout do
        @vm_attribute_manager.create(DRS_LOCK_NAME)
      end
    rescue TimeoutError
      @logger.debug('Failed to acquire drs lock')
      raise LockError.new('Failed to acquire DRS lock')
    end

    def release_lock
      @vm_attribute_manager.delete(DRS_LOCK_NAME)
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
