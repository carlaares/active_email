$:.unshift File.expand_path('../lib', __FILE__)

begin
  require 'bundler'
  Bundler.setup
rescue LoadError => e
  puts "Error loading bundler (#{e.message}): \"gem install bundler\" for bundler support."
  require 'rubygems'
end

require 'rake'
require 'rake/testtask'
require 'rubygems/package_task'

namespace :test do

  Rake::TestTask.new(:remote) do |t|
    t.pattern = 'test/remote/**/*_test.rb'
    t.ruby_opts << '-rubygems'
    t.libs << 'test'
    t.verbose = true
  end

end

desc "Run the unit test suite"
task :default => 'test:remote'

desc "Delete tar.gz / zip"
task :cleanup => [ :clobber_package ]

spec = eval(File.read('active_email.gemspec'))

Gem::PackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  p.need_zip = true
end

desc "Release the gems and docs to RubyForge"
task :release => [ 'gemcutter:publish' ]

namespace :gemcutter do
  desc "Publish to gemcutter"
  task :publish => :package do
    sh "gem push pkg/active_email-#{ActiveEmail::VERSION}.gem"
  end
end

