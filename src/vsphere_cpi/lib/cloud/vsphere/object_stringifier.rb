module VSphereCloud
  module ObjectStringifier
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def stringify_with(*attributes)
        define_method(:to_s) do
          "(#{self.class.name} (#{attributes.map{|attr| "#{attr}=\"#{self.send(attr)}\""}.join(', ')}))"
        end
      end
    end
  end
end
