module Sidekiq

  DEFAULT_WORKER_OPTIONS = {
    'retry' => true,
    'queue' => 'default'
  }

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

  def self.default_worker_options=(hash)
    @default_worker_options = default_worker_options.merge(hash.stringify_keys)
  end

  def self.default_worker_options
    @default_worker_options ||= DEFAULT_WORKER_OPTIONS
  end

  def self.dump_json(object)
    JSON.generate(object)
  end
end
