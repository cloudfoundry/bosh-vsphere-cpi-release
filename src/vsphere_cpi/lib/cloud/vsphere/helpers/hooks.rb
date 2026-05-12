module Hooks
  def before(*names)
    names.each do |name|
      m = instance_method(name)
      define_method(name) do |*args, &block|
        yield
        m.bind_call(self, *args, &block)
      end
    end
  end
end
