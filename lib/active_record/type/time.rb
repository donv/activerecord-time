# frozen_string_literal: true

module ActiveRecord
  module Type
    class Time < ActiveModel::Type::Time
      include Internal::Timezone

      class Value < DelegateClass(::TimeOfDay) # :nodoc:
      end

      def map(value)
        value
      end

      def serialize(value)
        case value = super
        when ::TimeOfDay
          Value.new(value)
        else
          value
        end
      end

      def serialize_cast_value(value)
        Value.new(value) if value
      end

      private def cast_value(value)
        return value.time_of_day if value.is_a?(::DateTime) || value.is_a?(::Time)
        return value unless value.is_a?(::String)
        return if value.empty?

        TimeOfDay._parse(value)
      end
    end
  end
end
