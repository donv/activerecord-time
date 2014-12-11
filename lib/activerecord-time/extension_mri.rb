require 'active_record/connection_adapters/abstract/quoting'

module ActiveRecord
  module ConnectionAdapters # :nodoc:
    module Quoting
      def type_cast_with_time_of_day(value, column)
        return value.to_s if TimeOfDay === value
        type_cast_without_time_of_day(value, column)
      end

      alias_method_chain :type_cast, :time_of_day

      def quote_with_time_of_day(value, column = nil)
        if column && column.type == :time && Integer === value
          value = TimeOfDay.new(value / 3600, (value % 3600) / 60, value % 60)
        end
        return "'#{value.to_s(:db)}'" if TimeOfDay === value
        quote_without_time_of_day(value, column)
      end

      alias_method_chain :quote, :time_of_day

    end
  end
end
