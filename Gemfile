# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in activerecord-time.gemspec
gemspec

eval File.read("#{__dir__}/gemfiles/common.gemfile") # rubocop:disable Security/Eval

gem 'activerecord', ENV['AR_VERSION'] if ENV['AR_VERSION']
