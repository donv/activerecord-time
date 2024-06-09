# frozen_string_literal: true

module Activerecord
  module Time
    module Quoting
      def quote(value)
        return "'#{value}'" if value.is_a?(TimeOfDay)

        super
      end

      def type_cast(value)
        return value.to_s if value.is_a?(TimeOfDay)

        super
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::AbstractAdapter.prepend Activerecord::Time::Quoting
