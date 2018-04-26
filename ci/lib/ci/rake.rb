# Remove did_you_mean as it's very annoying in a Rakefile
DidYouMean::Correctable.send(:remove_method, :to_s) if defined? DidYouMean

# Colorize error messages when the trace output is a TTY
module ColorizeExceptionMessageDetails
  def display_exception_message_details(ex)
    return super unless (options.trace_output || $stderr)&.isatty
    if ex.instance_of?(RuntimeError)
      trace "\e[31;01m#{ex.message}\e[0m"
    else
      trace "\e[31;01m#{ex.class.name}: \e[0m#{ex.message}"
    end
  end
end
Rake::Application.send(:prepend, ColorizeExceptionMessageDetails)
