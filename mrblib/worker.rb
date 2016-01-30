module Sidekiq
  module Worker
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def perform_async(*args)
        client_push('class' => self, 'args' => args)
      end

      def client_push(item)
        Sidekiq::Client.new(Sidekiq.redis).push(item.stringify_keys)
      end
    end
  end
end
