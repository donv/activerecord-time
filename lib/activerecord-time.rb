require 'activerecord-time/version'
require 'active_record/version'
require 'time_of_day'
# TODO(uwe): Simplify when we stop supporing ActiveRecord 3.2
if ActiveRecord::VERSION::MAJOR < 3 ||
    (ActiveRecord::VERSION::MAJOR == 3 && ActiveRecord::VERSION::MINOR < 2)
  raise 'activerecord-time only supports ActiveRecord 3.2.21 or later'
# TODO(uwe): Simplify when we stop supporing ActiveRecord 4.0 and 4.1
elsif ActiveRecord::VERSION::MAJOR == 3 ||
    (ActiveRecord::VERSION::MAJOR == 4 && ActiveRecord::VERSION::MINOR <= 1)
  require 'activerecord-time/extension_until_4_1'
elsif ActiveRecord.gem_version >= Gem::Version.new('4.2.0')
  require 'activerecord-time/extension_4_2'
end
