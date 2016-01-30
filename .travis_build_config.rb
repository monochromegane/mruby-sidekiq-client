MRuby::Build.new do |conf|
  toolchain :gcc
  conf.gembox 'default'
  conf.gem '../mruby-sidekiq-client'
  conf.gem :git => 'https://github.com/monochromegane/mruby-secure-random.git'
  conf.enable_test
end
