class Pool
  attr_reader :name, :generate_lifecycle_test
  attr_accessor :params,:gating

  def initialize(name)
    @name = name
    @params = {}
    @generate_lifecycle_test = true
    @gating = true
  end

  def skip_lifecycle_test
    @generate_lifecycle_test = false
    @gating = false
  end

  alias generate_lifecycle_test? generate_lifecycle_test
  alias gating? gating
  alias to_s name
end
