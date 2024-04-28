begin
  require 'english'
rescue LoadError
end

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord-time/version'

Gem::Specification.new do |gem|
  gem.name = 'activerecord-time'
  gem.version = Activerecord::Time::VERSION
  gem.authors = ['Uwe Kubosch']
  gem.email = %w[uwe@kubosch.no]
  gem.description = 'A handler for storing TimeOfDay objects in ActiveRecord objects as sql time values.'
  gem.summary = 'A handler for storing TimeOfDay objects in ActiveRecord objects as sql time values.'
  gem.homepage = 'https://github.com/donv/activerecord-time'
  gem.license = 'MIT'
  gem.required_ruby_version = '>= 3.1'

  gem.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w[lib]

  gem.add_runtime_dependency 'activerecord', '~>7.0'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'rubocop-performance'
  gem.add_development_dependency 'rubocop-rails'
  gem.add_development_dependency 'rubocop-rake'
  gem.add_development_dependency 'simplecov'
end
