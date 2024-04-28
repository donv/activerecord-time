# frozen_string_literal: true

eval File.read("#{File.dirname __FILE__}/common.gemfile")

platform :jruby do
  # gem 'activerecord-jdbc-adapter'
  # gem 'activerecord-jdbcderby-adapter'
  gem 'activerecord-jdbcpostgresql-adapter'
  gem 'activerecord-jdbcsqlite3-adapter'
end

gem 'activerecord', '~>7.0.0'
