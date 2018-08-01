require_relative '../soap_error'

module VimSdk
  module Soap

    class PbmStubAdapter < StubAdapter

      def initialize(*args, vc_cookie:)
        super(*args)
        @vc_cookie = vc_cookie
      end

      private

      def serialize_request(managed_object, info, arguments)
        if !VmomiSupport.is_child_version(@version, info.version)
          fault = Vmodl::Fault::MethodNotFound.new
          fault.receiver = managed_object
          fault.method = info.name
          raise SoapError(fault)
        end

        namespace_map = SOAP_NAMESPACE_MAP.dup
        default_namespace = VmomiSupport.wsdl_namespace(@version)
        namespace_map[default_namespace] = ""

        result = [XML_HEADER, "\n", SOAP_ENVELOPE_START]
        if @vc_cookie
          result << SOAP_HEADER_START
          result << "<vcSessionCookie>#{@vc_cookie}</vcSessionCookie>"
          result << SOAP_HEADER_END
        end

        result << SOAP_BODY_START
        result << "<#{info.wsdl_name} xmlns=\"#{default_namespace}\">"
        property = Property.new('_this', 'Vmodl.ManagedObject', @version)
        property.type = Vmodl::ManagedObject
        result << serialize(managed_object, property, @version, namespace_map)

        info.arguments.zip(arguments).each do |parameter, argument|
          result << serialize(argument, parameter, @version, namespace_map)
        end

        result << "</#{info.wsdl_name}>"
        result << SOAP_BODY_END
        result << SOAP_ENVELOPE_END

        result.join('')
      end
    end
  end
end
