##
## SidekiqClient Test
##

class StubWorker
  include Sidekiq::Worker
end

class StubRedis
  attr_accessor :lpush_key, :lpush_string,
    :sadd_key, :sadd_member,
    :zadd_key, :zadd_score, :zadd_member

  def lpush(key, string)
    self.lpush_key = key
    self.lpush_string = string
  end

  def sadd(key, member)
    self.sadd_key = key
    self.sadd_member = member
  end

  def zadd(key, score, member)
    self.zadd_key = key
    self.zadd_score = score
    self.zadd_member = member
  end
end

assert("Sidekiq::Client#push") do
  redis = StubRedis.new
  client = Sidekiq::Client.new(redis)

  jid = client.push({'class' => StubWorker, 'args' => ['a']})

  assert_equal(Sidekiq.default_worker_options['queue'], redis.sadd_member)
  assert_equal("queue:#{Sidekiq.default_worker_options['queue']}", redis.lpush_key)

  actual = JSON.parse(redis.lpush_string)
  assert_equal('StubWorker', actual['class'])
  assert_equal(['a'],        actual['args'])
  assert_equal('default',    actual['queue'])
  assert_true(actual['retry'])
  assert_equal(jid,          actual['jid'])
  assert_not_equal(nil, actual['created_at'])
  assert_not_equal(nil, actual['enqueued_at'])
end

assert("Sidekiq::Client#push with at") do
  redis = StubRedis.new
  client = Sidekiq::Client.new(redis)

  jid = client.push({'class' => StubWorker, 'args' => ['a'], 'at' => 1.0})

  assert_equal(1.0, redis.zadd_score)

  actual = JSON.parse(redis.zadd_member)
  assert_equal('StubWorker', actual['class'])
  assert_equal(['a'],        actual['args'])
  assert_equal('default',    actual['queue'])
  assert_true(actual['retry'])
  assert_equal(jid,          actual['jid'])
  assert_not_equal(nil,      actual['created_at'])
  assert_nil(actual['enqueued_at'])
end

assert("Sidekiq::Client#push with option") do
  redis = StubRedis.new
  client = Sidekiq::Client.new(redis)

  class StubOptionWorker < StubWorker
    sidekiq_options queue: 'test', retry: false, opt1: 1
  end

  client.push({'class' => StubOptionWorker, 'args' => []})

  assert_equal('test', redis.sadd_member)
  assert_equal("queue:test", redis.lpush_key)

  actual = JSON.parse(redis.lpush_string)
  assert_equal('StubOptionWorker', actual['class'])
  assert_equal('test',    actual['queue'])
  assert_false(actual['retry'])
  assert_equal(1,          actual['opt1'])
end


