$:.push File.expand_path("../lib", __FILE__)
require 'active_email/version'

Gem::Specification.new do |s|
  s.platform     = Gem::Platform::RUBY
  s.name         = 'active_email'
  s.version      = ActiveEmail::VERSION
  s.summary      = 'Framework and tools for dealing with email service providers.'
  s.description  = 'Active Email is a simple mailer abstraction library used in and sponsored by Stoneacre.'

  s.author = 'Carla Ares'
  s.email = 'carla.ares@gmail.com'
  s.homepage = 'https://github.com/carlaares/active_email'

  s.files = Dir['README.md', 'lib/**/*']
  s.require_path = 'lib'
  
  s.add_dependency('activesupport', '>= 4.0.0')
end
