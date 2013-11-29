$:.unshift(File.dirname(__FILE__) + '/../lib')
RAILS_ROOT = File.dirname(__FILE__)

require 'rubygems'
require 'test/unit'
require 'active_record'
require 'activerecord-time'
require 'logger'
require 'fileutils'

FileUtils.rm_rf File.expand_path(':memory:', File.dirname(__FILE__))
config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'sqlite3'])
load(File.dirname(__FILE__) + '/schema.rb') if File.exist?(File.dirname(__FILE__) + '/schema.rb')
