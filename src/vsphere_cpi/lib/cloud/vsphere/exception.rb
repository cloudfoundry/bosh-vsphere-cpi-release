module VSphereCloud
  class VMPowerOnError < StandardError
    attr_reader :fault

    def initialize(fault)
      @fault = fault
    end

    def to_s
      "#{super}: #{fault.msg}"
    end

    def unplaceable?
      fault.is_a?(VimSdk::Vim::Fault::RuleViolation) || fault.is_a?(VimSdk::Vim::Fault::GenericDrsFault)
    end
  end
end