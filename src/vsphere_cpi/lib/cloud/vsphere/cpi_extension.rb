module VSphereCloud
  module VCPIExtension
    include Logger
    DEFAULT_VSPHERE_CPI_EXTENSION_KEY = "sddc.cpi.extension".freeze
    DEFAULT_VSPHERE_CPI_EXTENSION_LABEL = "BOSH vSphere CPI".freeze
    DEFAULT_VSPHERE_CPI_EXTENSION_SUMMARY = "BOSH vSphere CPI Extension".freeze
    DEFAULT_VSPHERE_CPI_EXTENSION_VERSION = "1.0.0".freeze
    DEFAULT_VSPHERE_MANAGED_BY_INFO_DESC = "The lifecycle of this resource is managed by BOSH".freeze
    DEFAULT_VSPHERE_MANAGED_BY_INFO_RESOURCE = "cpi-managed-resource".freeze

    def create_cpi_extension(client)
      @vc_client = client

      return if extension_is_registered?

      logger.debug("Creating the vSphere CPI extension ...")
      cpi_extension = build_extension
      register_extension(cpi_extension)
    rescue => e
      logger.error("Failed to add extension with message #{e.inspect}")
    end

    private

    def vc_client
      @vc_client
    end

    def build_extension(key: DEFAULT_VSPHERE_CPI_EXTENSION_KEY,
      version: DEFAULT_VSPHERE_CPI_EXTENSION_VERSION,
      label: DEFAULT_VSPHERE_CPI_EXTENSION_LABEL,
      summary: DEFAULT_VSPHERE_CPI_EXTENSION_SUMMARY,
      managed_by_info_desc: DEFAULT_VSPHERE_MANAGED_BY_INFO_DESC,
      managed_by_info_resource: DEFAULT_VSPHERE_MANAGED_BY_INFO_RESOURCE, **option
    )
      cpi_extension = VimSdk::Vim::Extension.new
      cpi_extension.key = key
      cpi_extension.version = version
      cpi_extension.last_heartbeat_time = option[:last_heartbeat] || Time.now.iso8601
      cpi_extension.shown_in_solution_manager = true

      cpi_extension_desc = VimSdk::Vim::Description.new
      cpi_extension_desc.label = label
      cpi_extension_desc.summary = summary
      cpi_extension.description = cpi_extension_desc

      managed_by_info = VimSdk::Vim::Ext::ManagedEntityInfo.new
      managed_by_info.description = managed_by_info_desc
      managed_by_info.type = managed_by_info_resource
      cpi_extension.managed_entity_info = [managed_by_info]

      cpi_extension
    end

    def register_extension(extension)
      ext_mgr = vc_client.service_content.extension_manager
      ext_mgr.register_extension(extension)
    end

    def extension_is_registered?(key: DEFAULT_VSPHERE_CPI_EXTENSION_KEY)
      ext_mgr = vc_client.service_content.extension_manager
      cpi_extension = ext_mgr.find_extension(key)
      logger.debug("Extension already exists") unless cpi_extension.nil?
      return !cpi_extension.nil?
    end

    module_function :create_cpi_extension, :build_extension,
      :register_extension, :extension_is_registered?, :vc_client
  end
end
