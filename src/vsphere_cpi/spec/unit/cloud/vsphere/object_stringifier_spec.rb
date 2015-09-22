require 'spec_helper'

module VSphereCloud
  class Outter
    class Inner
      include ObjectStringifier
      stringify_with :method_a, :method_b, :private_attribute
      attr_accessor :method_a, :method_b
      private
      def private_attribute
        'this is private'
      end
    end
  end

  describe ObjectStringifier do
    it 'adds a custom to_s to included objects' do
      foo = Outter::Inner.new
      foo.method_a = 'a'
      foo.method_b = 'b'
      expect(foo.to_s).to eq('(VSphereCloud::Outter::Inner (method_a="a", method_b="b", private_attribute="this is private"))')
    end
  end
end
