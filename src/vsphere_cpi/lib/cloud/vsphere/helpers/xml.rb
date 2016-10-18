require 'oga'

module VSphereCloud
  module Helpers
    class XML
      def self.ruby_struct_to_xml(name, ruby_struct)
        ruby_struct_to_xml_element(name, ruby_struct).to_xml
      end

      def self.ruby_struct_to_xml_element(name, ruby_struct)
        element = Oga::XML::Element.new(name: name)
        if ruby_struct.is_a?(Hash)
          ruby_struct.each do |key, value|
            element.children << ruby_struct_to_xml_element(key, value)
          end
        elsif ruby_struct.is_a?(String)
          element.inner_text = ruby_struct
        end
        element
      end
      private_class_method :ruby_struct_to_xml_element
    end
  end
end
