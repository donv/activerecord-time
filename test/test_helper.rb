# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
RAILS_ROOT = File.dirname(__FILE__)

require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'

require 'active_record'
require 'activerecord-time'
require 'logger'
require 'fileutils'
require 'yaml'

if defined?(Rake) && (RUBY_ENGINE != 'jruby' || org.jruby.RubyInstanceConfig.FULL_TRACE_ENABLED)
  require 'simplecov'
  SimpleCov.start
end

FileUtils.rm_rf File.expand_path(':memory:', File.dirname(__FILE__))
config = YAML.load_file(File.dirname(__FILE__) + '/database.yml')
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/test.log')
adapter = ENV['ADAPTER'] || 'sqlite3'
if adapter != 'sqlite3'
  ActiveRecord::Base.establish_connection config[adapter].merge(database: nil)
  begin
    ActiveRecord::Base.connection.drop_database config[adapter][:database]
  rescue => e
    puts e
  end
  begin
    ActiveRecord::Base.connection.create_database config[adapter][:database], charset: 'utf8'
  rescue => e
    puts e
  end
end
ActiveRecord::Base.establish_connection config[adapter]
load(File.dirname(__FILE__) + '/schema.rb') if File.exist?(File.dirname(__FILE__) + '/schema.rb')
