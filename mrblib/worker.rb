module Sidekiq
  module Worker
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def perform_async(*args)
        client_push('class' => self, 'args' => args)
      end

      def perform_in(interval, *args)
        int = interval.to_f
        now = Time.now
        ts = (int < 1_000_000_000 ? (now + interval).to_f : int)

        item = { 'class' => self, 'args' => args, 'at' => ts }

        item.delete('at') if ts <= now.to_f

        client_push(item)
      end
      alias_method :perform_at, :perform_in

      def client_push(item)
        Sidekiq::Client.new(Sidekiq.redis).push(item.stringify_keys)
      end
    end
  end
end
