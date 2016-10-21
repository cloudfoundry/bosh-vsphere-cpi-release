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
        elsif ruby_struct.is_a?(Array)
          ruby_struct.each do |item|
            if item.keys.length != 1
              raise "Each XML item in an array must have a single key at the top-level, but found '#{item.keys.join(', ')}'. This key will be used as the name of the XML element."
            end

            itemName = item.keys.first
            itemValue = item[itemName]
            element.children << ruby_struct_to_xml_element(itemName, itemValue)
          end
        else
          element.inner_text = ruby_struct.to_s
        end
        element
      end
    end
  end
end
