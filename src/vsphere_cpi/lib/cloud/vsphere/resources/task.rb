module VSphereCloud
  module Resources
    class Task
      def initialize(cloud_searcher, task_mob, retry_judge, logger)
        @cloud_searcher = cloud_searcher
        @task_mob = task_mob
        @retry_judge = retry_judge
        @logger = logger
      end

      def name
        task_info['info.descriptionId'] || task_info['info.name'] || 'Unknown Task'
      end

      def progress
        task_info['info.progress'] || 0
      end

      def state
        task_info['info.state'] || 0
      end

      def result
        task_info['info.result']
      end

      def error
        task_info['info.error']
      end

      def reload
        @cached_task_info = get_properties
      end

      def retryable?
        entity = task_info['info.entity']
        method_name = task_info['info.name']
        fault = task_info['info.error']
        @retry_judge.retryable?(entity, method_name, fault)
      end

      private

      def task_info
        return @cached_task_info if @cached_task_info

        reload

        @cached_task_info
      end

      def get_properties
        @cloud_searcher.get_properties(
          [@task_mob],
          VimSdk::Vim::Task,
          ['info.name', 'info.descriptionId', 'info.progress', 'info.state', 'info.result', 'info.error', 'info.entity'],
          ensure: ['info.state'],
        )[@task_mob]
      end
    end
  end
end
