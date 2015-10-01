# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord-time/version'

Gem::Specification.new do |gem|
  gem.name = 'activerecord-time'
  gem.version = Activerecord::Time::VERSION
  gem.authors = ['Uwe Kubosch']
  gem.email = %w(uwe@kubosch.no)
  gem.description = %q{A handler for storing TimeOfDay objects in ActiveRecord objects as sql time values.}
  gem.summary = %q{A handler for storing TimeOfDay objects in ActiveRecord objects as sql time values.}
  gem.homepage = 'https://github.com/donv/activerecord-time'
  gem.license = 'MIT'
  gem.required_ruby_version = '>= 1.9.3'

  gem.files = `git ls-files`.split($/)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w(lib)

  gem.add_runtime_dependency 'activerecord', '>=3.2.21', '<5.0.0'

  if defined? JRUBY_VERSION
    gem.add_development_dependency 'activerecord-jdbcpostgresql-adapter'
    gem.add_development_dependency 'activerecord-jdbcsqlite3-adapter'
  else
    gem.add_development_dependency 'pg'
    gem.add_development_dependency 'sqlite3'
  end
  gem.add_development_dependency 'minitest-reporters'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'simplecov'
end
