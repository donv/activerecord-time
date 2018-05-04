require 'activerecord-time/version'
require 'active_record/version'
require 'time_of_day'
require 'time_of_day/core_ext'

# TODO(uwe): Simplify when we stop supporting ActiveRecord 3.2
if ActiveRecord::VERSION::MAJOR < 3 ||
      (ActiveRecord::VERSION::MAJOR == 3 && ActiveRecord::VERSION::MINOR < 2)
  raise 'activerecord-time only supports ActiveRecord 3.2.21 or later'
# TODO(uwe): Simplify when we stop supporting ActiveRecord 4.0 and 4.1
elsif ActiveRecord::VERSION::MAJOR == 3 ||
      (ActiveRecord::VERSION::MAJOR == 4 && ActiveRecord::VERSION::MINOR <= 1)
  require 'activerecord-time/extension_until_4_1'
# TODO(uwe): Simplify when we stop supporting ActiveRecord 4.2
elsif ActiveRecord::VERSION::MAJOR == 4 && ActiveRecord::VERSION::MINOR >= 2
  require 'activerecord-time/extension_4_2'
elsif ActiveRecord.gem_version >= Gem::Version.new('5.0.0')
  require 'activerecord-time/extension_5_0'
end
