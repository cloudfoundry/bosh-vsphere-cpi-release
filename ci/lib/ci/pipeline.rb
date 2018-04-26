require 'erb'

# A pipeline to be generated. Each ERB template in the pipeline is evaluated in
# the context of an instance of {Pipeline}.
class Pipeline
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
    erb = ERB.new(File.read(file), nil, '-')
    erb.filename = file.to_s
    erb.result(binding.tap do |b|
      kwargs.each { |k, v| b.local_variable_set(k, v) }
    end)
  end
end
