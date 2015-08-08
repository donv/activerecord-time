#!/usr/bin/env ruby -w

require 'yaml'
travis = YAML.load(File.read('.travis.yml'))

travis['rvm'].each do |ruby|
  puts '#' * 80
  puts "Testing #{ruby}"
  puts
  system "rvm install #{ruby}"
  exit $? unless $? == 0
  system "rvm #{ruby} do gem install bundler"
  exit $? unless $? == 0
  travis['gemfile'].each do |gemfile|
    puts '$' * 80
    puts "Testing #{gemfile}"
    puts
    ENV['BUNDLE_GEMFILE'] = gemfile
    system "rvm #{ruby} do bundle install"
    exit $?.exitstatus unless $? == 0
    travis['env'].each do |env|
      env.scan(/\b(?<key>[A-Z_]+)="?(?<value>.+?)"?\b/) do |key, value|
        ENV[key] = value
        puts '*' * 80
        puts "Testing #{ruby} #{gemfile} #{env}"
        puts
        system "rvm #{ruby} do bundle exec rake"
        exit $? unless $? == 0
        puts '*' * 80
      end
    end
    puts "Testing #{gemfile} OK"
    puts '$' * 80
  end
  puts "Testing #{ruby} OK"
  puts '#' * 80
end

print "\033[0;32m"
print '                        TESTS PASSED OK!'
puts "\033[0m"
