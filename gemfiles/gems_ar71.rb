# frozen_string_literal: true

eval File.read("#{File.dirname __FILE__}/common.gemfile")

platform :jruby do
  git_source(:github) do |repo_name|
    repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
    "https://github.com/#{repo_name}.git"
  end
  gem 'activerecord-jdbc-adapter', github: 'jruby/activerecord-jdbc-adapter'
  # gem 'activerecord-jdbcderby-adapter', github: 'jruby/activerecord-jdbc-adapter'
  gem 'activerecord-jdbcpostgresql-adapter', github: 'jruby/activerecord-jdbc-adapter'
  gem 'activerecord-jdbcsqlite3-adapter', github: 'jruby/activerecord-jdbc-adapter'
  gem 'jdbc-postgres', github: 'jruby/activerecord-jdbc-adapter'
  gem 'jdbc-sqlite3', github: 'jruby/activerecord-jdbc-adapter'
end

gem 'activerecord', '~>7.1.0'
