module ActiveRecord
  module ConnectionAdapters
    module Quoting
      def _quote_with_time_of_day(value)
        return "'#{value}'" if TimeOfDay === value
        _quote_without_time_of_day(value)
      end
      alias_method_chain :_quote, :time_of_day
      def _type_cast_with_time_of_day(value)
        return value.to_s if TimeOfDay === value
        _type_cast_without_time_of_day(value)
      end
      alias_method_chain :_type_cast, :time_of_day
    end
  end
end
module Activerecord
  module Time
    module TypeCast
      private
      def cast_value(value)
        return value.time_of_day if value.is_a?(::DateTime) || value.is_a?(::Time)
        return value unless value.is_a?(::String)
        return if value.empty?
        TimeOfDay.parse value
      end
    end
  end
end
ActiveRecord::Type::Time.prepend Activerecord::Time::TypeCast
