MRuby::Gem::Specification.new('mruby-sidekiq-client') do |spec|
  spec.license = 'MIT'
  spec.authors = 'monochromegane'
  spec.add_dependency('mruby-redis')
  spec.add_dependency('mruby-iijson')
  spec.add_dependency('mruby-secure-random')
  spec.add_dependency('mruby-time')
end
