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
    expire_time = begin
      Time.rfc2822(expiry)
    rescue
      #if expire time is found (e.g., `n/a: invalid token`) just pass a likely expired time
      Time.now - 60
    end
    @name, @url, @team, @expiry = name, url, team, expire_time
  end
end
