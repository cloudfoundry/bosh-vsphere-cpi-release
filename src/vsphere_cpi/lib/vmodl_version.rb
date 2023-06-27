require 'bosh/cpi'
require 'cloud/vsphere/cpi_http_client'
require 'nokogiri'
require 'common/retryable'

# This file can't require 'cloud/vsphere' as that will load the vSphere SDK. It
# should depend on as little as possible.

module VmodlVersionDiscriminant
  # Determine the supported version of the vSphere management API version from
  # the vCenter server's `vimServiceVersions.xml` file. If it's indeterminate or
  # an error occurs then fallback to "6.5".
  #
  # @param [String] the hostname of the vCenter server
  # @return [String] the usable vSphere management API version as one of "7.0",
  #   "6.7", or "6.5"
  def self.retrieve_vmodl_version(host, connection_options, logger = nil)
    logger.info('Fetching vSphere version to locate SDK') unless logger.nil?
    http_client = VSphereCloud::CpiHttpClient.new(connection_options: connection_options)
    url = "https://#{host}/sdk/vimServiceVersions.xml"

    body = Bosh::Retryable.new(tries: 3, on: [StandardError]).retryer do
      response = http_client.get(url)
      unless response.ok?
        logger.warn(<<~TEXT) unless logger.nil?
          Couldn't GET #{url.inspect}, received status code #{response.code}
        TEXT
        next
      end
      response.body
    end
    extract_vmodl_version(Nokogiri.XML(body))
  rescue => e
    logger.warn(<<~TEXT) unless logger.nil?
      Couldn't determine vSphere SDK version: #{e}, falling back to 6.5 SDK
    TEXT
    '6.5'
  end

  # @param [Nokogiri::XML::Document] the XML document from the vCenter server's
  #   `vimServiceVersions.xml` file
  # @return [String] the usable vSphere management API version as one of "7.0",
  #   "6.7", or "6.5"
  def self.extract_vmodl_version(document)
    sequence = extract_vmodl_version_sequence(document)
    return '6.5' if sequence.nil?
    return '8.0' if (sequence[0 .. 1] <=> [8, 0]) >= 0
    return '7.0' if (sequence[0 .. 1] <=> [7, 0]) >= 0
    return '6.7' if (sequence[0 .. 1] <=> [6, 7]) >= 0
    '6.5'
  end

  # Return the version sequence of the vSphere management API. This is an
  # integer array with a minimum of two elements that encodes the API version.
  # For example if the vSphere management API version is "7.0.1.0" then this
  # will return `[7, 0, 1, 0]`.
  #
  # @param [Nokogiri::XML::Document] the XML document from the vCenter server's
  #   `vimServiceVersions.xml` file
  # @return [Array<Integer>, nil] the version sequence of the vSphere management
  #   API or `nil` on failure
  def self.extract_vmodl_version_sequence(document)
    # Find the VIM service version of the urn:vim25 namespace (the namespace of
    # the vSphere management SDK).
    version = document % '/namespaces/namespace[name="urn:vim25"]/version'

    # In a general availability release of vSphere this should be a '.' delimited
    # version string. However if this is a development release then this won't
    # follow that format and we have to look to priorVersions to find the correct
    # API version.
    if !version.nil? && version.text =~ /^\d+(\.\d+){1,}$/
      return version.text.split('.').map { |component| Integer(component) }
    end

    # Select each prior version that's a '.' delimited version string. Return the
    # string that's the maximum when its split on '.' and each resultant component
    # is converted to an integer.
    versions = document.search(<<~XPATH)
      /namespaces/namespace[name="urn:vim25"]/priorVersions/version
    XPATH

    versions.map(&:text).select do |version_text|
      version_text =~ /^\d+(\.\d+){1,}$/
    end.map do |version_text|
      version_text.split('.').map { |component| Integer(component) }
    end.max
  end

  private_class_method :extract_vmodl_version_sequence
end
