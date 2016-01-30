module Sidekiq
  class RedisConnection
    def self.create(option={})
      host = option[:host] || 'localhost'
      port = option[:port] || 6379
      Redis.new(host, port)
    end
  end
end

