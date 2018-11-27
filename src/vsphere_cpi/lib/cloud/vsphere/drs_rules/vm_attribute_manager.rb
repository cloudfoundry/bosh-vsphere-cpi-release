require 'cloud/vsphere/logger'

module VSphereCloud
  module VMAttributeManager
    include Logger

    module_function

    def init(custom_fields_manager)
      @custom_fields_manager = custom_fields_manager
    end

    def find_by_name(name)
      @custom_fields_manager.field.find { |f| f.name == name }
    end

    def create(name)
      logger.debug("Creating DRS rule attribute: #{name}")
      @custom_fields_manager.add_field_definition(
        name,
        VimSdk::Vim::VirtualMachine,
      )
    end

    def delete(name)
      logger.debug("Deleting DRS rule attribute: #{name}")
      custom_field = find_by_name(name)
      @custom_fields_manager.remove_field_definition(custom_field.key) if custom_field
    end
  end
end
