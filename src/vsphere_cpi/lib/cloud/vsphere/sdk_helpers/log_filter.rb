require 'oga'

module VSphereCloud
  module SdkHelpers
    class LogFilter

      FILTERS = [
        "soapenv:Envelope/soapenv:Body/Login/password",
      ]

      def filter(content)
        modified = false

        begin
          document = Oga.parse_xml(content) 
          FILTERS.each do |filter|
            matching_node = document.xpath(filter)

            matching_node.each do |element|
              modified = true
              text = Oga::XML::Text.new
              text.text = 'redacted'

              element.children = [text]
            end
          end
        rescue
          content
        end

        if modified
          document.to_xml
        else
          content
        end
      end

    end
  end
end
