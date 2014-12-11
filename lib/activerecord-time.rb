require 'activerecord-time/version'
require 'time_of_day'
if defined?(JRUBY_VERSION)
  require 'activerecord-time/extension_arjdbc'
else
  require 'activerecord-time/extension_mri'
end

module Arel
  module Visitors
    class Arel::Visitors::Visitor
      def visit_TimeOfDay o, a
        "'#{o.to_s(:db)}'"
      end
    end
  end
end
