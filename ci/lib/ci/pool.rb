class Pool
  attr_reader :name, :generate_lifecycle_test
  attr_accessor :params, :gating, :shepherd_pool, :testbed_group

  def initialize(name)
    @name = name
    @params = {}
    @generate_lifecycle_test = true
    @gating = true
    @shepherd_pool = name
    @testbed_group = nil
  end

  alias generate_lifecycle_test? generate_lifecycle_test
  alias gating? gating
  alias to_s name
end
