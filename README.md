# mruby-sidekiq-client   [![Build Status](https://travis-ci.org/monochromegane/mruby-sidekiq-client.png?branch=master)](https://travis-ci.org/monochromegane/mruby-sidekiq-client)
SidekiqClient class
## install by mrbgems
- add conf.gem line to `build_config.rb`

```ruby
MRuby::Build.new do |conf|

    # ... (snip) ...

    conf.gem :github => 'monochromegane/mruby-sidekiq-client'
end
```
## example
```ruby
p SidekiqClient.hi
#=> "hi!!"
t = SidekiqClient.new "hello"
p t.hello
#=> "hello"
p t.bye
#=> "hello bye"
```

## License
under the MIT License:
- see LICENSE file
