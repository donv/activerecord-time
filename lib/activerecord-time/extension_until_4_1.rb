require 'active_record/connection_adapters/abstract/quoting'

module ActiveRecord
  module ConnectionAdapters
    class Column
      def klass_with_time_of_day
        return TimeOfDay if :time === type
        klass_without_time_of_day
      end

      alias_method_chain :klass, :time_of_day

      def self.string_to_dummy_time(string)
        return string if string.is_a? TimeOfDay
        return string.time_of_day if string.is_a? ::Time
        return nil if string.empty?
        TimeOfDay.parse(string)
      end
    end
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
