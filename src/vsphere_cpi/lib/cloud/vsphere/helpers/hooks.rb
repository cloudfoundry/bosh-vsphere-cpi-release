module Hooks
  def before(*names)
    names.each do |name|
      m = instance_method(name)
      define_method(name) do |*args, &block|
        yield
        m.bind(self).(*args, &block)
      end
    end
  end
end