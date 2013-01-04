# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord-time/version'

Gem::Specification.new do |gem|
  gem.name          = "activerecord-time"
  gem.version       = Activerecord::Time::VERSION
  gem.authors       = ["Uwe Kubosch"]
  gem.email         = ["uwe@kubosch.no"]
  gem.description   = %q{A handler for storing TimeOfDay objects in ActiveRecord objects as sql time values.}
  gem.summary       = %q{A handler for storing TimeOfDay objects in ActiveRecord objects as sql time values.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
