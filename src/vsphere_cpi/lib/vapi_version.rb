module VAPIVersionDiscriminant
  # @return [String] the usable vSphere management API version as one of "7.0",
  #   "6.7", or "6.5"
  # @param [Nokogiri::XML::Document] the XML document from the vCenter server's
  #   `vimServiceVersions.xml` file
  def self.vapi_version(document)
    sequence = retrieve_vapi_version_sequence(document)
    return '6.5' if sequence.nil?
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
  def self.retrieve_vapi_version_sequence(document)
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

  private_class_method :retrieve_vapi_version_sequence
end
