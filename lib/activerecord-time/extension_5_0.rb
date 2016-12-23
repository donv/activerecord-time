require 'active_record/connection_adapters/abstract/quoting'

module Activerecord::Time
  module Quoting
    def _quote(value)
      return "'#{value}'" if TimeOfDay === value
      super(value)
    end

    def _type_cast(value)
      return value.to_s if TimeOfDay === value
      super(value)
    end
  end
end

# ActiveRecord::ConnectionAdapters::Quoting.prepend Activerecord::Time::Quoting
ActiveRecord::ConnectionAdapters::AbstractAdapter.prepend Activerecord::Time::Quoting

module ActiveRecord
  module Type
    class Time < ActiveModel::Type::Time # :nodoc:
      private def cast_value(value)
        return value.time_of_day if value.is_a?(::DateTime) || value.is_a?(::Time)
        return value unless value.is_a?(::String)
        return if value.empty?
        TimeOfDay.parse value
      end
    end
  end
end
