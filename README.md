# mruby-sidekiq-client   [![Build Status](https://travis-ci.org/monochromegane/mruby-sidekiq-client.svg?branch=master)](https://travis-ci.org/monochromegane/mruby-sidekiq-client)

Sidekiq Client class for mruby.

Sidekiq is a simple, efficient background processing for CRuby and JRuby.

This mrbgem provides Sidekiq worker module for mruby. Your mruby code can register background jobs to Redis server, and Sidekiq server (works on CRuby and JRuby) take out and process the jobs.

## Usage

1. Add a worker to process jobs asynchronously:

  ```ruby
  class HardWorker
    include Sidekiq::Worker
  end
  ```
  You don't have to implement `perform` method. But you must prepare a same name class that has `perform` method for Sidekiq server.

2. Create a job to be processed asynchronously:

  ```ruby
  HardWorker.perform_async('bob', 5)
  ```

  You can also create a job to be processed in the future:

  ```ruby
  HardWorker.perform_in(300, 'bob', 5) # process after 300 sec
  ```

## Configure

```ruby
Sidekiq.configure_client do |config|
  config.redis = { host: 'localhost', port: 6379 }
  config.default_worker_options = { queue: 'default', retry: true }
end
```

You can specify options in every worker.

```ruby
class HardWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default', retry: true
end
```

## install by mrbgems
- add conf.gem line to `build_config.rb`

```ruby
MRuby::Build.new do |conf|

    # ... (snip) ...

    conf.gem :github => 'monochromegane/mruby-sidekiq-client'
end
```

## License

[MIT](https://github.com/monochromegane/mruby-sidekiq-client/blob/master/LICENSE)

## Author

[monochromegane](https://github.com/monochromegane)
