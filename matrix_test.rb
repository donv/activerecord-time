#!/usr/bin/env ruby -w
# frozen_string_literal: true

system('rubocop --auto-correct') || exit(1)

update_gemfiles = ARGV.delete('--update')

require 'yaml'
travis = YAML.safe_load(File.read('.travis.yml'))

def run_script(ruby, env, gemfile)
  env.scan(/\b(?<key>[A-Z_]+)="(?<value>.+?)"/) do |key, value|
    ENV[key] = value
  end
  puts '*' * 80
  puts "Testing #{ruby} #{gemfile} #{env}"
  puts
  system("chruby-exec #{ruby} -- bundle exec rake") || exit(1)
  puts '*' * 80
  puts
end

def use_gemfile(ruby, gemfile, update_gemfiles)
  puts '$' * 80
  puts "Testing #{gemfile}"
  puts
  ENV['BUNDLE_GEMFILE'] = gemfile
  system "chruby-exec #{ruby} -- bundle -v"
  if update_gemfiles
    system "chruby-exec #{ruby} -- bundle update"
  else
    system "chruby-exec #{ruby} -- bundle check || chruby-exec #{ruby} -- bundle install"
  end || exit(1)
  yield
  puts "Testing #{gemfile} OK"
  puts '$' * 80
end

bad_variants = (travis.dig('matrix', 'exclude').to_a + travis.dig('matrix', 'allow_failures').to_a)

travis['env']['global'].each do |env|
  env.scan(/\b(?<key>[A-Z_]+)="(?<value>.+?)"/) do |key, value|
    ENV[key] = value
  end
end

travis['rvm'].each do |ruby|
  next if /head/.match?(ruby) # ruby-install does not support HEAD installation

  puts '#' * 80
  puts "Testing #{ruby}"
  puts
  system "ruby-install --no-reinstall #{ruby}" || exit(1)
  bundler_version = '1.17.2'
  gem_cmd = "chruby-exec #{ruby} -- gem"
  system "#{gem_cmd} uninstall --force --all --version '!=#{bundler_version}' bundler"
  bundler_gem_check_cmd = "#{gem_cmd} query -i -n '^bundler$' -v '#{bundler_version}' >/dev/null"
  bundler_install_cmd = "#{gem_cmd} install bundler -v '#{bundler_version}'"
  system "#{bundler_gem_check_cmd} || #{bundler_install_cmd}" || exit(1)
  travis['gemfile'].each do |gemfile|
    use_gemfile(ruby, gemfile, update_gemfiles) do
      travis['env']['matrix'].each do |env|
        bad_variant = bad_variants.any? do |f|
          (f['rvm'].nil? || f['rvm'] == ruby) &&
              (f['gemfile'].nil? || f['gemfile'] == gemfile) && (f['env'].nil? || f['env'] == env)
        end
        if bad_variant
          puts 'Skipping known failure.'
          next
        end
        run_script(ruby, env, gemfile)
      end
    end
  end
  puts "Testing #{ruby} OK"
  puts '#' * 80
end

print "\033[0;32m"
print '                        TESTS PASSED OK!'
puts "\033[0m"
