$:.unshift(File.dirname(__FILE__) + '/../lib')
RAILS_ROOT = File.dirname(__FILE__)

require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'
require 'minitest/reporters'
MiniTest::Reporters.use!

require 'active_record'
require 'activerecord-time'
require 'logger'
require 'fileutils'
require 'yaml'

FileUtils.rm_rf File.expand_path(':memory:', File.dirname(__FILE__))
config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/test.log')
db = ENV['DB'] || 'sqlite3'
if db != 'sqlite3'
  ActiveRecord::Base.establish_connection config[db].merge(database: nil)
  begin
    ActiveRecord::Base.connection.drop_database config[db][:database]
  rescue
    puts $!
  end
  begin
    ActiveRecord::Base.connection.create_database config[db][:database], charset: 'utf8'
  rescue
    puts $!
  end
end
ActiveRecord::Base.establish_connection config[db]
load(File.dirname(__FILE__) + '/schema.rb') if File.exist?(File.dirname(__FILE__) + '/schema.rb')
