RSpec::Support.require_rspec_core "formatters/base_text_formatter"

class VerboseFormatter < RSpec::Core::Formatters::BaseTextFormatter
  RSpec::Core::Formatters.register self, :example_started, :example_passed, :example_pending, :example_failed

  def example_started(notification)
    output.puts started_output(notification.example)
  end

  def example_passed(notification)
    output.puts passed_output(notification.example)
  end

  def example_pending(notification)
    output.puts pending_output(notification.example, notification.example.execution_result.pending_message)
  end

  def example_failed(notification)
    output.puts failure_output(notification.example, "\n") + notification.fully_formatted(next_failure_index) + "\n\n"
  end

  private

  def format(verb, example, appended_content = nil)
    "Example #{verb} '#{example.full_description.strip}' #{example.location}#{appended_content ? " " + appended_content : ''}"
  end

  def started_output(example)
    RSpec::Core::Formatters::ConsoleCodes.wrap('#' * 80 + "\n" + format('started', example), :detail)
  end

  def passed_output(example)
    RSpec::Core::Formatters::ConsoleCodes.wrap(format('passed ', example), :success)
  end

  def pending_output(example, message)
    RSpec::Core::Formatters::ConsoleCodes.wrap(format('pending', example, "(PENDING: #{message})"), :pending)
  end

  def failure_output(example, append_content)
    RSpec::Core::Formatters::ConsoleCodes.wrap(format('failed ', example, append_content), :failure)
  end

  def next_failure_index
    @next_failure_index ||= 0
    @next_failure_index += 1
  end
end
