source 'https://rubygems.org'

# Specify your gem's dependencies in activerecord-time.gemspec
gemspec

if ENV['AR_VERSION']
  gem 'activerecord', ENV['AR_VERSION']
end

# TODO(uwe): Remove when ARJDBC 1.4.0 is out
if RUBY_ENGINE == 'jruby'
  gem 'activerecord-jdbc-adapter', '>= 1.3.17', github: 'jruby/activerecord-jdbc-adapter', branch: '1-3-stable'
end
# ODOT
