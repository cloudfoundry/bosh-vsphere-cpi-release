require 'spec_helper'
require 'timecop'

describe VSphereCloud::TaskRunner do
  subject(:task_runner) do
    VSphereCloud::TaskRunner.new(
      cloud_searcher: cloud_searcher,
      logger: logger,
      retry_judge: retry_judge,
      retryer: retryer,
    )
  end
  let(:cloud_searcher) { instance_double(VSphereCloud::CloudSearcher) }
  let(:retry_judge) { instance_double(VSphereCloud::SdkHelpers::RetryJudge) }
  let(:logger) { instance_double(Logger, info: nil, debug: nil) }
  let(:task_mob) { instance_double(VimSdk::Vim::Task) }
  let(:entity) { 'VirtualMachine' }
  let(:task_name) { 'PowerOnVM_Task' }
  let(:retryer) { VSphereCloud::Retryer.new }

  describe '#run' do
    before do
      allow(retryer).to receive(:sleep)
      allow(task_runner).to receive(:sleep)
      allow(logger).to receive(:warn)
      allow(logger).to receive(:info)
      allow(logger).to receive(:debug)
    end

    it 'waits as a task moves from queued to running to success' do
      define_fake_task(
        task_mob: task_mob,
        states: [
          VimSdk::Vim::TaskInfo::State::QUEUED,
          VimSdk::Vim::TaskInfo::State::RUNNING,
          VimSdk::Vim::TaskInfo::State::SUCCESS,
        ],
        result: 'fake-result',
      )

      expect(logger).to receive(:debug).with(/Finished task '#{task_name}' after .* seconds/)

      expect(task_runner.run{ task_mob }).to eq('fake-result')
    end

    it 'logs warnings for every 30 minutes the task is still running' do
      define_fake_task(
        task_mob: task_mob,
        states: [
          VimSdk::Vim::TaskInfo::State::RUNNING,
          VimSdk::Vim::TaskInfo::State::RUNNING,
          VimSdk::Vim::TaskInfo::State::RUNNING,
          VimSdk::Vim::TaskInfo::State::RUNNING,
          VimSdk::Vim::TaskInfo::State::SUCCESS,
        ],
        progress: 100,
        result: 'fake-result',
      )

      expect(logger).to receive(:debug).with("Waited on task '#{task_name}' for 30 minutes...")
      expect(logger).to receive(:debug).with("Waited on task '#{task_name}' for 60 minutes...")
      expect(logger).to receive(:debug).with(/Finished task '#{task_name}' after .* seconds/)

      Timecop.freeze
      allow(task_runner).to receive(:sleep) do |sleep_time|
        # pretend 15 minutes have elapsed between polling
        Timecop.travel(sleep_time * 900)
      end

      expect(task_runner.run{ task_mob }).to eq('fake-result')
      Timecop.return
    end

    context 'when the task fails and the error is retryable' do
      let(:failing_task_mob) { instance_double(VimSdk::Vim::Task) }
      let(:success_task_mob) { instance_double(VimSdk::Vim::Task) }

      it 'retries the task until it succeeds' do
        define_fake_task(
          task_mob: failing_task_mob,
          states: [
            VimSdk::Vim::TaskInfo::State::RUNNING,
            VimSdk::Vim::TaskInfo::State::ERROR,
          ],
          progress: 0,
          error: instance_double(VimSdk::Vmodl::Fault::SystemError, msg: 'fake-error', fault_cause: 'fake-cause'),
          retryable: true,
        )
        define_fake_task(
          task_mob: success_task_mob,
          states: [
            VimSdk::Vim::TaskInfo::State::RUNNING,
            VimSdk::Vim::TaskInfo::State::SUCCESS,
          ],
          progress: 100,
          result: 'fake-result',
        )


        first_call = true
        task_to_run = Proc.new do
          if first_call
            first_call = false
            failing_task_mob
          else
            success_task_mob
          end
        end

        expect(task_runner.run(&task_to_run)).to eq('fake-result')
      end
    end

    context 'when the task always fails and the error is retryable' do
      let(:task_mobs) do
        mobs = []
        VSphereCloud::Retryer::MAX_TRIES.times do |i|
          mob = instance_double(VimSdk::Vim::Task)
          define_fake_task(
            task_mob: mob,
            states: [
              VimSdk::Vim::TaskInfo::State::ERROR,
            ],
            progress: 0,
            error: instance_double(VimSdk::Vmodl::Fault::SystemError, msg: "fake-error-#{i}", fault_cause: ''),
            retryable: true,
          )
          mobs << mob

          mob
        end
        mobs
      end

      it "re-raises the error after #{VSphereCloud::Retryer::MAX_TRIES} attempts" do
        expect {
          task_runner.run do
            task_mobs.shift
          end
        }.to raise_error(/fake-error-#{VSphereCloud::Retryer::MAX_TRIES - 1}/)
      end
    end

    context 'when the task fails and the error is not retryable' do
      let(:failing_task_mob) { instance_double(VimSdk::Vim::Task) }

      it 'retries the task until it succeeds' do
        define_fake_task(
          task_mob: failing_task_mob,
          states: [
            VimSdk::Vim::TaskInfo::State::RUNNING,
            VimSdk::Vim::TaskInfo::State::ERROR,
          ],
          progress: 0,
          error: instance_double(VimSdk::Vmodl::Fault::SystemError, msg: 'fake-error', fault_cause: ''),
          retryable: false,
        )

        expect {
          task_runner.run { failing_task_mob }
        }.to raise_error(/fake-error/)
      end
    end

    context 'when the task fails and the error is a known type' do
      let(:known_error_task_mob) { instance_double(VimSdk::Vim::Task) }

      it 'wraps the error in a new class' do
        define_fake_task(
          task_mob: known_error_task_mob,
          states: [
            VimSdk::Vim::TaskInfo::State::ERROR,
          ],
          progress: 0,
          error: VimSdk::Vim::Fault::DuplicateName.new,
          retryable: false,
        )

        expect {
          task_runner.run { known_error_task_mob }
        }.to raise_error(VSphereCloud::VCenterClient::DuplicateName)
      end
    end

    def define_fake_task(states:, task_mob:, progress: 0, result: nil, error: nil, retryable: true)
      task = instance_double(VSphereCloud::Resources::Task, retryable?: retryable, name: task_name)

      allow(VSphereCloud::Resources::Task).to receive(:new).with(cloud_searcher, task_mob, retry_judge, logger)
        .and_return(task)

      state_index = 0
      expect(task).to receive(:reload).exactly(states.length).times do
        state_index += 1
      end
      expect(task).to receive(:state).exactly(states.length).times do
        states[state_index - 1]
      end
      allow(task).to receive(:progress).and_return(progress)

      if result
        allow(task).to receive(:result).and_return(result)
      end
      if error
        allow(task).to receive(:error).and_return(error)
      end

      task
    end
  end
end
