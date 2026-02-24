require 'erb'
require 'set'

require 'ci/pool'

# A pipeline to be generated. Each ERB template in the pipeline is evaluated in
# the context of an instance of {Pipeline}.
class Pipeline
  def pool(name)
    pool = Pool.new(name)
    pool.instance_eval { yield pool } if block_given?
    @pool ||= {}
    @pool[name] = pool
  end

  # Calls the given block once for each pool in the pipeline, passing that pool
  # as a parameter. If no block is given an Enumerator is returned.
  def each_pool
    return enum_for(__method__) unless block_given?
    @pool.each { |_, pool| yield pool }
  end

  # Format an object for inclusion into a YAML document
  #
  # This actually uses `#to_json` rather than `#to_yaml` because the latter
  # produces an entire YAML document. If `object` doesn't respond to `#to_json`
  # then it's converted to a `String` by calling `to_s` on it first.
  #
  # @return [String] `object` formatted for inclusion into a YAML document
  def e(object)
    require 'json'
    object.respond_to?(:to_json) ? object.to_json : object.to_s.to_json
  end

  def render(name = 'main', **kwargs)
    require 'erb'
    file = File.join('pipeline', "#{name}.yml.erb")
    erb = ERB.new(File.read(file), trim_mode: '-')
    erb.filename = file.to_s
    erb.result(binding.tap do |b|
      kwargs.each { |k, v| b.local_variable_set(k, v) }
    end)
  end
end
