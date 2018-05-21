module VimSdk

  class Property
    attr_accessor :name
    attr_accessor :type
    attr_accessor :wsdl_name
    attr_accessor :version
    attr_accessor :privilege
    attr_accessor :expected_type

    def initialize(name, type, version, flags = {}, privilege = nil)
      @name = VmodlHelper.vmodl_property_to_ruby(name)
      @type = type.kind_of?(Class) ? type : VmodlHelper.vmodl_type_to_ruby(type)
      @wsdl_name = name
      @version = version
      @privilege = privilege
      @expected_type = nil
      @optional = false
      @link = false
      @linkable = false
      # Initialize new property
      @secret = false

      flags.each do |key, value|
        case key
          when :optional
            @optional = value
          when :link
            @link = value
          when :linkable
            @linkable = value
          #This is a new property so added it here
          when :secret
            @secret = value
          else
            raise "Unknown flag: #{key}"
        end
      end
    end

    def optional?
      @optional
    end

    def link?
      @link
    end

    def linkable?
      @linkable
    end

    #Define new method for secret
    def secret?
      @secret
    end
  end

end