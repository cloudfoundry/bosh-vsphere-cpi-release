require 'spec_helper'

describe VSphereCloud::Resources::Task do
  subject(:task) do
    VSphereCloud::Resources::Task.new(
      cloud_searcher,
      task_mob,
      retry_judge,
      logger,
    )
  end
  let(:cloud_searcher) { double(VSphereCloud::CloudSearcher) }
  let(:task_mob) { instance_double(VimSdk::Vim::Task) }
  let(:logger) { instance_double('Logger', debug: nil) }
  let(:retry_judge) { VSphereCloud::SdkHelpers::RetryJudge.new }

  let(:task_info) do
    {
      'info.descriptionId' => 'fake-task-description',
      'info.name' => 'PowerOnVM_Task',
      'info.entity' => 'VirtualMachine',
      'info.progress' => 0,
      'info.state' => VimSdk::Vim::TaskInfo::State::RUNNING,
      'info.result' => nil,
      'info.error' => nil,
    }
  end

  before do
    allow(cloud_searcher).to receive(:get_properties)
      .once
      .with(
        [task_mob],
        VimSdk::Vim::Task,
        ['info.name', 'info.descriptionId', 'info.progress', 'info.state', 'info.result', 'info.error', 'info.entity'],
        ensure: ['info.state'],
      )
      .and_return({
        task_mob => task_info,
      })
  end

  describe '#name' do
    context 'when task info includes the description' do
      let(:task_info) do
        {
          'info.descriptionId' => 'fake-task-description',
          'info.name' => 'fake-task-name',
        }
      end

      it 'loads the task description from the server' do
        expect(task.name).to eq('fake-task-description')
      end

    end

    context 'when task info includes a name, but no description' do
      let(:task_info) do
        {
          'info.name' => 'fake-task-name',
        }
      end

      it 'falls back to task name' do
        expect(task.name).to eq('fake-task-name')
      end
    end

    context 'when task info is empty' do
      let(:task_info) do
        {}
      end

      it 'falls back to Unknown Task if no info is available' do
        expect(task.name).to eq('Unknown Task')
      end
    end
  end

  describe '#progress' do
    context 'when task info includes progress' do
      let(:task_info) do
        {
          'info.progress' => 50,
        }
      end

      it 'returns the progress' do
        expect(task.progress).to eq(50)
      end
    end

    context 'when task info is empty' do
      let(:task_info) do
        {}
      end

      it 'falls back to 0' do
        expect(task.progress).to eq(0)
      end
    end
  end

  describe '#state' do
    let(:task_info) do
      {
        'info.state' => VimSdk::Vim::TaskInfo::State::RUNNING,
      }
    end

    it 'returns the state' do
      expect(task.state).to eq(VimSdk::Vim::TaskInfo::State::RUNNING)
    end
  end

  describe '#result' do
    let(:fake_result) { double('result') }
    let(:task_info) do
      {
        'info.result' => fake_result,
      }
    end

    it 'returns the result' do
      expect(task.result).to eq(fake_result)
    end
  end

  describe '#error' do
    let(:fake_error) { double('error') }
    let(:task_info) do
      {
        'info.error' => fake_error,
      }
    end

    it 'returns the error' do
      expect(task.error).to eq(fake_error)
    end
  end

  describe '#reload' do
    it 'caches the response from the server by default' do
      expect(task.name).to eq('fake-task-description')
      expect(cloud_searcher).to_not receive(:get_properties)
      expect(task.name).to eq('fake-task-description')
    end

    it 'updates state from the server on reload' do
      expect(task.name).to eq('fake-task-description')

      updated_task_info = { 'info.descriptionId' => 'fake-updated-task-description' }
      allow(cloud_searcher).to receive(:get_properties)
        .once
        .with(
          [task_mob],
          VimSdk::Vim::Task,
          ['info.name', 'info.descriptionId', 'info.progress', 'info.state', 'info.result', 'info.error', 'info.entity'],
          ensure: ['info.state'],
        )
        .and_return({
          task_mob => updated_task_info,
        })
      task.reload

      expect(task.name).to eq('fake-updated-task-description')
    end
  end

  describe '#retryable?' do
    let(:unknown_error) { instance_double(VimSdk::Vim::Fault) }
    let(:entity) do
      instance_double(VimSdk::Vim::VirtualMachine, class: VimSdk::Vim::VirtualMachine)
    end
    let(:task_info) do
      {
        'info.name' => task_type,
        'info.entity' => entity,
        'info.error' => unknown_error,
      }
    end

    context 'when the task is retryable' do
      let(:task_type) { 'PowerOnVM_Task' }

      it 'returns true' do
        expect(task.retryable?).to be(true)
      end
    end

    context 'when the task is not retryable' do
      let(:task_type) { 'RelocateVM_Task' }

      it 'returns false' do
        expect(task.retryable?).to be(false)
      end
    end
  end
end
