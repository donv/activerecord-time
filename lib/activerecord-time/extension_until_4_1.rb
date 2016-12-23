require 'active_record/connection_adapters/abstract/quoting'

module ActiveRecord
  module ConnectionAdapters
    module Quoting
      def quote_with_time_of_day(value, column = nil)
        if column && column.type == :time && Integer === value
          value = TimeOfDay.new(value / 3600, (value % 3600) / 60, value % 60)
        end
        return "'#{value.to_s(:db)}'" if TimeOfDay === value
        quote_without_time_of_day(value, column)
      end
      alias_method_chain :quote, :time_of_day
      def type_cast_with_time_of_day(value, column)
        return value.to_s if TimeOfDay === value
        type_cast_without_time_of_day(value, column)
      end
      alias_method_chain :type_cast, :time_of_day
    end
  end
end

module Activerecord::Time
  module DummyTime
    def klass
      return TimeOfDay if :time === type
      super
    end

    module ClassMethods
      def string_to_dummy_time(value)
        return value if value.is_a? TimeOfDay
        return value.time_of_day if value.is_a? ::Time
        return nil if value.empty?
        TimeOfDay.parse(value)
      end
    end

    def self.prepended(base)
      class << base
        prepend ClassMethods
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::Column.prepend Activerecord::Time::DummyTime

module Arel
  module Visitors
    class Arel::Visitors::Visitor
      if Gem::Version.new(Arel::VERSION) >= Gem::Version.new('5.0.0')
        def visit_TimeOfDay o, a
          "'#{o.to_s(:db)}'"
        end
      else
        def visit_TimeOfDay o
          "'#{o.to_s(:db)}'"
        end
      end
    end
  end
end
