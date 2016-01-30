module Sidekiq
  class Client
    attr_reader :redis

    def initialize(redis=nil)
      @redis = redis || Sidekiq.redis
    end

    def push(item)
      normed = normalize_item(item)
      raw_push(normed)
      normed['jid']
    end

    private

    def raw_push(payload)
      if payload['at']
        at = payload.delete('at').to_s
        redis.zadd('schedule', at, Sidekiq.dump_json(payload))
      else
        q = payload['queue']
        payload['enqueued_at'] = Time.now.to_f
        to_push = Sidekiq.dump_json(payload)

        redis.sadd('queues', q)
        redis.lpush("queue:#{q}", to_push)
      end
      true
    end

    def normalize_item(item)
      normalized_hash(item['class'])
        .each{ |key, value| item[key] = value if item[key].nil? }

      item['class'] = item['class'].to_s
      item['queue'] = item['queue'].to_s
      item['jid'] ||= SecureRandom.hex(12)
      item['created_at'] ||= Time.now.to_f
      item
    end

    def normalized_hash(item_class)
      DEFAULT_WORKER_OPTIONS
    end
  end
end
