#!/usr/bin/env ruby -w

system 'rubocop --auto-correct'

update_gemfiles = ARGV.delete('--update')

require 'yaml'
travis = YAML.load(File.read('.travis.yml'))

travis['rvm'].each do |ruby|
  puts '#' * 80
  puts "Testing #{ruby}"
  puts
  system "ruby-install --no-reinstall #{ruby}"
  exit $?.exitstatus unless $? == 0
  system "chruby-exec #{ruby} -- gem query -i -n bundler >/dev/null || chruby-exec #{ruby} -- gem install bundler"
  exit $?.exitstatus unless $? == 0
  travis['gemfile'].each do |gemfile|
    if travis['matrix']['allow_failures'].any? { |f| f['rvm'] == ruby && f['gemfile'] == gemfile }
      puts 'Skipping allowed failure.'
      next
    end
    puts '$' * 80
    puts "Testing #{gemfile}"
    puts
    ENV['BUNDLE_GEMFILE'] = gemfile
    if update_gemfiles
      system "chruby-exec #{ruby} -- bundle update"
    else
      system "chruby-exec #{ruby} -- bundle check || chruby-exec #{ruby} -- bundle install"
    end
    exit $?.exitstatus unless $? == 0
    travis['env'].each do |env|
      env.scan(/\b(?<key>[A-Z_]+)="(?<value>.+?)"/) do |key, value|
        ENV[key] = value
      end
      puts '*' * 80
      puts "Testing #{ruby} #{gemfile} #{env}"
      puts
      system "chruby-exec #{ruby} -- bundle exec rake"
      exit $?.exitstatus unless $? == 0
      puts '*' * 80
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
