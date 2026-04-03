module VSphereCloud
  module ScsiControllerType
    PARAVIRTUAL = 'paravirtual'.freeze
    LSI_LOGIC = 'lsi_logic'.freeze
    LSI_LOGIC_SAS = 'lsi_logic_sas'.freeze

    ALL = [PARAVIRTUAL, LSI_LOGIC, LSI_LOGIC_SAS].freeze
  end
end
