module Sidekiq

  def self.configure_client
    yield self
  end

  def self.redis=(hash)
    @redis = if hash.is_a?(Redis)
               hash
             else
               Sidekiq::RedisConnection.create(hash)
             end
  end

  def self.redis
    @redis || Sidekiq::RedisConnection.create
  end
end
