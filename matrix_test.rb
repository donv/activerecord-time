#!/usr/bin/env ruby -w
# frozen_string_literal: true

system('rubocop --autocorrect-all') || exit(1)

update_gemfiles = ARGV.delete('--update')

require 'yaml'
require 'bundler'
actions = YAML.safe_load_file('.github/workflows/test.yml')

def run_script(ruby, env, gemfile)
  env.each do |key, value|
    ENV[key.to_s] = value
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
  ENV['BUNDLE_GEMFILE'] = "gemfiles/gems_#{gemfile}.rb"
  if update_gemfiles
    system "chruby-exec #{ruby} -- bundle update && chruby-exec #{ruby} -- bundle update --bundler"
  else
    system "chruby-exec #{ruby} -- bundle check || chruby-exec #{ruby} -- bundle install"
  end || exit(1)
  yield
  puts "Testing #{gemfile} OK"
  puts '$' * 80
end

def bad_variant?(bad_variants, ruby, gemfile = nil, adapter = nil)
  bad_variants&.find do |f|
    !(ruby.nil? ^ f['ruby'].nil?) && f['ruby'] == ruby &&
        !(gemfile.nil? ^ f['gemfile'].nil?) && f['gemfile'] == gemfile &&
        !(adapter.nil? ^ f['adapter'].nil?) && f['adapter'] == adapter
  end
end

actions['env'].each do |key, value|
  ENV[key] = value
end

matrix = actions['jobs']['Test']['strategy']['matrix']
bad_variants = matrix['exclude']

matrix['ruby'].each do |ruby|
  next if bad_variant?(bad_variants, ruby)

  puts '#' * 80
  puts "Testing #{ruby}"
  puts
  Bundler.with_unbundled_env do
    system("ruby-install --no-reinstall #{ruby}") || exit(1)
    matrix['gemfile'].each do |gemfile|
      next if bad_variant?(bad_variants, ruby, gemfile)

      use_gemfile(ruby, gemfile, update_gemfiles) do
        matrix['adapter'].each do |adapter|
          next if bad_variant?(bad_variants, ruby, gemfile, adapter)

          puts '-' * 80
          puts "Testing #{adapter}"
          puts

          run_script(ruby, { ADAPTER: adapter }, gemfile)
        end
      end
    end
  end
  puts "Testing #{ruby} OK"
  puts '#' * 80
end

print "\033[0;32m"
print '                        TESTS PASSED OK!'
puts "\033[0m"
