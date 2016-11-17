require 'oga'

module VSphereCloud
  module SdkHelpers
    class LogFilter

      FILTERS = [
        "soapenv:Envelope/soapenv:Body/Login/password",
      ]

      def filter(content)
        document = Oga.parse_xml(content)
        FILTERS.none? do |filter|
          matching_node = document.xpath(filter)

          matching_node.none? do |element|
            text = Oga::XML::Text.new
            text.text = 'redacted'

            element.children = [text]
          end
        end

        document.to_xml
      end

    end
  end
end
