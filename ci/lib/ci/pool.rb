class Pool
  attr_reader :name

  attr_writer :params

  def initialize(name)
    @name = name
  end

  def params
    @params ||= {}
  end

  alias to_s name
end
