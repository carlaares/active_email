#!/usr/bin/env ruby
$:.unshift File.expand_path('../../lib', __FILE__)

begin
  require 'rubygems'
  require 'bundler'
  Bundler.setup
rescue LoadError => e
  puts "Error loading bundler (#{e.message}): \"gem install bundler\" for bundler support."
end

require 'test/unit'
require 'active_email'

if ENV['DEBUG_ACTIVE_EMAIL'] == 'true'
  require 'logger'
  ActiveEmail::Transactional::Gateway.logger = Logger.new(STDOUT)
  ActiveEmail::Transactional::Gateway.wiredump_device = STDOUT
end


module ActiveEmail
  module Fixtures
    DEFAULT_CREDENTIALS = File.join(File.dirname(__FILE__), 'fixtures.yml') unless defined?(DEFAULT_CREDENTIALS)

    private

    def all_fixtures
      @@fixtures ||= load_fixtures
    end

    def fixtures(key)
      data = all_fixtures[key] || raise(StandardError, "No fixture data was found for '#{key}'")

      data.dup
    end

    def load_fixtures
      [DEFAULT_CREDENTIALS].inject({}) do |credentials, file_name|
        if File.exists?(file_name)
          yaml_data = YAML.load(File.read(file_name))
          credentials.merge!(symbolize_keys(yaml_data))
        end
        credentials
      end
    end

    def symbolize_keys(hash)
      return unless hash.is_a?(Hash)

      hash.symbolize_keys!
      hash.each{|k,v| symbolize_keys(v)}
    end
  end
end

Test::Unit::TestCase.class_eval do
  include ActiveEmail::Transactional
  include ActiveEmail::RequiresParameters
  include ActiveEmail::Fixtures
end
