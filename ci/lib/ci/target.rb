require 'time'

# A Concourse target as recognized by `fly`. For more information see the
# {https://concourse.ci/fly-cli.html documentation} on the `fly` CLI.
class Target
  # @return [[Target]] a list of the targets currently known to `fly`
  def self.list
    @list ||= IO.popen(%w[fly targets]).map { |t| new(*t.split(nil, 4)) }
  end

  attr_reader :name, :url, :team

  # @return [Time] the expiry time of the target's authentication token
  attr_reader :expiry

  def initialize(name, url, team, expiry)
    @name, @url, @team, @expiry = name, url, team, Time.rfc2822(expiry)
  end
end
