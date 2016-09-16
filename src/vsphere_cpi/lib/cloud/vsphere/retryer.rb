module VSphereCloud
  class Retryer
    MAX_TRIES = 6
    RETRY_INTERVAL_CAP_SEC = 32 # exponential increases get really big really fast (geometric progression)

    def try(max_tries = MAX_TRIES)
      err = nil
      max_tries.times do |i|
        result, err = yield(i)
        return result if err.nil?
        sleep([(2**i), RETRY_INTERVAL_CAP_SEC].min) if i < max_tries - 1
      end
      raise err if err
    end
  end
end
