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
        return nil if string.empty?
        TimeOfDay.parse(string)
      end
    end
    module Quoting
      def quote_with_time_of_day(value, column = nil)
        return "'#{quoted_time(value)}'" if TimeOfDay === value
        quote_without_time_of_day(value, column)
      end

      alias_method_chain :quote, :time_of_day

      def quoted_time(value)
        value.to_s
      end
    end
  end
end
