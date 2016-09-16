module VSphereCloud
  class TaskRunner

    def initialize(cloud_searcher:, logger:, retry_judge: nil, retryer: nil)
      @cloud_searcher = cloud_searcher
      @logger = logger
      @retry_judge = retry_judge || VSphereCloud::SdkHelpers::RetryJudge.new
      @retryer = retryer || VSphereCloud::Retryer.new
    end

    def run(&block)
      method_result = @retryer.try do |i|
        task_mob = block.call
        task = Resources::Task.new(@cloud_searcher, task_mob, @retry_judge, @logger)

        if i == 0
          @logger.debug("Starting task '#{task.name}'...")
        else
          @logger.warn("Retrying task '#{task.name}', #{i} attempts so far...")
        end

        result, err = wait_for_task(task)

        if err
          @logger.warn(fault_message(task, err))
          err = task_exception_for_vim_fault(err)
          unless task.retryable?
            raise err
          end
        end

        [result, err]
      end
      method_result
    end

    private

    def wait_for_task(task)
      interval = 1.0
      started = Time.now

      wait_log_counter = 1
      wait_log_interval = 1800
      loop do
        task.reload

        duration = Time.now - started
        if duration > wait_log_counter * wait_log_interval
          @logger.debug("Waited on task '#{task.name}' for #{duration.to_i / 60} minutes...")
          wait_log_counter += 1
        end

        # Update the polling interval based on task progress
        if task.progress > 0
          interval = ((duration * 100 / task.progress) - duration) / 5
          if interval < 1
            interval = 1
          elsif interval > 10
            interval = 10
          elsif interval > duration
            interval = duration
          end
        end

        case task.state
          when VimSdk::Vim::TaskInfo::State::RUNNING
            sleep(interval)
          when VimSdk::Vim::TaskInfo::State::QUEUED
            sleep(interval)
          when VimSdk::Vim::TaskInfo::State::SUCCESS
            @logger.debug("Finished task '#{task.name}' after #{duration} seconds")
            return task.result, nil
          when VimSdk::Vim::TaskInfo::State::ERROR
            return nil, task.error
        end
      end
    end

    def task_exception_for_vim_fault(fault)
      exceptions_by_fault = {
        VimSdk::Vim::Fault::FileNotFound => VCenterClient::FileNotFoundException,
        VimSdk::Vim::Fault::DuplicateName => VCenterClient::DuplicateName,
      }
      exceptions_by_fault.fetch(fault.class, VCenterClient::TaskException).new(fault.msg)
    end

    def fault_message(task, fault)
      msg = "Error running task '#{task.name}'. Failed with message '#{fault.msg}'"
      if fault.fault_cause
        msg += " and cause '#{fault.fault_cause}'"
      end
      msg << '.'
      msg
    end
  end
end
